--------------------------------------------------------------------------------
--   DESCRIPTION: Action for opening the Materia Extraction interface
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local MateriaExtraction = Action:extend()
function MateriaExtraction:new()
    MateriaExtraction.super.new(
        self,
        Translatable('Materia Extraction')
            :with_de('Materia-Extraktion')
            :with_fr('Matérialisation')
            :with_jp('マテリア精製')
    )
end

return MateriaExtraction()
