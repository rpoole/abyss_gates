function ShatterBones( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1 )

	local health_percent = ability:GetLevelSpecialValueFor( "health_percent" , ability:GetLevel() - 1 ) * 0.01
	local target_health = target:GetHealth()
	local healthLoss = math.floor(target_health * health_percent)

	target:SetHealth(healthLoss)
end