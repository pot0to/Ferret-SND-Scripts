--------------------------------------------------------------------------------
--   DESCRIPTION: Abstract action class
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

Action = Object:extend()
function Action:new(name)
    self.name = name
end

function Action:execute()
    Ferret:action(self.name:get())
end
