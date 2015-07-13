function PoisonSting ( event )
	local caster = event.caster
	local target = event.target
	local currentHealth = target:GetHealth()
	local damage = 10

	if currentHealth < 2 then
		DealDamage(caster, target, damage - 10, DAMAGE_TYPE_MAGICAL, nil)
	elseif currentHealth <=10 then
		DealDamage(caster, target, damage - 9, DAMAGE_TYPE_MAGICAL, nil)
	else
		DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, nil)
	end
end
