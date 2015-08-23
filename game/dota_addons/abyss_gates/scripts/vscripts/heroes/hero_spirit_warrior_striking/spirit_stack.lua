function SpiritStack ( event )
	local caster = event.caster
	local target = event.target
	local modifier = event.modifier
	local ability = event.ability
	local ability_name = ability:GetAbilityName()

	local max_spirits = 3

	local current_stack = caster:GetModifierStackCount( modifier, ability )

	if current_stack then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	end

	if current_stack < max_spirits then
		
		caster:SetModifierStackCount( modifier, ability, current_stack + 1)

		if current_stack == 0 then
			particleOne = ParticleManager:CreateParticle("particles/parent_charge_one.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		end

		if current_stack == 1 then
			particleTwo = ParticleManager:CreateParticle("particles/parent_charge_two.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		end

		if current_stack == 2 then
			particleThree = ParticleManager:CreateParticle("particles/parent_charge_three.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		end
	end
end

function LightningCheck ( keys )
	local caster = keys.caster
	local target = keys.target
	local modifier = keys.modifier
	local ability = keys.ability
	local manaCost = ability:GetManaCost(ability:GetLevel() - 1)

	local current_stack = caster:GetModifierStackCount("modifier_spirit_charge", ability)

	if current_stack then
		if current_stack == 1 then
			caster:SetModifierStackCount(modifier, ability, 1)
			current_stack = 0
			caster:SetModifierStackCount("modifier_spirit_charge", ability, 0)
		elseif current_stack == 2 then
			caster:SetModifierStackCount(modifier, ability, 2)
			current_stack = 0
			caster:SetModifierStackCount("modifier_spirit_charge", ability, 0)
		elseif current_stack == 3 then
			caster:SetModifierStackCount(modifier, ability, 4)
			current_stack = 0
			caster:SetModifierStackCount("modifier_spirit_charge", ability, 0)
		else
			print("what the fuck")
			caster:GiveMana(manaCost)
		end
	end
end

function SpiritCheck ( event )
	local caster = event.caster
	local target = event.target
	local modifier_one = event.modifier_one
	local modifier_two = event.modifier_two
	local modifier_three = event.modifier_three
	local ability = event.ability
	local manaCost = ability:GetManaCost(ability:GetLevel() - 1)

	local current_stack = caster:GetModifierStackCount("modifier_spirit_charge", ability)

	print(ability_spirit_charge)

	if current_stack then
		if current_stack == 1 then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_one, {})
			current_stack = 0
			caster:SetModifierStackCount("modifier_spirit_charge", ability, 0)
			ParticleManager:DestroyParticle(particleOne, true)
		elseif current_stack == 2 then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_two, {})
			current_stack = 0
			caster:SetModifierStackCount("modifier_spirit_charge", ability, 0)
			ParticleManager:DestroyParticle(particleOne, true)
			ParticleManager:DestroyParticle(particleTwo, true)
		elseif current_stack == 3 then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_three, {})
			current_stack = 0
			caster:SetModifierStackCount("modifier_spirit_charge", ability, 0)
			ParticleManager:DestroyParticle(particleOne, true)
			ParticleManager:DestroyParticle(particleTwo, true)
			ParticleManager:DestroyParticle(particleThree, true)
		else
			print("what the fuck")
			caster:GiveMana(manaCost)
		end
	end
end


function LifeLeech ( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local caster_max_hp = caster:GetMaxHealth()
	local percentage = ability:GetLevelSpecialValueFor("damage_two_charge", ability:GetLevel() - 1)
	local damage_amount = caster_max_hp * (percentage / 100)

 	local damageTable = {
 		victim = target,
 		attacker = caster,
 		damage = damage_amount,
 		damage_type = DAMAGE_TYPE_MAGICAL}
 

	ApplyDamage(damageTable)
	caster:Heal(damage_amount, caster)
end