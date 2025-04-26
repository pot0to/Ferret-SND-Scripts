require("Ferret/Addons/MaterializeDialog")
require("Ferret/Addons/Materialize")

ExtractMateria = Plugin:extend()

function ExtractMateria:new()
    ExtractMateria.super.new(self, "Extract Materia", "extract_materia")
end

function ExtractMateria:init(ferret)
    self.ferret = ferret
    self.addon = Materialize(ferret)
    self.dialog = MaterializeDialog(ferret)

    self.ferret:subscribe(Hooks.PRE_LOOP, function()
        self.ferret.logger:debug('Checking if materia needs to be extracted')
        self.ferret.logger:debug('Extracting Materia')

        if not CanExtractMateria() then
            self.ferret.logger:debug('Materia does not need to be extracted')
            return
        end

        if not self.addon:is_visible() then
            self.addon:open()
            self.addon:wait_until_ready()
        end

        while CanExtractMateria(100) do
            if not self.dialog:is_visible() then
                self.addon:click_first_slot()
                self.dialog:wait_until_visible()
            end

            self.ferret:repeat_until(function() self.dialog:yes() end,
                                     function()
                return not self.dialog:is_visible()
            end)

            ferret:wait_until(function()
                return not GetCharacterCondition(Conditions.Occupied39)
            end)
        end

        self.addon:close()
        ferret.logger:debug("Extracted all materia")
    end)
end

FERRET:add_plugin(ExtractMateria())
