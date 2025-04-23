require("Ferret/Data/Status")

Food = {food = null, should_eat = false, eat_at = 5}

function Food:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Food:is_fed() return HasStatus('Well Fed') end

function Food:get_minutes_left()
    return math.floor(GetStatusTimeRemaining(Status.WellFed) / 60)
end

function Food:wait_to_be_fed(max)
    self.ferret.logger:debug('Waiting for well fed buff')
    self.ferret:wait_until(function() return self:is_fed() end, 0.5, max)

    self.ferret.logger:debug('   >  Done')
end

function Food:wait_to_be_not_fed(max)
    self.ferret:wait_until(function() return not self:is_fed() end, 0.5, max)
end

function Food:eat()
    if not self.should_eat then return end

    if self.food == null then
        self.ferret.logger:debug('Not eating, food not set')
        return
    end

    if self:get_minutes_left() > self.eat_at then
        self.ferret.logger:debug('Not eating, time not exceeded')
        return
    end

    self.ferret.logger:debug('Eating: ' .. self.food)
    yield('/item ' .. self.food)
    self.ferret:wait(5)
end
