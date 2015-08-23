function CleanserMortar ( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local casterPosition = caster:GetAbsOrigin()  
	local targetPosition = target:GetAbsOrigin()
	local distance = casterPosition - targetPosition
	local length = distance:Length()
	print(length)


	local info =
	{
		Ability = ability,
        EffectName = "particles/skull_spear.vpcf",
        vSpawnOrigin = casterPosition,
        fDistance = length,
        fStartRadius = 0,
        fEndRadius = 0,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = caster:GetForwardVector() * 900,
		bProvidesVision = true,
		iVisionRadius = 1000,
		iVisionTeamNumber = caster:GetTeamNumber()
	} 

	ProjectileManager:CreateLinearProjectile(info)
end