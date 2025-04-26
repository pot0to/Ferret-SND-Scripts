local WKSHud = Addon:extend()
function WKSHud:new()
    WKSHud.super.new(self, 'WKSHud')
end

function WKSHud:open_mission_menu()
    if WKSMission:is_visible() or WKSMissionInfomation:is_visible() then
        return
    end

    yield('/callback WKSHud true 11')
end

return WKSHud()
