require("Ferret/Ferret")

Spearfishing = {
    agpreset = null, -- Name of your autohook autogig preset
    fish = null, -- Name of the fish for GatherBuddy to teleport you to it
    reduceAt = 10 -- Number of inventory slots free to start aetherial reduction
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
    self.ferret.character:wait_until_available()

    if self.ferret.spearfishing.agpreset ~= null then
        self.ferret.logger:debug('Setting autohook gig preset: ' ..
                                     self.ferret.spearfishing.agpreset)
        yield('/agpreset ' .. self.ferret.spearfishing.agpreset)
    end

    if self.ferret.spearfishing.fish ~= null then
        self.ferret.gatherBuddy:gather_fish(self.ferret.spearfishing.fish)
    end

    self.ferret.mount:mount()

    self.ferret.pathfinding.index = 0
    local start = self.ferret.pathfinding.nodes[1]
    self.ferret.pathfinding:flyTo(start)
    self.ferret.pathfinding:wait_untilAtLocation(start)
end

function Ferret:setup()
    self.logger:info("Spearfishing Template v1.0.1")
    if not self.character:exists() then
        self.logger:error("Unable to get local player")
        return false
    end

    self.retainers:reset()

    return true
end

function Ferret:loop()

    local node = self.pathfinding:next()
    if node == null then
        self.logger:error("No node found")
        self.run = false
        return
    end

    self.mount:mount()
    self.pathfinding:flyTo(node)

    self.character:wait_for_target('Teeming Waters', 20)
    if not self.character:has_target() then
        self.logger:error('Could not find target')
        return
    end

    local target = self.character:get_target_position()
    self.pathfinding:flyTo(target)

    self.gathering:wait_to_start(7.5)
    if not self.gathering:is_gathering() then
        self.logger:error('Did not start gathering')
        return
    end

    self.pathfinding:stop()
    self.gathering:wait_to_stop()
    self:wait(3) -- Allow time for pandora auto-cordial

    if GetInventoryFreeSlotCount() <= self.spearfishing.reduceAt then
        self.character:aetherial_reduction()
        self:wait(1)
    end

    self.retainers:check()
end
