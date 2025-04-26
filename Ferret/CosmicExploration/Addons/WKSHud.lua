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

function WKSHud:open_cosmic_research()
    if WKSToolCustomize:is_visible() then
        return
    end

    yield('/callback WKSHud true 15')
end

function WKSHud:close_cosmic_research()
    if not WKSToolCustomize:is_visible() then
        return
    end

    yield('/callback WKSHud true 15')
end

return WKSHud()
