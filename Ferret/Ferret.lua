--------------------------------------------------------------------------------
--   DESCRIPTION: Main library class
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

Object = require('external/classic')
require('Ferret/Library')

Ferret = Object:extend()
function Ferret:new(name)
    self.name = name
    self.run = true
    self.language = 'en'
    self.plugins = {}
    self.hook_subscriptions = {}
end

function Ferret:init()
    self.version = Version(0, 4, 3)
end

function Ferret:add_plugin(plugin)
    Logger:debug('Adding plugin: ' .. plugin.name)
    plugin:init(self)
    self.plugins[plugin.key] = plugin
end

function Ferret:wait(interval)
    yield('/wait ' .. interval)
end

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

    if condition() then
        return
    end

    repeat
        self:wait(delay)
        elapsed = elapsed + delay
    until condition() or (max ~= nil and max > 0 and elapsed >= max)
end

function Ferret:wait_for_addon(addon)
    Logger:debug('Waiting for addon: ' .. addon)
    self:wait_until(function()
        return IsAddonVisible(addon)
    end)
    Logger:debug('Addon ' .. addon .. ' is now visible')
end

function Ferret:wait_for_ready_addon(addon)
    Logger:debug('Waiting for ready addon: ' .. addon)
    self:wait_until(function()
        return IsAddonReady(addon)
    end)
    Logger:debug('Addon ' .. addon .. ' is now visible and ready')
end

function Ferret:stop()
    self.run = false
end

function Ferret:setup()
    Logger:debug('No setup implemented')
end

function Ferret:loop()
    Logger:warn('No loop implemented')
    self:stop()
end

function Ferret:start()
    Timer:start()
    Logger:info('Ferret version: ' .. self.version:to_string())
    Logger:debug('Running Setup')
    if not self:setup() then
        Logger:error('An error occured during setup')
        return
    end

    Logger:debug('Starting loop...')
    while self.run do
        self:emit(Hooks.PRE_LOOP)
        self:loop()
        self:emit(Hooks.POST_LOOP)
    end
    Logger:debug('Done')
end

function Ferret:subscribe(hook, callback)
    if not self.hook_subscriptions[hook] then
        self.hook_subscriptions[hook] = {}
    end

    table.insert(self.hook_subscriptions[hook], callback)
end

function Ferret:emit(hook, context)
    Logger:debug('Emitting event: ' .. hook)
    if not self.hook_subscriptions[hook] then
        return
    end

    for _, callback in pairs(self.hook_subscriptions[hook]) do
        callback(self, context)
    end
end

-- Helpers
function Ferret:get_table_length(subject)
    local count = 0

    for _ in pairs(subject) do
        count = count + 1
    end

    return count
end

function Ferret:table_contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function Ferret:table_random(subject)
    local keys = {}
    for key, _ in pairs(subject) do
        table.insert(keys, key)
    end

    local key = keys[math.random(1, #keys)]
    return subject[key]
end

function Ferret:table_first(subject)
    for _, value in pairs(subject) do
        return value
    end

    return nil
end

function Ferret:table_dump(subject)
    if type(subject) == 'table' then
        local s = '{ '
        for k, v in pairs(subject) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. self:table_dump(v) .. ','
        end
        return s .. '} '
    end

    return tostring(subject)
end

function Ferret:parse_number(str)
    return tonumber((str:gsub(',', ''):gsub('%.', ''):gsub(' ', '')))
end
