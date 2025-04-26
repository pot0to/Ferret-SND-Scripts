Object = require("external/classic")

require("Ferret/Version")
require("Ferret/Plugins/Plugin")
require("Ferret/Character")
require("Ferret/Food")
require("Ferret/Medicine")
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
require("Ferret/CosmicExploration/CosmicExploration")
require("Ferret/Data/Hooks")

require("Ferret/Addons/Addon")
require("Ferret/Addons/ToDoList")

Ferret = Object:extend()
function Ferret:new(name)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.name = name
    self.run = true
    self.language = 'en'
    self.plugins = {}
    self.hook_subscriptions = {}
    return o
end

function Ferret:init()
    self.version = Version:new(0, 3, 1)
    self.character = Character:new(self)
    self.food = Food:new(self)
    self.medicine = Medicine:new(self)
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

    self.character_name = nil;

    self.to_do_list = ToDoList()
end

function Ferret:add_plugin(plugin)
    self.logger:debug("Adding plugin: " .. plugin.name)
    plugin:init(self)
    self.plugins[plugin.key] = plugin
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

function Ferret:wait_for_ready_addon(addon)
    self.logger:debug('Waiting for ready addon: ' .. addon)
    self:wait_until(function() return IsAddonReady(addon) end)
    self.logger:debug('Addon ' .. addon .. ' is now visible and ready')
end

function Ferret:stop() self.run = false end

function Ferret:setup() self.logger:debug("No setup implemented") end

function Ferret:loop()
    self.logger:warn("No loop implemented")
    self:stop()
end

function Ferret:start()
    self.timer:start()
    self.logger:info("Ferret version: " .. self.version:to_string())
    self.logger:debug("Running Setup")
    if not self:setup() then
        self.logger:error("An error occured during setup")
        return
    end

    self.logger:debug("Starting loop...")
    while (self.run) do
        self:emit(Hooks.PRE_LOOP)
        self:loop()
        self:emit(Hooks.POST_LOOP)
    end
    self.logger:debug("Done")
end

function Ferret:subscribe(hook, callback)
    if not self.hook_subscriptions[hook] then
        self.hook_subscriptions[hook] = {}
    end

    table.insert(self.hook_subscriptions[hook], callback)
end

function Ferret:emit(hook)
    self.logger:debug("Emitting event: " .. hook)
    if not self.hook_subscriptions[hook] then return end

    for _, callback in pairs(self.hook_subscriptions[hook]) do callback() end
end

-- Helpers
function Ferret:get_table_length(subject)
    local count = 0

    for _ in pairs(subject) do count = count + 1 end

    return count
end

function Ferret:table_contains(table, value)
    for _, v in pairs(table) do if v == value then return true end end
    return false
end

function Ferret:table_random(subject)
    local keys = {}
    for key, _ in pairs(subject) do table.insert(keys, key) end

    local key = keys[math.random(1, #keys)]
    return subject[key]
end
