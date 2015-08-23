function ManaBurn ( event )
	local caster = event.caster
	local targetUnits = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, unit in pairs(targetUnits) do
		unit:ReduceMana(120)
		DealDamage(unit, unit, 120, DAMAGE_TYPE_MAGICAL, nil)
		break
	end
end

function FaerieFire ( event )
	local caster = event.caster
	local ability = event.ability
	local targetUnits = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, unit in pairs(targetUnits) do
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_faerie_fire", {})
		break
	end
end