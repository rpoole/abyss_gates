function ResUnit ( event )
	local caster = event.caster
	local unit = event.unit

	print(unit:GetUnitName())

	CreateUnitByName(unit:GetUnitName(), unit:GetAbsOrigin(), true, nil, caster, caster:GetTeamNumber())

end