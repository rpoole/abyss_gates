function OnStartTouch(trigger)
    local point = Entities:FindByName( nil, "point_teleport_shopleft"):GetAbsOrigin()
    FindClearSpaceForUnit(trigger.activator, point, false)
    trigger.activator:Stop()
    SendToConsole("dota_camera_center")
end
