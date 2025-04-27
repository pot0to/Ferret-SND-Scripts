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
    Ferret:callback(self, true, 0)
end

function MaterializeDialog:no()
    Ferret:callback(self, true, 1)
end

return MaterializeDialog()
