function StrStack ( event )
	local caster = event.caster
	local ability = event.ability
	local modifier_one = event.modifier_one
	local modifier_two = event.modifier_two

	local current_stack = caster:GetModifierStackCount( modifier_one, ability )

	if current_stack then
		if current_stack < 20 then
			caster:SetModifierStackCount( modifier_one, ability, current_stack + 1)
		elseif current_stack == 20 then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_two, {})
			caster:SetModifierStackCount( modifier_one, ability, 0)
		else
			print("wtf m8")
		end
	end
end

