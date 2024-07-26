require("Ferret/Character")
require("Ferret/Food")
require("Ferret/GatherBuddy")
require("Ferret/Gathering")
require("Ferret/Gathering")
require("Ferret/Logger")
require("Ferret/Mount")
require("Ferret/Pathfinding")
require("Ferret/Retainers")
require("Ferret/Timer")
require("Ferret/World")

Ferret = {}
function Ferret:new(name)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.name = name
    self.run = true
    return o
end

function Ferret:init()
    self.character = Character:new(self)
    self.food = Food:new(self)
    self.gatherBuddy = GatherBuddy:new(self)
    self.gathering = Gathering:new(self)
    self.gathering = Gathering:new(self)
    self.logger = Logger:new(self)
    self.mount = Mount:new(self)
    self.pathfinding = Pathfinding:new(self)
    self.retainers = Retainers:new(self)
    self.timer = Timer:new(self)
    self.world = World:new(self)
end

function Ferret:wait(interval)
    yield('/wait ' .. interval)
end

function Ferret:repeatUntil(action, condition, delay, max)
    local delay = delay or 0.5
    local elapsed = 0

    repeat
        action()
        self:wait(delay)
        elapsed = elapsed + delay
    until condition() or (max ~= nil and max > 0 and elapsed >= max)
end


function Ferret:waitUntil(condition, delay, max)
    local delay = delay or 0.5
    local elapsed = 0

    repeat
        self:wait(delay)
        elapsed = elapsed + delay
    until condition() or (max ~= nil and max > 0 and elapsed >= max)
end

function Ferret:stop()
    self.run = false
end

function Ferret:setup()
    self.logger:debug("No setup implemented")
end

function Ferret:loop()
    self.logger:warn("No loop implemented")
    self:stop()
end

function Ferret:start()
    self.timer:start()
    self.logger:debug("Running Setup")
    self:setup()

    self.logger:debug("Starting loop...")
    while(self.run) do
        self:loop()
    end
    self.logger:debug("Done")
end

-- Helpers
function Ferret:getTableLength(subject)
    local count = 0

    for _ in pairs(subject) do
        count = count + 1
    end

    return count
end