function SetOwner ( keys )
	local caster = keys.caster
	local target = keys.target

	local caster_owner = caster:GetPlayerOwner()
	local target_owner = target:GetPlayerOwner()
	local caster_name = caster:GetUnitName() 
	local target_name = target:GetUnitName()

	print (caster_owner)
	print (target_owner)
	print (caster_name)
	print (target_name)

	if caster_owner == target_owner then
		print ('Success')
	end
end