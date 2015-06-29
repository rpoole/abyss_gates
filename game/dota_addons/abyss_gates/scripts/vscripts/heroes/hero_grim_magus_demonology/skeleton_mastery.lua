function SkeletonSelect ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local modifier = event.modifier
	local duration = ability:GetLevelSpecialValueFor("think_interval", ability_level) 
	local caster_owner = caster:GetPlayerOwner()
	local target_owner = target:GetPlayerOwner()
	local target_name = target:GetUnitName()
	local caster_name = caster:GetUnitName() 

	local unit_skeleton_warrior = keys.unit_skeleton_warrior

	print (caster_name)
	print (target_name)

	local all_units = ability:GetLevelSpecialValueFor("all_units", (ability:GetLevel() - 1))

	if all_units == 1 then all_units = true else all_units = false end

	if all_units then
		if target_owner == caster_owner then
			ability:ApplyDataDrivenModifier(caster, target, modifier, {Duration = duration})
		end
	end
end