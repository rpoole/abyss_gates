function CorpseSelect ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local targetArea = ability:GetCursorPosition()
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local multiplier = ability:GetLevelSpecialValueFor("damage_multiplier", ability:GetLevel() - 1)
	local targetUnits = Entities:FindAllByModel("models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_troll_skeleton_fx.vmdl")
	local closestUnit = nil
    local closestUnitDistance = 1000000.0

    for _, unit in pairs(targetUnits) do
    	unitLocation = unit:GetAbsOrigin()
    	distance = unitLocation - targetArea
    	distanceA = math.pow(distance.x, 2)
    	distanceB = math.pow(distance.y, 2)
    	totalDistance = distanceA + distanceB
    	realDistance = math.sqrt(totalDistance)
    	if realDistance < 600 then
    		if realDistance < closestUnitDistance then
    			closestUnit = unit
    			closestUnitDistance = realDistance
    		end    			
    	end
  	end

  	if closestUnit:GetUnitName() == "dummy_unit" then
  		baseDamage = closestUnit:GetMaxHealth()
  		realDamage = baseDamage * multiplier
  		damageTargets = FindUnitsInRadius(	DOTA_TEAM_NEUTRALS, 
  											targetArea, 
  											nil, 
  											600, 
  											DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
  											DOTA_UNIT_TARGET_BASIC, 
  											DOTA_UNIT_TARGET_FLAG_NONE, 
  											FIND_ANY_ORDER, 
  											false )

		for _, unit in pairs(damageTargets) do
	  		print(unit:GetUnitName())
	  		DealDamage(caster, unit, realDamage, DAMAGE_TYPE_MAGICAL, nil)
	  	end
	end
end

