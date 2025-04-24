Repair = Plugin:extend()

function Repair:new(threshold)
    Repair.super:new("Repair")
    self.threshold = threshold or 50
end

function Repair:pre_loop(ferret)
    ferret.logger:debug('Checking if gear needs repairing')
    if not NeedsRepair(self.threshold) then
        ferret.logger:debug('Gear does not need repairing')
        return
    end

    ferret.logger:debug('Repairing')
    while not IsAddonVisible('Repair') do
        yield('/ac repair')
        ferret:wait(0.5)
    end

    yield('/callback Repair true 0')
    ferret:wait(0.1)

    if IsAddonVisible('SelectYesno') then
        yield('/callback SelectYesno true 0')
        ferret:wait(0.1)
    end

    ferret:wait_until(function() return not GetCharacterCondition(39) end)

    ferret:wait(1)
    yield('/callback Repair true -1')
    ferret.logger:debug("Repaired all gear")

end
