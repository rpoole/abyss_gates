function InstaKill ( keys )
	local caster = keys.caster
	local casterPosition = caster:GetAbsOrigin()
	local ability = keys.ability
	local radius = keys.radius
	local healAmount = ability:GetLevelSpecialValueFor("heal_amount", ability:GetLevel() -1)
	local killThreshold = ability:GetLevelSpecialValueFor("kill_threshold", ability:GetLevel() -1)

	print("Test")
	print(killThreshold)


	local targetUnits = FindUnitsInRadius(DOTA_TEAM_NOTEAM, 
							casterPosition, 
							nil, 
							radius, 
							DOTA_UNIT_TARGET_TEAM_ENEMY, 
							DOTA_UNIT_TARGET_BASIC, 
							DOTA_UNIT_TARGET_FLAG_NONE, 
							FIND_ANY_ORDER, 
							false)

	for _, unit in pairs(targetUnits) do

		
		currentHealth = unit:GetHealth()
		maxHealth = unit:GetMaxHealth()

		percentageHealth = currentHealth / maxHealth

		print(unit:GetUnitName())
		print(percentageHealth)

		if percentageHealth <= killThreshold then
			unit:Kill(ability, caster)
			caster:Heal(healAmount, caster)
		end
	end
end