function CurrentHealth ( event )
	local caster = event.caster
	local target = event.target

	currentHealth = target:GetHealth()
	damageResult = currentHealth * 0.25

	DealDamage(caster, target, damageResult, DAMAGE_TYPE_PURE, 0)

end