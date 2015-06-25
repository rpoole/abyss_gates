function SetWardDamage( event )
	local target = event.target
	local ability = event.ability
	local attack_damage_min = ability:GetLevelSpecialValueFor("damage_min", ability:GetLevel() - 1 )
	local attack_damage_max = ability:GetLevelSpecialValueFor("damage_max", ability:GetLevel() - 1 )

	target:SetBaseDamageMax(attack_damage_max)
	target:SetBaseDamageMin(attack_damage_min)

end

function WallSpellStart(keys)
	keys.caster:EmitSound("Hero_Invoker.IceWall.Cast")

	local caster_point = keys.caster:GetAbsOrigin()
	local direction_to_target_point = keys.caster:GetForwardVector()
	target_point = caster_point + (direction_to_target_point * keys.WallPlaceDistance)
	local direction_to_target_point_normal = Vector(-direction_to_target_point.y, direction_to_target_point.x, direction_to_target_point.z)
	local vector_distance_from_center = (direction_to_target_point_normal * (keys.NumWallElements * keys.WallElementSpacing)) / 2
	local one_end_point = target_point - vector_distance_from_center
	
	--Create dummy units in a line that slow nearby enemies with their aura.
	for i=0, keys.NumWallElements, 1 do
		local serpent_wall_unit = CreateUnitByName("npc_dota_shadow_shaman_ward_1", one_end_point + direction_to_target_point_normal * (keys.WallElementSpacing * i), false, nil, nil, keys.caster:GetTeam())
	end
end