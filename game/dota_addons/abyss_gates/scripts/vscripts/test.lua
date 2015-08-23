require( "pathing" )

function SpawnTest()
	thisEntity:SetContextThink ("unitPathingTest", unitPathingTest, 1)
end

function unitPathingTest()
	local waypoint1 = Entities:FindByName( nil, 'test_trigger'):GetAbsOrigin()
	
	Timers:CreateTimer(1, function()
		if thisEntity:IsIdle() == true then
			print("test")
		else
			print("test")
		end

		while thisEntity:IsNull() == false do
			return 1.0
		end

	end)

end