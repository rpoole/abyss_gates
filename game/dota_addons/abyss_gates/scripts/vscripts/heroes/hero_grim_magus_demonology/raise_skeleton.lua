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
	local crypticCharm = 50
	local manaCost = ability:GetManaCost(ability:GetLevel() - 1)
	local archerChance = 10
	local isArcher = RandomInt(0, archerChance)
	local burningChance = nil

	if caster:HasModifier("modifier_cryptic_charm") then
		burningChance = ability:GetLevelSpecialValueFor("burning_chance", ability:GetLevel() - 1) + crypticCharm
		print(burningChance)
	else
		burningChance = ability:GetLevelSpecialValueFor("burning_chance", ability:GetLevel() - 1)
	end

	local isBurning = RandomInt(0, 100)
	print('ROLL: ' .. isBurning)		


	local current_stack = caster:GetModifierStackCount("modifier_skeleton_count", ability)

    if current_stack < maxSkeletons then
    	print('CHANCE: ' .. burningChance)
    	caster:SetModifierStackCount ( modifier, ability, current_stack + 1)
		if isArcher <= 1 then
			if isBurning < burningChance then
				local unit_burning_archer = CreateUnitByName("undead_burning_skeleton_archer", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
				unit_burning_archer:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
				ability:ApplyDataDrivenModifier(caster, unit_burning_archer, "modifier_phased", { duration = 0.3 })
			else
				local unit_archer = CreateUnitByName("undead_skeleton_archer", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
				unit_archer:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
				ability:ApplyDataDrivenModifier(caster, unit_archer, "modifier_phased", { duration = 0.3 })
			end
		elseif isArcher >= 2 then
			if isBurning < burningChance then
				local unit_burning_warrior = CreateUnitByName("undead_burning_skeleton_warrior", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
				unit_burning_warrior:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
				ability:ApplyDataDrivenModifier(caster, unit_burning_warrior, "modifier_phased", { duration = 0.3 })
			else
				local unit_warrior = CreateUnitByName("undead_skeleton_warrior", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
				unit_warrior:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
				ability:ApplyDataDrivenModifier(caster, unit_warrior, "modifier_phased", { duration = 0.3 })
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
			ability:ApplyDataDrivenModifier(caster, unit_fire, "modifier_phased", { duration = 0.3 })
		end

		if mageType == 2 then
			local unit_lightning = CreateUnitByName("undead_skeleton_lightning_mage", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
			unit_lightning:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
			ability:ApplyDataDrivenModifier(caster, unit_lightning, "modifier_phased", { duration = 0.3 })
		end

		if mageType == 3 then
			local unit_frost = CreateUnitByName("undead_skeleton_frost_mage", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
			unit_frost:SetControllableByPlayer(caster:GetMainControllingPlayer(), true)
			ability:ApplyDataDrivenModifier(caster, unit_frost, "modifier_phased", { duration = 0.3 })
		end
	else
		caster:GiveMana(manaCost)
	end
end