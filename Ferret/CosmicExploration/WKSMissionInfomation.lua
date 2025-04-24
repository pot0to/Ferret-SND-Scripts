WKSMissionInfomation = {}

function WKSMissionInfomation:new(ferret)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function WKSMissionInfomation:is_visible()
    return IsAddonVisible("WKSMissionInfomation")
end

function WKSMissionInfomation:wait_until_visible()
    self.ferret:wait_for_addon("WKSMissionInfomation")
end

function WKSMissionInfomation:report()
    self:wait_until_visible()
    yield("/callback WKSMissionInfomation true 11")
end

function WKSMissionInfomation:abandon()
    self:wait_until_visible()
    yield("/callback WKSMissionInfomation true 12")
    repeat
        if IsAddonReady("SelectYesno") then
            yield("/callback SelectYesno true 0")
        end
        self.ferret:wait(0.1)
    until not IsAddonReady("WKSMissionInfomation")
end
