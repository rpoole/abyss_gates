function SpawnSpiderlings ( event )
	local caster = event.caster
	local targetUnits = Entities:FindAllByNameWithin("npc_dota_creature", targetArea, radius)