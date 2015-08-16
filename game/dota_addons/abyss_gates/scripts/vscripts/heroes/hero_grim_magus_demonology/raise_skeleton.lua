function SetOwner ( keys )
	local caster = keys.caster
	local target = keys.target

	local caster_owner = caster:GetPlayerOwner()
	local target_owner = target:GetPlayerOwner()
	local caster_name = caster:GetUnitName() 
	local target_name = target:GetUnitName()

	if caster_owner == target_owner then
		print ('Success')
	end
end

function SummonSkeleton ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier
	local maxSkeletons = ability:GetLevelSpecialValueFor("max_skeletons", ability:GetLevel() - 1)
	local burningChance = ability:GetLevelSpecialValueFor("burning_chance", ability:GetLevel() - 1)
	local manaCost = ability:GetManaCost(ability:GetLevel() - 1)
	local archerChance = 10

	local isBurning = RandomInt(0, 101)
	local isArcher = RandomInt(0, 11)


	local current_stack = caster:GetModifierStackCount("modifier_skeleton_count", ability)

    if current_stack < maxSkeletons then
    	caster:SetModifierStackCount ( modifier, ability, current_stack + 1)
		if isArcher <= 1 then
			if isBurning < 11 then
				local unit_burning_archer = CreateUnitByName("undead_burning_skeleton_archer", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
				unit_burning_archer:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
			else
				local unit_archer = CreateUnitByName("undead_skeleton_archer", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
				unit_archer:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
			end
		elseif isArcher >= 2 then
			if isBurning < 11 then
				local unit_burning_warrior = CreateUnitByName("undead_burning_skeleton_warrior", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
				unit_burning_warrior:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
			else
				local unit_warrior = CreateUnitByName("undead_skeleton_warrior", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
				unit_warrior:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
			end
		end
	else
		caster:GiveMana(manaCost)
	end
end


function SummonMage ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier
	local maxSkeletons = ability:GetLevelSpecialValueFor("max_skeletons", ability:GetLevel() - 1)
	local manaCost = ability:GetManaCost(ability:GetLevel() - 1)
	local mageType = RandomInt(1, 3)
	local current_stack = caster:GetModifierStackCount("modifier_skeleton_mage_count", ability)

		
	if current_stack < maxSkeletons then
		caster:SetModifierStackCount ( modifier, ability, current_stack + 1)
		if mageType == 1 then
			local unit_fire = CreateUnitByName("undead_skeleton_fire_mage", caster:GetAbsOrigin(), true, caster, caster:GetOwner(), caster:GetTeamNumber())
			unit_fire:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
		end

		if mageType == 2 then
			local unit_lightning = CreateUnitByName("undead_skeleton_lightning_mage", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
			unit_lightning:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
		end

		if mageType == 3 then
			local unit_frost = CreateUnitByName("undead_skeleton_frost_mage", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
			unit_frost:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
		end
	else
		caster:GiveMana(manaCost)
	end
end