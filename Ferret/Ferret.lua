require("Ferret/Character")
require("Ferret/Food")
require("Ferret/GatherBuddy")
require("Ferret/Gathering")
require("Ferret/Gathering")
require("Ferret/Logger")
require("Ferret/Mount")
require("Ferret/Pathfinding")
require("Ferret/Retainers")
require("Ferret/Spearfishing")
require("Ferret/Timer")
require("Ferret/World")
require("Ferret/CosmicExploration")
require("Ferret/Chat")

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
    self.spearfishing = Spearfishing:new(self)
    self.timer = Timer:new(self)
    self.world = World:new(self)
    self.cosmic_exploration = CosmicExploration:new(self)
    self.chat = Chat:new(self)

    self.character_name = nil;
end

function Ferret:wait(interval) yield('/wait ' .. interval) end

function Ferret:repeat_until(action, condition, delay, max)
    local delay = delay or 0.5
    local elapsed = 0

    repeat
        action()
        self:wait(delay)
        elapsed = elapsed + delay
    until condition() or (max ~= nil and max > 0 and elapsed >= max)
end

function Ferret:wait_until(condition, delay, max)
    local delay = delay or 0.5
    local elapsed = 0

    if condition() then return end

    repeat
        self:wait(delay)
        elapsed = elapsed + delay
    until condition() or (max ~= nil and max > 0 and elapsed >= max)
end

function Ferret:wait_for_addon(addon)
    self.logger:debug('Waiting for addon: ' .. addon)
    self:wait_until(function() return IsAddonVisible(addon) end)
    self.logger:debug('Addon ' .. addon .. ' is now visible')
end

function Ferret:stop() self.run = false end

function Ferret:setup() self.logger:debug("No setup implemented") end

function Ferret:loop()
    self.logger:warn("No loop implemented")
    self:stop()
end

function Ferret:pre_loop()
    self.character:extract_materia()
    self.character:repair()
    self.food:eat()
    self.retainers:check()
end

function Ferret:start()
    self.timer:start()
    self.logger:debug("Running Setup")
    if not self:setup() then
        self.logger:error("An error occured during setup")
        return
    end

    self.logger:debug("Starting loop...")
    while (self.run) do
        -- self:pre_loop()
        self:loop()
    end
    self.logger:debug("Done")
end

-- Helpers
function Ferret:get_table_length(subject)
    local count = 0

    for _ in pairs(subject) do count = count + 1 end

    return count
end
