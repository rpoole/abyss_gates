function SpiritStack ( event )
	local caster = event.caster
	local target = event.target
	local modifier = event.modifier
	local ability = event.ability
	local ability_name = ability:GetAbilityName()

	print(ability_name)

	local max_spirits = 3

	local current_stack = caster:GetModifierStackCount( modifier, ability )

	if current_stack then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	end

	if current_stack < max_spirits then
		caster:SetModifierStackCount( modifier, ability, current_stack + 1)
	end
end

function SpiritCheck ( event )
	local caster = event.caster
	local target = event.target
	local modifier_one = event.modifier_one
	local modifier_two = event.modifier_two
	local modifier_three = event.modifier_three
	local ability = event.ability

	local current_stack = caster:GetModifierStackCount("modifier_spirit_charge", ability)

	print(ability_spirit_charge)

	if current_stack then
		if current_stack == 1 then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_one, {})
			current_stack = 0
		elseif current_stack == 2 then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_two, {})
			current_stack = 0
		elseif current_stack == 3 then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_three, {})
			current_stack = 0
		else
			print("what the fuck")
		end
	end
end


function LifeLeech ( event )
	local caster = event.caster
	local target = event.target

	local caster_max_hp = caster:GetMaxHealth()
	local damage_amount = caster_max_hp * 0.30

 	local damageTable = {
 		victim = target,
 		attacker = caster,
 		damage = damage_amount,
 		damage_type = DAMAGE_TYPE_MAGICAL}
 

	ApplyDamage(damageTable)
	caster:Heal(damage_amount, caster)
end