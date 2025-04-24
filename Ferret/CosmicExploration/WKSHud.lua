WKSHud = {}

function WKSHud:new(ferret)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function WKSHud:is_ready() return IsAddonReady("WKSHud") end

function WKSHud:wait_until_ready() self.ferret:wait_for_ready_addon("WKSHud") end

function WKSHud:open_mission_menu()
    if self.ferret.cosmic_exploration.mission_hud:is_ready() then return end

    yield("/callback WKSHud true 11")
end
