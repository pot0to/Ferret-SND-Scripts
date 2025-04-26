Addon = Object:extend()

function Addon:new(key)
    self.key = key
end

function Addon:is_ready() return IsAddonReady(self.key) end

function Addon:wait_until_ready()
    Logger:debug("Waiting for addon to be ready: " .. self.key)
    Ferret:wait_until(function() return self:is_ready() end)
    Logger:debug("Addon ready: " .. self.key)
end

function Addon:is_visible() return IsAddonVisible(self.key) end

function Addon:wait_until_visible()
    Logger:debug("Waiting for addon to be visible: " .. self.key)
    Ferret:wait_until(function() return self:is_visible() end)
    Logger:debug("Addon visible: " .. self.key)
end
