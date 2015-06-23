function test_ability1(keys)
-- vars
	local caster = keys.caster
	local target = keys.target_points[1]
	local damage = keys.damage
	local radius = keys.radius
	local test_ability1Level = caster:GetAbilityByIndex(0):GetLevel() --[[Returns:handle
	Retrieve an ability by index from the unit.
	]]