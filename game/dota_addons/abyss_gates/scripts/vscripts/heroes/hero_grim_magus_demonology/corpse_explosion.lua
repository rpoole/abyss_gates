function CorpseSelect ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local targetArea = ability:GetCursorPosition()
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local allUnits = Entities:FindByModelWithin(nil, "models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_troll_skeleton_fx.vmdl", targetArea, radius) --[[Returns:handle
	Find entities by model name within a radius. Pass ''nil'' to start an iteration, or reference to a previously found entity to continue a search
	]]

	print(targetArea)
	print(radius)

	--[[local closest_corpse = Entities:FindAllByNameWithin("dummy_unit", targetArea, radius)
	local area_entity = CreateUnitByName("npc_dummy_blank", targetArea, true, caster, caster, caster:GetTeamNumber())
	local closestUnit = nil
    local closestUnitDistance = 1000000.0--]]

    for _, unit in pairs(allUnits) do
    	print(unit:GetUnitName())
    end

	--[[for _, unit in pairs(closest_corpse) do
		print(unit:GetUnitName())
		if string.find(unit:GetUnitName(), "dummy_unit") then
			distance = CalcDistanceBetweenEntityOBB(area_entity, unit)
			if distance < closestUnitDistance then
				closestUnit = unit
				closestUnitDistance = distance
			end
		end
	end

	print(closestUnit:GetUnitName())
	print(closestUnitDistance)--]]
end

