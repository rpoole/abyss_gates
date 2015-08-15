function rubicanAbility ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target
	local radius = keys.radius
	local speed = keys.speed
	local distance = keys.distance
	local casterOrigin = caster:GetAbsOrigin()
	local travelDuration = distance / speed
	local startTime = GameRules:GetGameTime()
	local endTime = startTime + travelDuration

	local projID = ProjectileManager:CreateLinearProjectile( {
		Ability 			= ability,
		EffectName			= keys.particle,
		vSpawnOrigin		= casterOrigin,
		fDistance			= distance,
		fStartRadius		= radius,
		fEndRadius			= radius,
		Source 				= casterOrigin,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime			= endTime,
		bDeleteOnHit		= false,
		vVelocity			= speed,
		bProvidesVision		= false	,	
	})
end


