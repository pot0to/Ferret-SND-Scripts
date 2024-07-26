require("Ferret/Ferret")

Spearfishing = {
    agpreset = null, -- Name of your autohook autogig preset
    fish = null, -- Name of the fish for GatherBuddy to teleport you to it
    reduceAt = 10, -- Number of inventory slots free to start aetherial reduction
}
function Spearfishing:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

ferret = Ferret:new("Spearfishing Template")
ferret:init()

ferret.spearfishing = Spearfishing:new(ferret)

function Retainers:reset()
    self.ferret.character:waitUntilAvailable()

    if self.ferret.spearfishing.agpreset ~= null then
        self.ferret.logger:debug('Setting autohook gig preset: ' .. self.ferret.spearfishing.agpreset)
        yield('/agpreset ' .. self.ferret.spearfishing.agpreset)
    end

    if self.ferret.spearfishing.fish ~= null then
        self.ferret.gatherBuddy:gatherFish(self.ferret.spearfishing.fish)
    end

    self.ferret.mount:mount()

    self.ferret.pathfinding.index = 0
    local start = self.ferret.pathfinding.nodes[1]
    self.ferret.pathfinding:flyTo(start)
    self.ferret.pathfinding:waitUntilAtLocation(start)
end

function Ferret:setup()
    self.logger:info("Spearfishing Template v1.0.0")
    self.retainers:reset()
end

function Ferret:loop()
    local node = self.pathfinding:next()
    if node == null then
        self.logger:error("No node found")
        self.run = false
        return
    end

    self:wait(2)
    self.mount:mount()
    self.pathfinding:flyTo(node)

    self.character:waitForTarget('Teeming Waters', 20)
    if not self.character:hasTarget() then
        self.logger:error('Could not find target')
        return
    end

    local target = self.character:getTargetPosition()
    self.pathfinding:flyTo(target)

    self.gathering:waitToStart(7.5)
    if not self.gathering:isGathering() then
        self.logger:error('Did not start gathering')
        return
    end

    self.pathfinding:stop()
    self.gathering:waitToStop()
    self:wait(3) -- Allow time for pandora auto-cordial

    self.character:extractMateria()
    self.character:repair()
    self.food:eat()

    if GetInventoryFreeSlotCount() <= self.spearfishing.reduceAt then
        self.character:aetherialReduction()
        self:wait(1)
    end

    self.retainers:check()
end
