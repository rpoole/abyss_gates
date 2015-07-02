function ManaRipRegen ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local unit = keys.unit
	local maxHealth = unit:GetMaxHealth()
	local manaPercent = ability:GetLevelSpecialValueFor("max_hp_leech", ability:GetLevel() - 1)
	local manaAmount = maxHealth / manaPercent

	caster:GiveMana(manaAmount)



	print(caster:GetUnitName())
	print(unit:GetUnitName())
	print(healAmount)
end