function ManaDrain ( event )
	local caster = event.caster
	local modifier = event.modifier
	local ability = event.ability
	local mana_per_second = ability:GetLevelSpecialValueFor("mana_per_second", ability:GetLevel() -1)

	currentMana = caster:GetMana()

	if currentMana > mana_per_second then
		caster:SetMana(currentMana - mana_per_second)
	else
		ability:ToggleAbility()
	end
end

function ToggleOn ( event )
	local caster = event.caster
	local currentMana = caster:GetMana() 
	caster:SetMana(currentMana - 35)
end