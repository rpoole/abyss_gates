function replenish_health(keys)
	keys.caster:GetPlayerOwner():GetAssignedHero():replenish_health(keys.heal_amount, keys.caster)
end

function replenish_mana( keys )
	keys.caster:GetPlayerOwner():GetAssignedHero():replenish_mana(keys.mana_amount, keys.caster)
end

function modifier_item_mght_of_the_troll_warlord_bash_chance_on_attack_landed(keys)
	if not keys.caster:HasModifier("bash_cooldown_modifier") then
		local random_int = RandomInt(1, 100)
		local is_ranged_attacker = keys.caster:IsRangedAttacker()
		
		if (is_ranged_attacker and random_int <= keys.BashChanceRanged) or (not is_ranged_attacker and random_int <= keys.BashChanceMelee) then
			keys.target:EmitSound("DOTA_Item.SkullBasher")
			keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_might_of_the_troll_warlord_bash", nil)
			keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()))  --This is just for visual purposes.
		end
	end
end

