require("Ferret/Data/Conditions")
require("Ferret/Data/Objects")

GatherBuddy = {}

function GatherBuddy:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function GatherBuddy:gather(name)
    yield('/gather ' .. name)
    self.ferret.character:wait_untilNotAvailable(10)
    self.ferret.character:wait_until_available()
    self.ferret:wait(2)
end

function GatherBuddy:gather_fish(name)
    yield('/gather_fish ' .. name)
    self.ferret.character:wait_untilNotAvailable(10)
    self.ferret.character:wait_until_available()
    self.ferret:wait(2)
end
