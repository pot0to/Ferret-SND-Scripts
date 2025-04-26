local WKSRecipeNotebook = Addon:extend()
function WKSRecipeNotebook:new()
    WKSRecipeNotebook.super.new(self, 'WKSRecipeNotebook')
end

function WKSRecipeNotebook:set_index(index)
    self:wait_until_ready()
    yield('/callback WKSRecipeNotebook true 0 ' .. index)
end

function WKSRecipeNotebook:set_hq()
    self:wait_until_ready()
    yield('/callback WKSRecipeNotebook true 5')
end

function WKSRecipeNotebook:synthesize()
    self:wait_until_ready()
    repeat
        if IsAddonReady('WKSRecipeNotebook') then
            yield('/callback WKSRecipeNotebook true 6')
        end
        Ferret:wait(0.1)
    until not IsAddonVisible('WKSRecipeNotebook')
end

return WKSRecipeNotebook()
