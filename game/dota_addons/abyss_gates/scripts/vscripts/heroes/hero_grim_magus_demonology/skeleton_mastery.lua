function SkeletonSelect ( keys )
	local caster = keys.caster
	

	local skeletonUnits = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              Vector(0, 0, 0),
                              nil,
                              FIND_UNITS_EVERYWHERE,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_BASIC,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)

	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = 999
	local health_gain = ability:GetLevelSpecialValueFor("bonus_health", ability:GetLevel() - 1)

	local caster_name = caster:GetUnitName() 

	local unit_skeleton_warrior = keys.unit_skeleton_warrior

	for _, unit in pairs(skeletonUnits) do
		if string.find(unit:GetUnitName(), "skeleton") then
			current_level = unit:GetLevel()
			if current_level < ability_level + 1 then
				unit:CreatureLevelUp(1)
				if current_level >= 2 then
					unit_ability = unit:GetAbilityByIndex(0)
					unit_ability:SetLevel(2)
				end
			end
		end
	end
end

function SkeletonCount ( event )
	local caster = event.caster
	local owner = caster:GetOwner()
	local ability = event.ability

	local current_stack = owner:GetModifierStackCount("modifier_skeleton_count", ability)
	owner:SetModifierStackCount("modifier_skeleton_count", ability, current_stack - 1)
end

function SkeletonMageCount ( event )
	local caster = event.caster
	local owner = caster:GetOwner()
	local ability = event.ability

	local current_stack = owner:GetModifierStackCount("modifier_skeleton_mage_count", ability)
	owner:SetModifierStackCount("modifier_skeleton_mage_count", ability, current_stack - 1)
end
