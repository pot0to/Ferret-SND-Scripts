local Character = Object:extend()

function Character:wait_until_done_crafting()
    repeat
        Ferret:wait(0.1)
    until not GetCharacterCondition(Conditions.Crafting40) and
        not GetCharacterCondition(Conditions.PreparingToCraft)
end

return Character()
