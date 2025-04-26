--------------------------------------------------------------------------------
--   DESCRIPTION: Plugin that repairs your gear before a loop
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
-- OPTIONS:
--- threshold: [integer] Remaining gear durability required before repairing
--------------------------------------------------------------------------------

Repair = Plugin:extend()
function Repair:new()
    Repair.super.new(self, 'Repair', 'repair')
    self.threshold = 50
end

function Repair:init()
    Ferret:subscribe(Hooks.PRE_LOOP, function(context)
        Logger:debug('Checking if gear needs repairing')
        if not NeedsRepair(self.threshold) then
            Logger:debug('Gear does not need repairing')
            return
        end

        Logger:debug('Repairing')
        while not IsAddonVisible('Repair') do
            yield('/ac repair')
            Ferret:wait(0.5)
        end

        yield('/callback Repair true 0')
        Ferret:wait(0.1)

        if IsAddonVisible('SelectYesno') then
            yield('/callback SelectYesno true 0')
            Ferret:wait(0.1)
        end

        Ferret:wait_until(function()
            return not GetCharacterCondition(Conditions.Occupied39)
        end)

        Ferret:wait(1)
        yield('/callback Repair true -1')
        Logger:debug('Repaired all gear')
    end)
end

Ferret:add_plugin(Repair())
