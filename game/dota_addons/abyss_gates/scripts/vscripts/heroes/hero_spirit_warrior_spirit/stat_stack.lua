function StrStack ( event )
	local caster = event.caster
	local ability = event.ability
	local stackAmount = ability:GetLevelSpecialValueFor("per_stack", ability:GetLevel() - 1)
	local modifier_one = event.modifier_one
	local modifier_two = event.modifier_two

	local current_stack = caster:GetModifierStackCount( modifier_one, ability )

	if current_stack then
		if current_stack < 100 then
			caster:SetModifierStackCount( modifier_one, ability, current_stack + stackAmount)
		elseif current_stack >= 100 then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_two, {})
			caster:SetModifierStackCount( modifier_one, ability, 0)
		else
			print("wtf m8")
		end
	end
end

