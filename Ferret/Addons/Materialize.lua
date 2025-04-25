Materialize = Addon:extend()

function Materialize:new(ferret)
    Materialize.super.new(self, "Materialize", ferret)
end

function Materialize:open() yield('/ac "Materia Extraction"') end

function Materialize:close() yield('/callback Materialize true -1') end

function Materialize:click_first_slot() yield('/callback Materialize true 2') end
