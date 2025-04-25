WKSMissionInfomation = {}

function WKSMissionInfomation:new(ferret)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function WKSMissionInfomation:is_ready()
    return IsAddonReady("WKSMissionInfomation")
end

function WKSMissionInfomation:wait_until_ready()
    self.ferret:wait_for_ready_addon("WKSMissionInfomation")
end

function WKSMissionInfomation:report()
    self:wait_until_ready()
    yield("/callback WKSMissionInfomation true 11")
end

function WKSMissionInfomation:abandon()
    repeat
        if IsAddonReady("WKSMissionInfomation") then
            yield("/callback WKSMissionInfomation true 12")
        end
        self.ferret:wait(0.1)
    until IsAddonVisible("SelectYesno")
    repeat
        if IsAddonReady("SelectYesno") then
            yield("/callback SelectYesno true 0")
        end
        self.ferret:wait(0.1)
    until not IsAddonVisible("WKSMissionInfomation")
end
