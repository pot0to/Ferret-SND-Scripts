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
end
