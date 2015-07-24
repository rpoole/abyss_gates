function MortredAmulet ( event )
	local caster = event.caster
	local ability = event.ability
	local modifier = event.modifier
	local corpses = Entities:FindByModelWithin(nil, "models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_troll_skeleton_fx.vmdl", caster:GetAbsOrigin(), 1000)

	if corpses then
		maxHealth = caster:GetMaxHealth()
		maxMana = caster:GetMaxMana()

		caster:Heal(maxHealth * 0.12, caster)
		caster:GiveMana(maxMana * 0.12)

		print("Success!")
	end

	ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay.vpcf", PATTACH_ABSORIGIN_FOLLOW, closestUnit)
end


function DarkElvenCharm ( event )
	local caster = event.caster
	local ability = event.ability
	local modifier = event.modifier
	local summonedUnits = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              Vector(0, 0, 0),
                              nil,
                              FIND_UNITS_EVERYWHERE,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_BASIC,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)

	print(caster:GetPlayerOwner())
	print("==============")

	for _, unit in pairs(summonedUnits) do
		if unit:GetPlayerOwner() == caster:GetPlayerOwner() then
			ability:ApplyDataDrivenModifier(caster, unit, modifier, {})
		end
	end
end