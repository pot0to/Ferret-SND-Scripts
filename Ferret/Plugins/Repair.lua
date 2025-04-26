Repair = Plugin:extend()

function Repair:new(threshold)
    Repair.super:new('Repair', 'repair')
    self.threshold = threshold or 50
end

function Repair:init(ferret)
    Logger:debug(':(Repair)')
    ferret:subscribe(Hooks.PRE_LOOP, function(ferret, context)
        Logger:debug('Checking if gear needs repairing')
        if not NeedsRepair(self.threshold) then
            Logger:debug('Gear does not need repairing')
            return
        end

        Logger:debug('Repairing')
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

        ferret:wait_until(function()
            return not GetCharacterCondition(Conditions.Occupied39)
        end)

        ferret:wait(1)
        yield('/callback Repair true -1')
        Logger:debug('Repaired all gear')
    end)
end

-- function Repair:pre_loop(ferret)

-- end

Ferret:add_plugin(Repair())
