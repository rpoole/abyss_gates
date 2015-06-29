function TestTarget ( keys )
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target

	local caster_name = caster:GetUnitName()
	local target_name = caster:GetUnitName()

	print (caster_name)
	print (target_name)
end 