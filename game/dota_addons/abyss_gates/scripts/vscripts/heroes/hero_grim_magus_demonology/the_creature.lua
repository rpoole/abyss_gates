function GainLevel ( event )
	local caster = event.caster
	local ability = event.ability
	local corpses = Entities:FindByModelWithin(nil, "models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_troll_skeleton_fx.vmdl", caster:GetAbsOrigin(), 1000)
	local maxHP = caster:GetMaxHealth()

	if corpses then
		caster:Heal(maxHP * 0.4, caster)
		caster:CreatureLevelUp(1)
	end
end


function SetLevel ( event )
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local corpses = Entities:FindByModelWithin(nil, "models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_troll_skeleton_fx.vmdl", caster:GetAbsOrigin(), radius)
	local max_level = ability:GetLevelSpecialValueFor("max_level", ability:GetLevel() - 1)
	local currentLevel = 1

	if corpses then
		for _, unit in pairs(corpses) do
			if currentLevel < max_level then
				local theCreature = Entities:FindByModelWithin(nil, "models/heroes/pudge/pudge.vmdl", caster:GetAbsOrigin(), 2000)
				theCreature:CreatureLevelUp(1)
				currentLevel = currentLevel + 1
			end
		end
	end
end
	