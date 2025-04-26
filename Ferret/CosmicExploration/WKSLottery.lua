WKSLottery = {}

function WKSLottery:new(ferret)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    self.lunarCreditsId = 45691
    self.fortunesNpc = { name = "Orbitingway", x=18, y=0, z=-19, wait=0.08 }
    return o
end

function WKSLottery:is_ready() return IsAddonReady("WKSLottery") end

function WKSLottery:wait_until_ready() self.ferret:wait_for_ready_addon("WKSLottery") end

function WKSLottery:play()
    if GetItemCount(self.lunarCreditsId) >= 9900 then
        while GetDistanceToPoint(self.fortunesNpc.x, self.fortunesNpc.y, self.fortunesNpc.z) > 7 do
            if not PathfindInProgress() and not PathIsRunning() then
                PathfindAndMoveto(self.fortunesNpc.x, self.fortunesNpc.y, self.fortunesNpc.z)
            end
            yield("/wait 1")
        end

        if PathfindInProgress() or PathIsRunning() then
            yield("/vnav stop")
        end

        while GetItemCount(self.lunarCreditsId) >= 1000 do
        

            yield("/target "..self.fortunesNpc.name)
            yield("/wait 1")
            yield("/interact")
            yield("/wait 1")
    
            self.ferret.cosmic_exploration.wait_until_ready()
            yield("/callback WKSLottery true 0 0")
            yield("/wait 1")
            yield("/callback ScreenLog true 0 0")
            yield("/wait 1")
            yield("/callback WKSLottery true 1 0")
            yield("/wait 1")
            yield("/callback WKSLottery true 2 0")
        end
    end
end