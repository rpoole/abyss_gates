requires = {
	'util',
	'timers',
	'physics',
	'lib.statcollection',
	'abilities',
	'abyss_gates',
	'base_trigger',
}

function Precache( context )
	-- NOTE: IT IS RECOMMENDED TO USE A MINIMAL AMOUNT OF LUA PRECACHING, AND A MAXIMAL AMOUNT OF DATADRIVEN PRECACHING.
	-- Precaching guide: https://moddota.com/forums/discussion/119/precache-fixing-and-avoiding-issues

	print("[ABYSS_GATES] Performing pre-load precache")

	PrecacheUnitByNameSync("creature_tgarri", context)
	PrecacheUnitByNameSync("creature_tgarri_first_split", context)
	PrecacheUnitByNameSync("creature_tgarri_second_split", context)
	PrecacheUnitByNameSync("creature_tgarri_third_split", context)
	PrecacheUnitByNameSync("creature_tgarri_fourth_split", context)
	PrecacheUnitByNameSync("creature_spiderling", context)
	PrecacheUnitByNameSync("undead_burning_skeleton_archer", context)
	PrecacheUnitByNameSync("undead_skeleton_archer", context)
	PrecacheUnitByNameSync("undead_skeleton_warrior", context)
	PrecacheUnitByNameSync("undead_burning_skeleton_warrior", context)
	PrecacheUnitByNameSync("undead_skeleton_fire_mage", context)
	PrecacheUnitByNameSync("creature_boar", context)
	PrecacheUnitByNameSync("creature_grasper", context)
	PrecacheUnitByNameSync("creature_grasper_venomancer", context)
	PrecacheUnitByNameSync("creature_great_turtle", context)
	PrecacheUnitByNameSync("creature_mervian_clasper", context)
	PrecacheUnitByNameSync("creature_mervian_mauler", context)
	PrecacheUnitByNameSync("creature_kerrang", context)
	PrecacheUnitByNameSync("creature_dryad", context)
	PrecacheUnitByNameSync("creature_nightshade_huntress", context)
	PrecacheUnitByNameSync("creature_harlequin_spider", context)
	PrecacheUnitByNameSync("creature_arachnesser", context)
	PrecacheModel("models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_troll_skeleton_fx.vmdl", context) --[[Returns:void
	( modelName, context ) - Manually precache a single model
	]]
	-- Particles can be precached individually or by folder
	-- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
	--PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
	--PrecacheResource("particle_folder", "particles/test_particle", context)

	-- Models can also be precached by folder or individually
	--PrecacheModel should generally used over PrecacheResource for individual models
	--PrecacheResource("model_folder", "particles/heroes/antimage", context)
	--PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
	--PrecacheModel("models/heroes/viper/viper.vmdl", context)

	-- Sounds can precached here like anything else
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)

	-- Entire items can be precached by name
	-- Abilities can also be precached in this way despite the name
	PrecacheItemByNameSync("example_ability", context)
	PrecacheItemByNameSync("item_example_item", context)

	-- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
	-- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
	PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.Abyss_Gates = Abyss_Gates()
	GameRules.Abyss_Gates:InitAbyss_Gates()
end

for i,v in ipairs(requires) do
	require(v)	
end
