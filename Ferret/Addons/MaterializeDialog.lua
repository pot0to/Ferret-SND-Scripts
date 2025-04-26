--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Materia Extraction Yes/No popup
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local MaterializeDialog = Addon:extend()

function MaterializeDialog:new()
    MaterializeDialog.super.new(self, 'MaterializeDialog')
end

function MaterializeDialog:yes()
    yield('/callback MaterializeDialog true 0')
end

function MaterializeDialog:no()
    yield('/callback MaterializeDialog true 1')
end

return MaterializeDialog()
