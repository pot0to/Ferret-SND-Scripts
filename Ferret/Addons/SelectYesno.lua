--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the SelectYesno
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local SelectYesno = Addon:extend()
function SelectYesno:new()
    SelectYesno.super.new(self, 'SelectYesno')
end

function SelectYesno:yes()
    Ferret:callback(self, true, 0)
end

return SelectYesno()
