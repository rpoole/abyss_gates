function LifeTapHeal ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local unit = keys.unit
	local maxHealth = unit:GetMaxHealth()
	local healPercent = ability:GetLevelSpecialValueFor("max_hp_leech", ability:GetLevel() - 1)
	local healAmount = maxHealth / healPercent

	caster:Heal(healAmount, caster)



	print(caster:GetUnitName())
	print(unit:GetUnitName())
	print(healAmount)
end