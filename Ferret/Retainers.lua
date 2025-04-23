require("Ferret/Node")

Retainers = {
    enabled = false,
    teleport = 'Solution Nine',
    bellNode = createNode(-150.1, 0.7, -13.7)
}

function Retainers:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Retainers:ready() return ARRetainersWaitingToBeProcessed() end

function Retainers:close() yield("/callback RetainerList true -1") end

function Retainers:check()
    if not self.enabled or not self:ready() then return end

    self.ferret.pathfinding:stop()
    self.ferret:wait(1)
    self.ferret.character:teleport(self.teleport)
    self.ferret.pathfinding:walkTo(self.bellNode)
    self.ferret.pathfinding:wait_to_start()
    self.ferret.pathfinding:wait_to_stop()
    self.ferret.character:target('Summoning Bell')
    self.ferret:wait(0.2)
    self.ferret.character:interact()

    self.ferret:wait_until(function() return not self:ready() end, 1)

    self.ferret:wait(5)
    self:close()
    self.ferret.character:wait_until_available()
    self:reset()
end

-- Script called after checking retainers to get you back on track with your task
function Retainers:reset() self.ferret.logger:warn('No reset script provided.') end
