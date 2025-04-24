ExtractMateria = Plugin:extend()

function ExtractMateria:new()
    ExtractMateria.super:new("Extract Materia")
end

function ExtractMateria:pre_loop(ferret)
    ferret.logger:debug('Checking if materia needs to be extracted')
    if not CanExtractMateria() then
        ferret.logger:debug('Materia does not need to be extracted')
        return
    end

    ferret.logger:debug('Extracting Materia')
    yield('/ac "Materia Extraction"')
    yield('/waitaddon Materialize')
    while CanExtractMateria(100) do
        yield('/callback Materialize true 2')
        ferret:wait_until(function() return not GetCharacterCondition(39) end)
    end

    yield('/callback Materialize true -1')
    ferret.logger:debug("Extracted all materia")
end
