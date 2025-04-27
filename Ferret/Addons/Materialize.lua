--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Materia Extraction screen
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local Materialize = Addon:extend()

function Materialize:new()
    Materialize.super.new(self, 'Materialize')
end

function Materialize:open()
    Actions.MateriaExtraction:execute()
end

function Materialize:close()
    Ferret:callback(self, true, -1)
end

function Materialize:click_first_slot()
    Ferret:callback(self, true, 2)
end

return Materialize()
