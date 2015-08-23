function ShatterBones( event )
	local caster = event.caster
	local target = event.target
	local unit_name = target:GetUnitName()
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1 )

	local health_percent = ability:GetLevelSpecialValueFor( "health_percent" , ability:GetLevel() - 1 ) * 0.01
	local target_health = target:GetHealth()
	local healthLoss = math.floor(target_health * health_percent)
	local healthLossUnique = math.floor(target_health * 0.75)

	if unit_name == "creature_kerrang" or unit_name == "creature_tgarri" or unit_name == "creature_oghmar_grayskin" or unit_name == "creature_pyramourn" then
		target:SetHealth(healthLossUnique)
	else
		target:SetHealth(healthLoss)
	end
end