--print ('[ABYSS_GATES] abyss_gates.lua' )


CORPSE_MODEL = "models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_troll_skeleton_fx.vmdl"
CORPSE_DURATION = 88

ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 1              -- How long should we let people select their hero?
PRE_GAME_TIME = 0                    -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 60.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 4                     -- How much gold should players get per tick?
GOLD_TICK_TIME = 2                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = true     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
CAMERA_DISTANCE_OVERRIDE = 1400.0        -- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                    -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = true      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = false                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = true      -- Should we disable fog of war entirely for both teams?
										-- NOTE: This won't reveal particle effects for everyone. You need to create vision dummies for that.

--USE_STANDARD_DOTA_BOT_THINKING = false  -- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = false    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false  -- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = true                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 50         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 50                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = false             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

Testing = true
OutOfWorldVector = Vector(11000, 11000, -200)

if not Testing then
  statcollection.addStats({
    modID = 'XXXXXXXXXXXXXXXXXXX'
  })
end

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = i * 100
end

-- Generated from template
if Abyss_Gates == nil then
	--print ( '[ABYSS_GATES] creating abyss_gates game mode' )
	Abyss_Gates = class({})
end


-- Custom Corpse Mechanic
function LeavesCorpse( unit )
	
	-- Heroes don't leave corpses (includes illusions)
	if unit:IsHero() then
		return false

	-- Ignore units that start with dummy keyword	
	elseif string.find(unit:GetUnitName(), "dummy") then
		return false

	-- Ignore units that were specifically set to leave no corpse
	elseif unit.no_corpse then
		return false

	-- Leave corpse
	else
		print("Leave corpse")
		return true
	end
end

function SetNoCorpse( event )
	event.target.no_corpse = true
end

function Abyss_Gates:PostLoadPrecache()
	--print("[ABYSS_GATES] Performing Post-Load precache")

	PrecacheUnitByNameAsync("npc_precache_everything", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitAbyss_Gates() but needs to be done before everyone loads in.
]]
function Abyss_Gates:OnFirstPlayerLoaded()
	--print("[ABYSS_GATES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function Abyss_Gates:OnAllPlayersLoaded()
	--print("[ABYSS_GATES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in.
]]
function Abyss_Gates:OnHeroInGame(hero)
	--print("[ABYSS_GATES] Hero spawned in game for first time -- " .. hero:GetUnitName())

	if not self.greetPlayers then
		-- At this point a player now has a hero spawned in your map.
		
	    local firstLine = ColorIt("Welcome to ", "green") .. ColorIt("Abyss_Gates! ", "magenta") .. ColorIt("v0.1", "blue");
	    local secondLine = ColorIt("Developer: ", "green") .. ColorIt("XXX", "orange")
		-- Send the first greeting in 4 secs.
		Timers:CreateTimer(4, function()
	        GameRules:SendCustomMessage(firstLine, 0, 0)
	        GameRules:SendCustomMessage(secondLine, 0, 0)
		end)

		self.greetPlayers = true
	end

	-- Store a reference to the player handle inside this hero handle.
	hero.player = PlayerResource:GetPlayer(hero:GetPlayerID())
	-- Store the player's name inside this hero handle.
	hero.playerName = PlayerResource:GetPlayerName(hero:GetPlayerID())
	-- Store this hero handle in this table.
	table.insert(self.vPlayers, hero)

	if Testing then
		Say(nil, "Testing is on.", false)
	end

	InitAbilities(hero)

	-- Show a popup with game instructions.
    ShowGenericPopupToPlayer(hero.player, "#abyss_gates_instructions_title", "#abyss_gates_instructions_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )

	-- This line for example will set the starting gold of every hero to 500 unreliable gold
	hero:SetGold(1000000, false)

	-- These lines will create an item and add it to the player, effectively ensuring they start with the item
	local item = CreateItem("item_example_item", hero, hero)
	hero:AddItem(item)
end

--[[
	This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function Abyss_Gates:OnGameInProgress()
	--print("[ABYSS_GATES] The game has officially begun")

	Timers:CreateTimer(12, function() -- Start this timer 30 game-time seconds later
		--print("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")

		WaveOneRoundOne()
	end)

	Timers:CreateTimer(22, function()
		WaveOneRoundTwo()
	end)

	Timers:CreateTimer(32, function()
		WaveOneRoundThree()
	end)

	Timers:CreateTimer(42, function()
		WaveOneRoundFour()
	end)

	Timers:CreateTimer(52, function()
		WaveOneRoundFive()
	end)

	Timers:CreateTimer(62, function()
		WaveOneRoundSix()
	end)

	Timers:CreateTimer(100, function()
		WaveTwoRoundOne()
	end)

	Timers:CreateTimer(110, function()
		WaveTwoRoundTwo()
	end)

	Timers:CreateTimer(120, function()
		WaveTwoRoundThree()
	end)

	Timers:CreateTimer(130, function()
		WaveTwoRoundFour()
	end)

	Timers:CreateTimer(166, function()
		WaveThreeRoundOne()
	end)

	Timers:CreateTimer(176, function()
		WaveThreeRoundTwo()
	end)

	Timers:CreateTimer(186, function()
		WaveThreeRoundThree()
	end)

	Timers:CreateTimer(196, function()
		WaveThreeRoundFour()
	end)

	Timers:CreateTimer(206, function()
		WaveThreeRoundFive()
	end)

	Timers:CreateTimer(216, function()
		WaveThreeRoundSix()
	end)

	Timers:CreateTimer(226, function()
		WaveThreeRoundSeven()
	end)

	Timers:CreateTimer(236, function()
		WaveThreeRoundEight()
	end)

	Timers:CreateTimer(272, function()
		WaveFourRoundOne()
	end)

	Timers:CreateTimer(286, function()
		WaveFourRoundTwo()
	end)

	Timers:CreateTimer(302, function()
		WaveFourRoundThree()
	end)

	Timers:CreateTimer(316, function()
		WaveFourRoundFour()
	end)

	Timers:CreateTimer(330, function()
		WaveFourRoundFive()
	end)

	Timers:CreateTimer(344, function()
		WaveFourRoundSix()
	end)

	Timers:CreateTimer(358, function()
		WaveFourRoundSeven()
	end)

	Timers:CreateTimer(372, function()
		WaveFourRoundEight()
	end)

	Timers:CreateTimer(412, function()
		WaveFiveRoundOne()
	end)

	Timers:CreateTimer(422, function()
		WaveFiveRoundTwo()
	end)

	Timers:CreateTimer(432, function()
		WaveFiveRoundThree()
	end)

	Timers:CreateTimer(442, function()
		WaveFiveRoundFour()
	end)

	Timers:CreateTimer(452, function()
		WaveFiveRoundFive()
	end)

	Timers:CreateTimer(462, function()
		WaveFiveRoundSix()
	end)

	Timers:CreateTimer(472, function()
		WaveFiveRoundSeven()
	end)

	Timers:CreateTimer(482, function()
		WaveFiveRoundEight()
	end)

	Timers:CreateTimer(518, function()
		WaveSixRoundOne()
	end)

	Timers:CreateTimer(668, function()
		WaveSevenRoundOne()
	end)

	Timers:CreateTimer(678, function()
		WaveSevenRoundTwo()
	end)

	Timers:CreateTimer(688, function()
		WaveSevenRoundThree()
	end)

	Timers:CreateTimer(698, function()
		WaveSevenRoundFour()
	end)

	Timers:CreateTimer(708, function()
		WaveSevenRoundFive()
	end)

	Timers:CreateTimer(718, function()
		WaveSevenRoundSix()
	end)

	Timers:CreateTimer(728, function()
		WaveSevenRoundSeven()
	end)

	Timers:CreateTimer(738, function()
		WaveSevenRoundEight()
	end)

	Timers:CreateTimer(774, function()
		WaveEightRoundOne()
	end)

	Timers:CreateTimer(788, function()
		WaveEightRoundTwo()
	end)

	Timers:CreateTimer(800, function()
		WaveEightRoundThree()
	end)

	Timers:CreateTimer(812, function()
		WaveEightRoundFour()
	end)

	Timers:CreateTimer(824, function()
		WaveEightRoundFive()
	end)

	Timers:CreateTimer(838, function()
		WaveEightRoundSix()
	end)

	Timers:CreateTimer(852, function()
		WaveEightRoundSeven()
	end)

	Timers:CreateTimer(866, function()
		WaveEightRoundEight()
	end)

	Timers:CreateTimer(905, function()
		WaveNineRoundOne()
	end)

		Timers:CreateTimer(915, function()
		WaveNineRoundTwo()
	end)

	Timers:CreateTimer(925, function()
		WaveNineRoundThree()
	end)

	Timers:CreateTimer(935, function()
		WaveNineRoundFour()
	end)

	Timers:CreateTimer(945, function()
		WaveNineRoundFive()
	end)

	Timers:CreateTimer(955, function()
		WaveNineRoundSix()
	end)

	Timers:CreateTimer(965, function()
		WaveNineRoundSeven()
	end)

	Timers:CreateTimer(975, function()
		WaveNineRoundEight()
	end)

	Timers:CreateTimer(1012, function()
		WaveTenRoundOne()
	end)

	Timers:CreateTimer(1024, function()
		WaveTenRoundTwo()
	end)

	Timers:CreateTimer(1036, function()
		WaveTenRoundThree()
	end)

	Timers:CreateTimer(1048, function()
		WaveTenRoundFour()
	end)

	Timers:CreateTimer(1060, function()
		WaveTenRoundFive()
	end)

	Timers:CreateTimer(1072, function()
		WaveTenRoundSix()
	end)

	Timers:CreateTimer(1084, function()
		WaveTenRoundSeven()
	end)

	Timers:CreateTimer(1096, function()
		WaveTenRoundEight()
	end)

end


function SpawnCreeps()
	local point = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
end

function WaveOneRoundOne()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveOneRoundTwo()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_corrupted_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_corrupted_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveOneRoundThree()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveOneRoundFour()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_corrupted_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_corrupted_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveOneRoundFive()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveOneRoundSix()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_corrupted_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_boar", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_corrupted_boar", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveTwoRoundOne()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveTwoRoundTwo()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper_venomancer", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper_venomancer", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveTwoRoundThree()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveTwoRoundFour()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper_venomancer", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_grasper_venomancer", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveThreeRoundOne()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_mauler", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_kerrang", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_mauler", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveThreeRoundTwo()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_mauler", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_mauler", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveThreeRoundThree()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
		
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end


function WaveThreeRoundFour()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_mauler", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_mauler", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveThreeRoundFive()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
		
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveThreeRoundSix()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_mauler", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_mauler", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveThreeRoundSeven()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveThreeRoundEight()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_mauler", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_clasper", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_mervian_mauler", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFourRoundOne()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFourRoundTwo()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_nightshade_huntress", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_nightshade_huntress", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFourRoundThree()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFourRoundFour()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_nightshade_huntress", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_nightshade_huntress", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFourRoundFive()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFourRoundSix()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_nightshade_huntress", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_nightshade_huntress", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFourRoundSeven()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFourRoundEight()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_nightshade_huntress", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_dryad", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_nightshade_huntress", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFiveRoundOne()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFiveRoundTwo()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_arachnesser", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_arachnesser", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFiveRoundThree()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFiveRoundFour()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_arachnesser", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_arachnesser", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end


function WaveFiveRoundFive()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFiveRoundSix()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_arachnesser", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_arachnesser", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end


function WaveFiveRoundSeven()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveFiveRoundEight()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_arachnesser", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_harlequin_spider", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_arachnesser", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveSixRoundOne()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_tgarri", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveSevenRoundOne()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveSevenRoundTwo()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_ancient_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_ancient_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveSevenRoundThree()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveSevenRoundFour()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_ancient_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_ancient_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveSevenRoundFive()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveSevenRoundSix()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_ancient_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_ancient_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
function WaveSevenRoundSeven()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveSevenRoundEight()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_ancient_turtle", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_great_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_ancient_turtle", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveEightRoundOne()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveEightRoundTwo()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_shaman", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_shaman", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveEightRoundThree()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveEightRoundFour()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_shaman", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_shaman", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveEightRoundFive()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveEightRoundSix()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_shaman", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_shaman", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveEightRoundSeven()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveEightRoundEight()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_shaman", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)

	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_hunter", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_centaur_shaman", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveNineRoundOne()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_cleanser", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_oghmar_grayskin", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_cleanser", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveNineRoundTwo()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_cleanser", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_cleanser", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveNineRoundThree()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveNineRoundFour()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_cleanser", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_cleanser", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveNineRoundFive()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveNineRoundSix()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_cleanser", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_cleanser", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveNineRoundSeven()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function WaveNineRoundEight()
	local spawnerTop = Entities:FindByName( nil, 'spawner_two'):GetAbsOrigin()
	local spawnerBot = Entities:FindByName( nil, 'spawner_one'):GetAbsOrigin()

	--[[Spawns 5 Boars in the top spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_cleanser", spawnerTop, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	--[[Spawns 5 Boars in the bottom spawner]]
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_warrior", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
	local unit = CreateUnitByName("creature_tauren_cleanser", spawnerBot, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

function Abyss_Gates:PlayerSay( keys )
	local ply = keys.ply
	local hero = ply:GetAssignedHero()
	local txt = keys.text

	if keys.teamOnly then
		-- This text was team-only.
	end

	if txt == nil or txt == "" then
		return
	end

  -- At this point we have valid text from a player.
	--print("P" .. ply .. " wrote: " .. keys.text)
end

-- Cleanup a player when they leave
function Abyss_Gates:OnDisconnect(keys)
	--print('[ABYSS_GATES] Player Disconnected ' .. tostring(keys.userid))
	--PrintTable(keys)

	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid
end

-- The overall game state has changed
function Abyss_Gates:OnGameRulesStateChange(keys)
	--print("[ABYSS_GATES] GameRules State Changed")
	--PrintTable(keys)

	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		self.bSeenWaitForPlayers = true
	elseif newState == DOTA_GAMERULES_STATE_INIT then
		Timers:RemoveTimer("alljointimer")
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		local et = 6
		if self.bSeenWaitForPlayers then
			et = .01
		end
		Timers:CreateTimer("alljointimer", {
			useGameTime = true,
			endTime = et,
			callback = function()
				if PlayerResource:HaveAllPlayersJoined() then
					Abyss_Gates:PostLoadPrecache()
					Abyss_Gates:OnAllPlayersLoaded()
					return
				end
				return 1
			end})
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		Abyss_Gates:OnGameInProgress()
	end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function Abyss_Gates:OnNPCSpawned(keys)
	--print("[ABYSS_GATES] NPC Spawned")
	--PrintTable(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		Abyss_Gates:OnHeroInGame(npc)
	end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function Abyss_Gates:OnEntityHurt(keys)
	--print("[ABYSS_GATES] Entity Hurt")
	--PrintTable(keys)
	local attacker = EntIndexToHScript(keys.entindex_attacker)
	local victim = EntIndexToHScript(keys.entindex_killed)
end

-- An item was picked up off the ground
function Abyss_Gates:OnItemPickedUp(keys)
	--print ( '[ABYSS_GATES] OnItemPurchased' )
	--PrintTable(keys)

	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function Abyss_Gates:OnPlayerReconnect(keys)
	--print ( '[ABYSS_GATES] OnPlayerReconnect' )
	--PrintTable(keys)
end

-- An item was purchased by a player
function Abyss_Gates:OnItemPurchased( keys )
    --print ( '[ABYSS_GATES] OnItemPurchased' )
    --PrintTable(keys)
 
    -- The playerID of the hero who is buying something
    local plyID = keys.PlayerID
    local player = PlayerResource:GetPlayer(plyID)
    local hero = player:GetAssignedHero()
    if not plyID then return end
 
    local itemName = keys.itemname
 
    -- The cost of the item purchased
    local itemcost = keys.itemcost
 
    local mainHandCheck = hero:GetModifierStackCount("modifier_main_hand", ability)
    local offHandCheck = hero:GetModifierStackCount("modifier_off_hand", ability)
    local twoHandCheck = hero:GetModifierStackCount("modifier_two_hand", ability)
    local chestCheck = hero:GetModifierStackCount("modifier_chest", ability)
    print(mainHandCheck)
    print(offHandCheck)
    print(twoHandCheck)
    print(chestCheck)

    if mainHandCheck > 1 then
        local foundMainHandItem = false
        for i=0,5 do
            local item = hero:GetItemInSlot(i)
            if item then
                local item_name = item:GetAbilityName()
                print(item_name)
                if foundMainHandItem and string.find(item_name, "main_hand") then
                	GameRules.Tooltips = LoadKeyValues("resource/addon_english.txt")
                	real_item_name = GameRules.Tooltips["Tokens"]["DOTA_Tooltip_ability_"..item_name]
                	local mainHandMessage = ColorIt("You may only have one Main Hand weapon equipped.", "red")
                	local itemNameMessage = real_item_name .. " " .. "has been sold."	     
	       			GameRules:SendCustomMessage(mainHandMessage, 0, 0)
	       			GameRules:SendCustomMessage(itemNameMessage, 0, 0)
	       			hero:SellItem(item)
                end
 
                if string.find(item_name, "main_hand") then
                    foundMainHandItem = true
                end
            end
        end
    end


    if offHandCheck > 1 then
        local foundOffHandItem = false
        for i=0,5 do
            local item = hero:GetItemInSlot(i)
            if item then
                local item_name = item:GetAbilityName()
                print(item_name)
                if foundOffHandItem and string.find(item_name, "off_hand") then
                	GameRules.Tooltips = LoadKeyValues("resource/addon_english.txt")
                	real_item_name = GameRules.Tooltips["Tokens"]["DOTA_Tooltip_ability_"..item_name]
                	local offHandMessage = ColorIt("You may only have one Off Hand weapon equipped.", "red")
                	local itemNameMessage = real_item_name .. " " .. "has been sold."	     
	       			GameRules:SendCustomMessage(offHandMessage, 0, 0)
	       			GameRules:SendCustomMessage(itemNameMessage, 0, 0)
                    hero:SellItem(item)
                end
 
                if string.find(item_name, "off_hand") then
                    foundOffHandItem = true
                end
            end
        end
    end


    if chestCheck > 1 then
        local foundChestItem = false
        for i=0,5 do
            local item = hero:GetItemInSlot(i)
            if item then
                local item_name = item:GetAbilityName()
                print(item_name)
                if foundChestItem and string.find(item_name, "chest") then
                	GameRules.Tooltips = LoadKeyValues("resource/addon_english.txt")
                	real_item_name = GameRules.Tooltips["Tokens"]["DOTA_Tooltip_ability_"..item_name]
                	local chestItemMessage = ColorIt("You may only have one chest piece equipped.", "red")
                	local itemNameMessage = real_item_name .. " " .. "has been sold."	     
	       			GameRules:SendCustomMessage(chestItemMessage, 0, 0)
	       			GameRules:SendCustomMessage(itemNameMessage, 0, 0)
                    hero:SellItem(item)
                end
 
                if string.find(item_name, "chest") then
                    foundChestItem = true
                end
            end
        end
    end


    if twoHandCheck > 1 then
        local foundTwoHandItem = false
        for i=0,5 do
            local item = hero:GetItemInSlot(i)
            if item then
                local item_name = item:GetAbilityName()
                print(item_name)
                if foundTwoHandItem and string.find(item_name, "two_hand") then
                	GameRules.Tooltips = LoadKeyValues("resource/addon_english.txt")
                	real_item_name = GameRules.Tooltips["Tokens"]["DOTA_Tooltip_ability_"..item_name]
                	local twoHandMessage = ColorIt("You may only have one chest piece equipped.", "red")
                	local itemNameMessage = real_item_name .. " " .. "has been sold."	     
	       			GameRules:SendCustomMessage(twoHandMessage, 0, 0)
	       			GameRules:SendCustomMessage(itemNameMessage, 0, 0)
                    hero:SellItem(item)
                end
 
                if string.find(item_name, "two_hand") then
                    foundtwoHandItem = true
                end
            end
        end
    end
end

-- An ability was used by a player
function Abyss_Gates:OnAbilityUsed(keys)
	--print('[ABYSS_GATES] AbilityUsed')
	--PrintTable(keys)

	local player = EntIndexToHScript(keys.PlayerID)
	local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function Abyss_Gates:OnNonPlayerUsedAbility(keys)
	--print('[ABYSS_GATES] OnNonPlayerUsedAbility')
	--PrintTable(keys)

	local abilityname=  keys.abilityname
end

-- A player changed their name
function Abyss_Gates:OnPlayerChangedName(keys)
	--print('[ABYSS_GATES] OnPlayerChangedName')
	--PrintTable(keys)

	local newName = keys.newname
	local oldName = keys.oldName
end

-- A player leveled up an ability
function Abyss_Gates:OnPlayerLearnedAbility( keys)
	--print ('[ABYSS_GATES] OnPlayerLearnedAbility')
	--PrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function Abyss_Gates:OnAbilityChannelFinished(keys)
	--print ('[ABYSS_GATES] OnAbilityChannelFinished')
	--PrintTable(keys)

	local abilityname = keys.abilityname
	local interrupted = keys.interrupted == 1
end

-- A player leveled up
function Abyss_Gates:OnPlayerLevelUp(keys)
	--print ('[ABYSS_GATES] OnPlayerLevelUp')
	--PrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function Abyss_Gates:OnLastHit(keys)
	--print ('[ABYSS_GATES] OnLastHit')
	--PrintTable(keys)

	local isFirstBlood = keys.FirstBlood == 1
	local isHeroKill = keys.HeroKill == 1
	local isTowerKill = keys.TowerKill == 1
	local player = PlayerResource:GetPlayer(keys.PlayerID)
end

-- A tree was cut down by tango, quelling blade, etc
function Abyss_Gates:OnTreeCut(keys)
	--print ('[ABYSS_GATES] OnTreeCut')
	--PrintTable(keys)

	local treeX = keys.tree_x
	local treeY = keys.tree_y
end

-- A rune was activated by a player
function Abyss_Gates:OnRuneActivated (keys)
	--print ('[ABYSS_GATES] OnRuneActivated')
	--PrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local rune = keys.rune

	--[[ Rune Can be one of the following types
	DOTA_RUNE_DOUBLEDAMAGE
	DOTA_RUNE_HASTE
	DOTA_RUNE_HAUNTED
	DOTA_RUNE_ILLUSION
	DOTA_RUNE_INVISIBILITY
	DOTA_RUNE_MYSTERY
	DOTA_RUNE_RAPIER
	DOTA_RUNE_REGENERATION
	DOTA_RUNE_SPOOKY
	DOTA_RUNE_TURBO
	]]
end

-- A player took damage from a tower
function Abyss_Gates:OnPlayerTakeTowerDamage(keys)
	--print ('[ABYSS_GATES] OnPlayerTakeTowerDamage')
	--PrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local damage = keys.damage
end

-- A player picked a hero
function Abyss_Gates:OnPlayerPickHero(keys)
	--print ('[ABYSS_GATES] OnPlayerPickHero')
	--PrintTable(keys)

	local heroClass = keys.hero
	local heroEntity = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function Abyss_Gates:OnTeamKillCredit(keys)
	--print ('[ABYSS_GATES] OnTeamKillCredit')
	--PrintTable(keys)

	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
	local numKills = keys.herokills
	local killerTeamNumber = keys.teamnumber
end

-- An entity died
function Abyss_Gates:OnEntityKilled( keys )
	--print( '[ABYSS_GATES] OnEntityKilled Called' )
	--PrintTable( keys )

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- The Killing entity
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	if killedUnit:IsRealHero() then
		--print ("KILLEDKILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
		if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS and killerEntity:GetTeam() == DOTA_TEAM_GOODGUYS then
			self.nRadiantKills = self.nRadiantKills + 1
			if END_GAME_ON_KILLS and self.nRadiantKills >= KILLS_TO_END_GAME_FOR_TEAM then
				GameRules:SetSafeToLeave( true )
				GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
			end
		elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS and killerEntity:GetTeam() == DOTA_TEAM_BADGUYS then
			self.nDireKills = self.nDireKills + 1
			if END_GAME_ON_KILLS and self.nDireKills >= KILLS_TO_END_GAME_FOR_TEAM then
				GameRules:SetSafeToLeave( true )
				GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
			end
		end

		if SHOW_KILLS_ON_TOPBAR then
			GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, self.nDireKills )
			GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, self.nRadiantKills )
		end
	end

	-- Put code here to handle when an entity gets killed

	-- If the unit is supposed to leave a corpse, create a dummy_unit to use abilities on it.
	Timers:CreateTimer(1, function() 
	if LeavesCorpse( killedUnit ) then
			-- Create and set model
			local corpse = CreateUnitByName("dummy_unit", killedUnit:GetAbsOrigin(), true, nil, nil, killedUnit:GetTeamNumber())
			corpse:SetModel(CORPSE_MODEL)

			-- Set the corpse invisible until the dota corpse disappears
			corpse:AddNoDraw()
			
			-- Keep a reference to its name and expire time
			corpse.corpse_expiration = GameRules:GetGameTime() + CORPSE_DURATION
			corpse.unit_name = killedUnit:GetUnitName()
			corpse.max_health = killedUnit:GetMaxHealth()

			corpse:SetMaxHealth(corpse.max_health)

			print(corpse:GetMaxHealth())

			-- Set custom corpse visible
			Timers:CreateTimer(3, function() corpse:RemoveNoDraw() end)

			-- Remove itself after the corpse duration
			Timers:CreateTimer(CORPSE_DURATION, function()
				if corpse and IsValidEntity(corpse) then
					print("removing corpse")
					corpse:RemoveSelf()
				end
			end)
		end
	end)
end


-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function Abyss_Gates:InitAbyss_Gates()
	Abyss_Gates = self
	--print('[ABYSS_GATES] Starting to load Abyss_Gates gamemode...')

	-- Setup rules
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
	GameRules:SetGoldPerTick(GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GOLD_TICK_TIME)
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
	--print('[ABYSS_GATES] GameRules set')

	InitLogFile( "log/abyss_gates.txt","")

	-- Event Hooks
	-- All of these events can potentially be fired by the game, though only the uncommented ones have had
	-- Functions supplied for them.  If you are interested in the other events, you can uncomment the
	-- ListenToGameEvent line and add a function to handle the event
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(Abyss_Gates, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(Abyss_Gates, 'OnAbilityChannelFinished'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(Abyss_Gates, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(Abyss_Gates, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(Abyss_Gates, 'OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(Abyss_Gates, 'OnDisconnect'), self)
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(Abyss_Gates, 'OnItemPurchased'), self)
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(Abyss_Gates, 'OnItemPickedUp'), self)
	ListenToGameEvent('last_hit', Dynamic_Wrap(Abyss_Gates, 'OnLastHit'), self)
	ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(Abyss_Gates, 'OnNonPlayerUsedAbility'), self)
	ListenToGameEvent('player_changename', Dynamic_Wrap(Abyss_Gates, 'OnPlayerChangedName'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(Abyss_Gates, 'OnRuneActivated'), self)
	ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(Abyss_Gates, 'OnPlayerTakeTowerDamage'), self)
	ListenToGameEvent('tree_cut', Dynamic_Wrap(Abyss_Gates, 'OnTreeCut'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(Abyss_Gates, 'OnEntityHurt'), self)
	ListenToGameEvent('player_connect', Dynamic_Wrap(Abyss_Gates, 'PlayerConnect'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(Abyss_Gates, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(Abyss_Gates, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(Abyss_Gates, 'OnNPCSpawned'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(Abyss_Gates, 'OnPlayerPickHero'), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(Abyss_Gates, 'OnTeamKillCredit'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(Abyss_Gates, 'OnPlayerReconnect'), self)
	--ListenToGameEvent('player_spawn', Dynamic_Wrap(Abyss_Gates, 'OnPlayerSpawn'), self)
	--ListenToGameEvent('dota_unit_event', Dynamic_Wrap(Abyss_Gates, 'OnDotaUnitEvent'), self)
	--ListenToGameEvent('nommed_tree', Dynamic_Wrap(Abyss_Gates, 'OnPlayerAteTree'), self)
	--ListenToGameEvent('player_completed_game', Dynamic_Wrap(Abyss_Gates, 'OnPlayerCompletedGame'), self)
	--ListenToGameEvent('dota_match_done', Dynamic_Wrap(Abyss_Gates, 'OnDotaMatchDone'), self)
	--ListenToGameEvent('dota_combatlog', Dynamic_Wrap(Abyss_Gates, 'OnCombatLogEvent'), self)
	--ListenToGameEvent('dota_player_killed', Dynamic_Wrap(Abyss_Gates, 'OnPlayerKilled'), self)
	--ListenToGameEvent('player_team', Dynamic_Wrap(Abyss_Gates, 'OnPlayerTeam'), self)

	-- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
	Convars:RegisterCommand( "command_example", Dynamic_Wrap(Abyss_Gates, 'ExampleConsoleCommand'), "A console command example", 0 )

	Convars:RegisterCommand('player_say', function(...)
		local arg = {...}
		table.remove(arg,1)
		local sayType = arg[1]
		table.remove(arg,1)

		local cmdPlayer = Convars:GetCommandClient()
		keys = {}
		keys.ply = cmdPlayer
		keys.teamOnly = false
		keys.text = table.concat(arg, " ")

		if (sayType == 4) then
			-- Student messages
		elseif (sayType == 3) then
			-- Coach messages
		elseif (sayType == 2) then
			-- Team only
			keys.teamOnly = true
			-- Call your player_say function here like
			self:PlayerSay(keys)
		else
			-- All chat
			-- Call your player_say function here like
			self:PlayerSay(keys)
		end
	end, 'player say', 0)

	-- Fill server with fake clients
	-- Fake clients don't use the default bot AI for buying items or moving down lanes and are sometimes necessary for debugging
	Convars:RegisterCommand('fake', function()
		-- Check if the server ran it
		if not Convars:GetCommandClient() then
			-- Create fake Players
			SendToServerConsole('dota_create_fake_clients')

			Timers:CreateTimer('assign_fakes', {
				useGameTime = false,
				endTime = Time(),
				callback = function(abyss_gates, args)
					local userID = 20
					for i=0, 9 do
						userID = userID + 1
						-- Check if this player is a fake one
						if PlayerResource:IsFakeClient(i) then
							-- Grab player instance
							local ply = PlayerResource:GetPlayer(i)
							-- Make sure we actually found a player instance
							if ply then
								CreateHeroForPlayer('npc_dota_hero_axe', ply)
								self:OnConnectFull({
									userid = userID,
									index = ply:entindex()-1
								})

								ply:GetAssignedHero():SetControllableByPlayer(0, true)
							end
						end
					end
				end})
		end
	end, 'Connects and assigns fake Players.', 0)

	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(timeTxt))

	-- Initialized tables for tracking state
	self.vUserIds = {}
	self.vSteamIds = {}
	self.vBots = {}
	self.vBroadcasters = {}

	self.vPlayers = {}
	self.vRadiant = {}
	self.vDire = {}

	self.nRadiantKills = 0
	self.nDireKills = 0

	self.bSeenWaitForPlayers = false

	if RECOMMENDED_BUILDS_DISABLED then
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_SHOP_SUGGESTEDITEMS, false )
	end

	--print('[ABYSS_GATES] Done loading Abyss_Gates gamemode!\n\n')
end

mode = nil

-- This function is called as the first player loads and sets up the Abyss_Gates parameters
function Abyss_Gates:CaptureAbyss_Gates()
	if mode == nil then
		-- Set Abyss_Gates parameters
		mode = GameRules:GetGameModeEntity()
		mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
		mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
		mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		--mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

		self:OnFirstPlayerLoaded()
	end
end

-- This function is called 1 to 2 times as the player connects initially but before they
-- have completely connected
function Abyss_Gates:PlayerConnect(keys)
	--print('[ABYSS_GATES] PlayerConnect')
	--PrintTable(keys)

	if keys.bot == 1 then
		-- This user is a Bot, so add it to the bots table
		self.vBots[keys.userid] = 1
	end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function Abyss_Gates:OnConnectFull(keys)
	--print ('[ABYSS_GATES] OnConnectFull')
	--PrintTable(keys)
	Abyss_Gates:CaptureAbyss_Gates()

	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)

	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()

	-- Update the user ID table with this user
	self.vUserIds[keys.userid] = ply

	-- Update the Steam ID table
	self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply

	-- If the player is a broadcaster flag it in the Broadcasters table
	if PlayerResource:IsBroadcaster(playerID) then
		self.vBroadcasters[keys.userid] = 1
		return
	end
end

function DealDamage(source, target, damage, dType, flags)
	local dTable = {
		victim = target,
		attacker = source,
		damage = damage,
		damage_type = dType,
		damage_flags = flags,
		ability = nil
	}
	ApplyDamage(dTable)
end
-- a function to quickly create an appropriate dummy
function FastDummy(target, team)
	local dummy = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, team)
	dummy:SetAbsOrigin(target) -- CreateUnitByName uses only the x and y coordinates so we have to move it with SetAbsOrigin()
	dummy:GetAbilityByIndex(0):SetLevel(1)
	dummy:SetDayTimeVisionRange(250)
	dummy:SetNightTimeVisionRange(250)
	dummy:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	dummy:AddNewModifier(dummy, nil, "modifier_invulnerable", { duration = 9999})
	return dummy
end

-- This is an example console command
function Abyss_Gates:ExampleConsoleCommand()
	--print( '******* Example Console Command ***************' )
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			-- Do something here for the player who called this command
			PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
		end
	end
	--print( '*********************************************' )
end
