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


function OnStartTouch(key)
	print(key.activator) --The entity that triggered the event to happen
    print(key.caller) -- The entity that called for the event to happen

    killEntity(key.activator)
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

function killEntity(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    print("Unit '" .. unitName .. "' has entered the killbox")

    if (key:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
        print("Is player owned - Ignore")

    elseif unitName == "dummy_unit" then
    	print("Is corpse - Ignore")

    else
        print("Is not owned by player - Terminate")
        key:ForceKill(true) -- Kills the unit
        Triggers._goodLives = Triggers._goodLives - 1
		GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, Triggers._goodLives)
		if Triggers._goodLives == 0 then
			GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
			return
		end
    end

end