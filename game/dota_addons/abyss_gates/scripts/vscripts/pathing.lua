function Spawn()
	thisEntity:SetContextThink ("unitPathing", unitPathing, 1)
end

function unitPathing()
	local waypoint1 = Entities:FindByName( nil, 'test_trigger'):GetAbsOrigin()
	
	Timers:CreateTimer(1, function()
		if thisEntity:IsIdle() == true then
			thisEntity:MoveToPosition(waypoint1)
		else
			thisEntity:MoveToPositionAggressive(waypoint1)
		end

		return 1.0

	end)
end