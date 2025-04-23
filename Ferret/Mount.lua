require("Ferret/Node")
require("Ferret/Data/Conditions")

Mount = {name = null}
function Mount:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Mount:is_mounted()
    return self.ferret.character:has_condition(Conditions.Mounted)
end

function Mount:is_mounting()
    return self.ferret.character:has_condition(Conditions.Mounting)
end

function Mount:is_flying()
    return self.ferret.character:has_condition(Conditions.Flying)
end

function Mount:roulette()
    self.ferret.logger:debug("Calling Mount Roulette")
    if self:is_mounted() then
        self.ferret.logger:debug("   > Already mounted")
        return
    end

    self.ferret:repeat_until(function() yield('/ac "Mount Roulette"') end,
                             function() return self:is_mounted() end, 2)
end

function Mount:mount(mount)
    local mount = mount or self.name
    if mount == null then return self:roulette() end

    self.ferret.logger:debug("Calling Mount: " .. mount)
    self.ferret:repeat_until(function() yield('/mount "' .. mount .. '"') end,
                             function() return self:is_mounted() end, 2)
end

function Mount:unmount(max)
    local max = max or 10

    self.ferret.logger:debug("Unmounting...")
    self.ferret:repeat_until(function() yield('/mount') end, function()
        return not self:is_flying() and not self:is_mounted()
    end, 0.5, max)
end

function Mount:land(max)
    local max = max or 10

    self.ferret.logger:debug("Unmounting...")
    self.ferret.logger:warn("Mount:land is a little buggy")
    self.ferret:repeat_until(function()
        if self:is_flying() then yield('/mount') end
    end, function() return not self:is_flying() end, 2, max)

    -- This function is a bit bugged, sometimes it will unmount you
    -- This call remounts you if you get unmounted
    self:mount()
end
