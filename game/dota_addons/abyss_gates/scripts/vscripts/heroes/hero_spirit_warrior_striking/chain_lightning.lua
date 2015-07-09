function LightningJump ( event )
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local bounces = event.bounces
	local units = nil
	local lightningBolt = nil
	local boltDummy = nil
	lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2)))	
	DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
-- this timer is used for the bounces	
	Timers:CreateTimer(DoUniqueString("arcl"), {
		endTime = 0.2,
		callback = function()
-- unit selection and counting
			units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetOrigin(), caster, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, true) -- again, cast range not documented. these tooltips suck
			PrintTable(units)
-- end the spell if there are no valid targets
			if #units < 1 then
				return
			end
-- particle stuff. the bounding box stuff is so that the lightning shoots out of the middle. it still attaches to the feet so it's a bit weird but it's mostly fine. 
-- the particle must be created during the timer but before the target switch	
			targetVec = target:GetAbsOrigin()
			targetVec.z = target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2)
			if boltDummy ~= nil then
				boltDummy:Destroy()
			end
			boltDummy = FastDummy(targetVec, DOTA_TEAM_NOTEAM)
			lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, boltDummy)
-- select a target randomly from the table and deal damage. while loop makes sure the target doesn't select itself.		
			local tTarget = units[math.random(1,#units)]
			while tTarget == target do
				tTarget = units[math.random(1,#units)]
			end
			target = tTarget
			DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
-- play the sound
			target:EmitSound("Hero_Zuus.ArcLightning.Target")
-- make the particle shoot to the target
			ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2)))																				
-- decrement remaining spell bounces, reduce damage, and clear relevant tables
			bounces = bounces - 1
			damage = damage / 1.1
-- fire the timer again if spell bounces remain
			if bounces > 0 then
				return 0.2
			end
		end
	})
end