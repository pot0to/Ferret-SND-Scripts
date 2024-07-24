require("Ferret/Data/Status")
require("Ferret/Node")

Food = {
    food = null,
    eat = false,
    eatAt = 5
}

function Food:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Food:isFed()
    return HasStatus('Well Fed')
end

function Food:getMinutesLeft()
    return math.floor(GetStatusTimeRemaining(Status.WellFed) / 60)
end

function Food:waitToBeFed(max)
    self.ferret.logger:debug('Waiting for well fed buff')
    self.ferret:waitUntil(
        function() return self:isFed() end,
        0.5,
        max
    )

    self.ferret.logger:debug('   >  Done')
end

function Food:waitToBeNotFed(max)
    self.ferret:waitUntil(
        function() return not self:isFed() end,
        0.5,
        max
    )
end

function Food:eat()
    if not self.eat then
        return
    end

    if self.food == null then
        self.ferret.logger:debug('Not eating, food not set')
        return
    end

    if self:getMinutesLeft() > self.eatAt then
        self.ferret.logger:debug('Not eating, time not exceeded')
        return
    end

    self.ferret.logger:debug('Eating: ' .. self.food)
    yield('/item '  .. self.food)
    self.ferret:wait(5)
end