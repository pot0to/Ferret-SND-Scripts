require("Ferret/Node")
require("Ferret/Data/Conditions")

Mount = {
    name = null
}
function Mount:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Mount:isMounted()
    return self.ferret.character:hasCondition(Conditions.Mounted)
end

function Mount:isMounting()
    return self.ferret.character:hasCondition(Conditions.Mounting)
end

function Mount:isFlying()
    return self.ferret.character:hasCondition(Conditions.Flying)
end

function Mount:roulette()
    self.ferret.logger:debug("Calling Mount Roulette")
    if self:isMounted() then
        self.ferret.logger:debug("   > Already mounted")
        return
    end

    self.ferret:repeatUntil(
        function() yield('/ac "Mount Roulette"') end,
        function() return self:isMounted() end,
        2
    )
end

function Mount:mount(mount)
    local mount = mount or self.name
    if mount == null then
        return self:roulette()
    end

    self.ferret.logger:debug("Calling Mount: " .. mount)
    self.ferret:repeatUntil(
        function() yield('/mount "' .. mount .. '"') end,
        function() return self:isMounted() end,
        2
    )
end

function Mount:unmount(max)
    local max = max or 10

    self.ferret.logger:debug("Unmounting...")
    self.ferret:repeatUntil(
        function() yield('/mount') end,
        function() return not self:isFlying() and not self:isMounted() end,
        0.5,
        max
    )
end

function Mount:land(max)
    local max = max or 10

    self.ferret.logger:debug("Unmounting...")
    self.ferret.logger:warn("Mount:land is a little buggy")
    self.ferret:repeatUntil(
        function() if self:isFlying() then yield('/mount') end end,
        function() return not self:isFlying() end,
        2,
        max
    )

    -- This function is a bit bugged, sometimes it will unmount you
    -- This call remounts you if you get unmounted
    self:mount()
end
