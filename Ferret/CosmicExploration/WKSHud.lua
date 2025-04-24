WKSHud = {}

function WKSHud:new(ferret)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function WKSHud:is_visible() return IsAddonVisible("WKSHud") end

function WKSHud:wait_until_visible() self.ferret:wait_for_addon("WKSHud") end

function WKSHud:open_mission_menu()
    if self.ferret.cosmic_exploration.mission_hud:is_visible() then return end

    yield("/callback WKSHud true 11")
end
