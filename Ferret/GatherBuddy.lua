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
    self.ferret.character:waitUntilNotAvailable(10)
    self.ferret.character:waitUntilAvailable()
    self.ferret:wait(2)
end

function GatherBuddy:gatherFish(name)
    yield('/gatherfish ' .. name)
    self.ferret.character:waitUntilNotAvailable(10)
    self.ferret.character:waitUntilAvailable()
    self.ferret:wait(2)
end
