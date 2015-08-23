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
		ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end
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


function RubyHeart ( event )
	local caster = event.caster
	local modifier = event.modifier
	local ability = event.ability

	if caster:GetUnitName() == "the_creature" then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	end
end


function attributeCheck ( event )
	local caster = event.caster
	print(caster)
	local ability = event.ability
	print(ability)
	local heroStrength = caster:GetStrength()
	local heroAgility = caster:GetAgility()
	local heroIntellect = caster:GetIntellect()
	local strengthRequirement = event.strengthRequired
	local agilityRequirement = event.agilityRequired
	local intellectRequirement = event.intellectRequired

	if ability then
		if heroStrength < strengthRequirement then
			caster:SellItem(ability)
		end
		if heroAgility < agilityRequirement then
			caster:SellItem(ability)
		end
		if heroIntellect < intellectRequirement then
			caster:SellItem(ability)
		end
	end
end


function RingOfTheBlessed ( event )
	local caster = event.caster

	caster:GiveMana(10)
end


function EramentStaff ( keys )
	local caster = keys.caster
	local target = keys.target

	target:Heal(300, caster)
	target:GiveMana(220)
end

function PotionOfMana ( keys )
	local caster = keys.caster

	caster:GiveMana(300)
end

function StoneOfMana ( keys )
	local caster = keys.caster

	caster:GiveMana(800)
end


function AscensionSword ( keys )
	local caster = keys.caster
	local target = keys.target

	print(caster:GetUnitName())
	print(target:GetUnitName())

	ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	target:EmitSound("Ability.FrostNova")
end

function ObsidianHeartEquip ( event )
	local caster = event.caster

	if caster:GetUnitName() == "the_creature" then
		local ability = caster:AddAbility("the_creature_carrion_swarm")
		ability:SetLevel(1)

	end
end

function ObsidianHeartUnequip ( event )
	local caster = event.caster

	caster:RemoveAbility("the_creature_carrion_swarm")
end