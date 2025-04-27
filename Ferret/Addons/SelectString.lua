--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the SelectString
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local SelectString = Addon:extend()
function SelectString:new()
    SelectString.super.new(self, 'SelectString')
end

function SelectString:select_index(index)
    Ferret:callback(self, true, index)
end

return SelectString()
