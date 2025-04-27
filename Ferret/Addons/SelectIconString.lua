--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the SelectIconString
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local SelectIconString = Addon:extend()
function SelectIconString:new()
    SelectIconString.super.new(self, 'SelectIconString')
end

function SelectIconString:select_index(index)
    Ferret:callback(self, true, index)
end

return SelectIconString()
