Addon = Object:extend()

function Addon:new(key, ferret)
    self.key = key
    self.ferret = ferret
end

function Addon:is_ready() return IsAddonReady(self.key) end

function Addon:wait_until_ready()
    self.ferret.logger:debug("Waiting for addon to be ready: " .. self.key)
    self.ferret:wait_until(function() return self:is_ready() end)
    self.ferret.logger:debug("Addon ready: " .. self.key)
end

function Addon:is_visible() return IsAddonVisible(self.key) end

function Addon:wait_until_visible()
    self.ferret.logger:debug("Waiting for addon to be visible: " .. self.key)
    self.ferret:wait_until(function() return self:is_visible() end)
    self.ferret.logger:debug("Addon visible: " .. self.key)
end
