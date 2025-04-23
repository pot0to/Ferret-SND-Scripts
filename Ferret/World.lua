World = {}

function World:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function World:get_current_hour() return GetCurrentEorzeaHour() end

function World:is_time_between(a, b)
    local current = self:get_current_hour()
    if b < a then b = b + 24 end

    return current >= a and current < b
end

function World:wait_until_time(time)
    self.ferret.logger:info('Waiting for time...')
    self.ferret:wait_until(
        function() return self:get_current_hour() == time end, 3)
    self.ferret.logger:info('Done..')
end

function World:has_special_node()
    return GetActiveMiniMapGatheringMarker() ~= null
end

function World:get_special_node()
    local marker = GetActiveMiniMapGatheringMarker()
    if marker == null then return null end

    local y = QueryMeshPointOnFloorY(marker[0], 1024, marker[1], false, 1);

    self.ferret.logger:info("X: " .. marker[0])
    self.ferret.logger:info("Y: " .. y)
    self.ferret.logger:info("Z: " .. marker[1])

    return create_node(marker[0], y, marker[1])
end
