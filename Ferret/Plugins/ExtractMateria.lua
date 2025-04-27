--------------------------------------------------------------------------------
--   DESCRIPTION: Plugin that extracts materia before a loop
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

ExtractMateria = Plugin:extend()
function ExtractMateria:new()
    ExtractMateria.super.new(self, 'Extract Materia', 'extract_materia')
end

function ExtractMateria:init()
    Ferret:subscribe(Hooks.PRE_LOOP, function(Ferret, context)
        Logger:debug('Checking if materia needs to be extracted')

        if not CanExtractMateria() then
            Logger:debug('Materia does not need to be extracted')
            return
        end

        if not Materialize:is_visible() then
            Materialize:open()
            Materialize:wait_until_ready()
        end

        Logger:debug('Extracting Materia')

        while CanExtractMateria(100) do
            if Materialize:is_visible() then
                Ferret:repeat_until(function()
                    Materialize:click_first_slot()
                    MaterializeDialog:wait_until_ready()
                end, function()
                    return MaterializeDialog:is_visible()
                end)

                Ferret:repeat_until(function()
                    MaterializeDialog:yes()
                end, function()
                    return not MaterializeDialog:is_visible()
                end)
            end

            Ferret:wait_until(function()
                return not GetCharacterCondition(Conditions.Occupied39)
            end)
        end

        Materialize:close()
        Logger:debug('Extracted all materia')
    end)
end

Ferret:add_plugin(ExtractMateria())
