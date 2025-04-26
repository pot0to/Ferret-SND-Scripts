local WKSMissionInfomation = Addon:extend()
function WKSMissionInfomation:new()
    WKSMissionInfomation.super.new(self, 'WKSMissionInfomation')
end

function WKSMissionInfomation:report()
    self:wait_until_ready()
    Character:wait_until_done_crafting()
    yield('/callback WKSMissionInfomation true 11')
    repeat
        Ferret:wait(0.1)
    until not WKSMissionInfomation:is_visible()
end

function WKSMissionInfomation:abandon()
    repeat
        if IsAddonReady('WKSMissionInfomation') then
            yield('/callback WKSMissionInfomation true 12')
        end
        Ferret:wait(0.1)
    until IsAddonVisible('SelectYesno')
    repeat
        if IsAddonReady('SelectYesno') then
            yield('/callback SelectYesno true 0')
        end
        Ferret:wait(0.1)
    until not WKSMissionInfomation:is_visible()
end

return WKSMissionInfomation()
