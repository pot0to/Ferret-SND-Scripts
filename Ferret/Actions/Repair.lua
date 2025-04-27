--------------------------------------------------------------------------------
--   DESCRIPTION: Action for opening the repair interface
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local Repair = Action:extend()
function Repair:new()
    Repair.super.new(self, Translatable('Repair'):with_de('Reparatur'):with_fr('Rapatriement'):with_jp('修理'))
end

return Repair()
