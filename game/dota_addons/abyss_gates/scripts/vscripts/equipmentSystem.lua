function Mainhand ( event )
	local caster = event.caster
	local modifier = event.modifier
	local ability = event.ability

	print(caster)
	print(modifier)
	print(ability)

	local current_stack = caster:GetModifierStackCount( modifier, ability )

	print(current_stack)

	if current_stack then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	end

	if current_stack < 2 then
		caster:SetModifierStackCount( modifier, ability, current_stack + 1)
	end

end