if Triggers == nil then
  Triggers = class({})
  Triggers.__index = Triggers
end

function Triggers:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

Triggers._goodLives = 30
Triggers._badLives = 30


print("hello world")


function OnStartTouch(trigger)
	if trigger.activator:IsCreature() then
		print("Is Creature")
		if trigger.activator:GetTeam() == DOTA_TEAM_BADGUYS then
			Triggers._goodLives = Triggers._goodLives - 1
			trigger.activator:ForceKill(true)
			GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, Triggers._goodLives)
			if Triggers._goodLives == 0 then
				GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
				return
			end
		end
	end
end

function DireLoseLife(trigger)
	if trigger.activator:IsCreature() then 
		if trigger.activator:GetTeam() == DOTA_TEAM_GOODGUYS then
			Triggers._badLives = Triggers._badLives - 1
			trigger.activator:ForceKill(true)
			GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, Triggers._badLives)
			if Triggers._badLives == 0 then
				GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
				return
			end
		end
	end
end