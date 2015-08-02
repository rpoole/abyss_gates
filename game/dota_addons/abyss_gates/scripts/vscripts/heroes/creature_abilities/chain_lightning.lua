function ChainLightning ( keys )
	local caster = keys.caster
	local target = keys.target
	local damage = caster:GetAttackDamage()

	DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, nil)

end