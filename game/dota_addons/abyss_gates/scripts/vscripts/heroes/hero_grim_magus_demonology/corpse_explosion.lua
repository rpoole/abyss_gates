function CorpseSelect ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local targetArea = ability:GetCursorPosition()
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)

	local closest_corpse = Entities:FindAllByNameWithin("npc_dota_creature", targetArea, radius)
	local area_entity = CreateUnitByName("npc_dota_furion_treant", targetArea, true, caster, caster, caster:GetTeamNumber())
	local closestUnit = nil
    local closestUnitDistance = 1000000.0

	for _, unit in pairs(closest_corpse) do

		if string.find(unit:GetUnitName(), "skeleton") then
			distance = CalcDistanceBetweenEntityOBB(area_entity, unit)
			if distance < closestUnitDistance then
				closestUnit = unit
				closestUnitDistance = distance
			end
		end
	end

	print(closestUnit:GetUnitName())
	print(closestUnitDistance)
end

