function Spawn()
	thisEntity:SetContextThink ("unitPathing", unitPathing, 1)
end

function unitPathing()
	local waypoint1 = Entities:FindByName( nil, 'test_trigger'):GetAbsOrigin()
	
	Timers:CreateTimer(1, function()
		if thisEntity:IsAttacking() == false then
			thisEntity:MoveToPositionAggressive(waypoint1)
		else
			thisEntity:MoveToPositionAggressive(waypoint1)

			if thisEntity:GetUnitName() == "creature_tgarri" then
				local tgarriIllusion = thisEntity:FindAbilityByName("tgarri_illusion")
				if tgarriIllusion:IsFullyCastable() == true then
					if thisEntity:GetHealth() < 9000 then
						if thisEntity:IsIllusion() == false then
							thisEntity:CastAbilityNoTarget(tgarriIllusion, -1)
						end
					end
				end
			end

			if thisEntity:GetUnitName() == "creature_arachnesser" then
				local spawnSpiderlings = thisEntity:FindAbilityByName("spawn_spiderlings")
				if spawnSpiderlings:IsFullyCastable() == true then
					thisEntity:CastAbilityNoTarget(spawnSpiderlings, -1)
				end
			end

			if thisEntity:GetUnitName() == "creature_centaur_hunter" then
				local centaurZeal = thisEntity:FindAbilityByName("centaur_zeal")
				if centaurZeal:IsFullyCastable() == true then
					thisEntity:CastAbilityNoTarget(centaurZeal, -1)
				end
			end

			if thisEntity:GetUnitName() == "creature_centaur_shaman" then
				local centaurResurrect = thisEntity:FindAbilityByName("centaur_resurrect")
				if centaurResurrect:IsFullyCastable() == true then
					thisEntity:CastAbilityNoTarget(centaurResurrect, -1)
				end
			end

			if thisEntity:GetUnitName() == "creature_fire_priest" then
				local spawnEnfrit = thisEntity:FindAbilityByName("spawn_enfrit")
				if spawnEnfrit:IsFullyCastable() == true then
					thisEntity:CastAbilityNoTarget(spawnEnfrit, -1)
				end
			end

			if thisEntity:GetUnitName() == "creature_greater_fire_priest" then
				local spawnEnfrit = thisEntity:FindAbilityByName("spawn_enfrit")
				if spawnEnfrit:IsFullyCastable() == true then
					thisEntity:CastAbilityNoTarget(spawnEnfrit, -1)
				end
			end

			if thisEntity:GetUnitName() == "creature_pyramourn" then
				local spawnEnfritArea = thisEntity:FindAbilityByName("spawn_enfrit_area")
				if spawnEnfritArea:IsFullyCastable() == true then
					thisEntity:CastAbilityNoTarget(spawnEnfritArea, -1)
				end

				if thisEntity:GetHealth() < 20000 then
					local summonGreaterPriest = thisEntity:FindAbilityByName("summon_greater_priest")
					if summonGreaterPriest:IsFullyCastable() == true then
						thisEntity:CastAbilityNoTarget(summonGreaterPriest, -1)
					end
				end
			end

			if thisEntity:GetUnitName() == "creature_troll_shadowpriest" then
				local manaBurn = thisEntity:FindAbilityByName("mana_burn")
				local faerieFire = thisEntity:FindAbilityByName("faerie_fire")
				if faerieFire:IsFullyCastable() == true then
					thisEntity:CastAbilityNoTarget(faerieFire, -1)
				end
				if manaBurn:IsFullyCastable() == true then
					thisEntity:CastAbilityNoTarget(manaBurn, -1)
				end
			end
		end

		
		while thisEntity:IsNull() == false do
			return 1.0
		end

	end)

end