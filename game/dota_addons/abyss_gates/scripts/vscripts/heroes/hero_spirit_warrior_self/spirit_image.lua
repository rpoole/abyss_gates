function SpawnImages( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local unit_name = caster:GetUnitName()
	local image_count = ability:GetLevelSpecialValueFor("image_count", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local outgoing_damage = ability:GetLevelSpecialValueFor("outgoing_damage", ability:GetLevel() - 1)
	local incoming_damage = ability:GetLevelSpecialValueFor("incoming_damage", ability:GetLevel() - 1)

	local casterOrigin = caster:GetAbsOrigin() 
	local casterAngles = caster:GetAngles()

	caster:Stop()

	if not caster.spirit_image_illusions then
		caster.spirit_image_illusions = {}
	end

	caster.spirit_image_illusions = {}

	local vRandomSpawnPos = {
		Vector( 72, 0, 0 ),		-- North
		Vector( 0, 72, 0 ),		-- East
		Vector( -72, 0, 0 ),	-- South
		Vector( 0, -72, 0 ),	-- West
	}

	for i=#vRandomSpawnPos, 2, -1 do
		local j = RandomInt( 1, i )
		vRandomSpawnPos[i], vRandomSpawnPos[j] = vRandomSpawnPos[j], vRandomSpawnPos[i]
	end

	table.insert( vRandomSpawnPos, RandomInt( 1,  image_count + 1 ), Vector( 0, 0, 0 ) )

	FindClearSpaceForUnit( caster, casterOrigin + table.remove( vRandomSpawnPos, 1 ), true)

	for i = 1, image_count do

		local origin = casterOrigin + table.remove( vRandomSpawnPos, 1 )

		-- handle_UnitOwner needs to be nil, else it will crash the game.
		local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
		illusion:SetPlayerID(caster:GetPlayerID())
		illusion:SetControllableByPlayer(player, true)

		illusion:SetAngles( casterAngles.x, casterAngles.y, casterAngles.z )
		
		-- Level Up the unit to the casters level
		local casterLevel = caster:GetLevel()
		for i=1,casterLevel-1 do
			illusion:HeroLevelUp(false)
		end

		-- Set the skill points to 0 and learn the skills of the caster

		-- Recreate the items of the caster
	

		illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
		
		illusion:MakeIllusion()

		illusion:SetHealth(caster:GetHealth())

		table.insert(caster.spirit_image_illusions, illusion)

	end
end

function tgarriImages ( event )
	local caster = event.caster
	local ability = event.ability
	local unit_name = caster:GetUnitName()
	local image_count = ability:GetLevelSpecialValueFor("image_count", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local outgoing_damage = ability:GetLevelSpecialValueFor("outgoing_damage", ability:GetLevel() - 1)
	local incoming_damage = ability:GetLevelSpecialValueFor("incoming_damage", ability:GetLevel() - 1)

	local casterOrigin = caster:GetAbsOrigin() 
	local casterAngles = caster:GetAngles()

	caster:RemoveAbility("tgarri_illusion") --[[Returns:void
	Remove an ability from this unit by name.
	]]
	caster:Stop()

	if not caster.spirit_image_illusions then
		caster.spirit_image_illusions = {}
	end

	caster.spirit_image_illusions = {}

	local vRandomSpawnPos = {
		Vector( 72, 0, 0 ),		-- North
		Vector( 0, 72, 0 ),		-- East
		Vector( -72, 0, 0 ),	-- South
		Vector( 0, -72, 0 ),	-- West
	}

	for i=#vRandomSpawnPos, 2, -1 do
		local j = RandomInt( 1, i )
		vRandomSpawnPos[i], vRandomSpawnPos[j] = vRandomSpawnPos[j], vRandomSpawnPos[i]
	end

	table.insert( vRandomSpawnPos, RandomInt( 1,  image_count + 1 ), Vector( 0, 0, 0 ) )

	FindClearSpaceForUnit( caster, casterOrigin + table.remove( vRandomSpawnPos, 1 ), true)

	for i = 1, image_count do

		local origin = casterOrigin + table.remove( vRandomSpawnPos, 1 )

		-- handle_UnitOwner needs to be nil, else it will crash the game.
		local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
		illusion:SetAngles( casterAngles.x, casterAngles.y, casterAngles.z )
		
		-- Level Up the unit to the casters level
		local casterLevel = caster:GetLevel()
		for i=1,casterLevel-1 do
			illusion:HeroLevelUp(false)
		end

		illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
		
		illusion:MakeIllusion()

		illusion:SetHealth(caster:GetHealth())
		illusion:RemoveAbility("tgarri_illusion")
		illusion:RemoveAbility("tgarri_first_split")

		table.insert(caster.spirit_image_illusions, illusion)

	end
end