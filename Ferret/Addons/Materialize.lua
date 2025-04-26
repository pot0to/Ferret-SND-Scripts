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
    yield('/ac "Materia Extraction"')
end

function Materialize:close()
    yield('/callback Materialize true -1')
end

function Materialize:click_first_slot()
    yield('/callback Materialize true 2')
end

return Materialize()
