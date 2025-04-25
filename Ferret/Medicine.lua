require("Ferret/Data/Status")

Medicine = {medicine = null, should_medicate = false, medicine_at = 5}

function Medicine:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Medicine:is_medicated() return HasStatus('Medicated') end

function Medicine:get_minutes_left()
    return math.floor(GetStatusTimeRemaining(Status.Medicated) / 60)
end

function Medicine:wait_to_be_medicated(max)
    self.ferret.logger:debug('Waiting for medicated buff')
    self.ferret:wait_until(function() return self:is_medicated() end, 0.5, max)

    self.ferret.logger:debug('   >  Done')
end

function Medicine:wait_to_be_not_medicated(max)
    self.ferret:wait_until(function() return not self:is_medicated() end, 0.5, max)
end

function Medicine:medicate()
    if not self.should_medicate then return end

    if self.medicine == null then
        self.ferret.logger:debug('Not drinking, medicine not set')
        return
    end

    if self:get_minutes_left() > self.medicine_at then
        self.ferret.logger:debug('Not drinking, time not exceeded')
        return
    end

    self.ferret.logger:debug('Drinking: ' .. self.medicine)
    yield('/item ' .. self.medicine)
    self.ferret:wait(3)
end
