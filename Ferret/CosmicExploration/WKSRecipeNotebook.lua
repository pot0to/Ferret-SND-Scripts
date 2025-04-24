WKSRecipeNotebook = Object:extend()

function WKSRecipeNotebook:new(ferret)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function WKSRecipeNotebook:is_visible()
    return IsAddonVisible("WKSRecipeNotebook")
end

function WKSRecipeNotebook:wait_until_visible()
    self.ferret:wait_for_addon("WKSRecipeNotebook")
end

function WKSRecipeNotebook:set_index(index)
    self:wait_until_visible()
    yield("/callback WKSRecipeNotebook true 0 " .. index)
end

function WKSRecipeNotebook:set_hq()
    self:wait_until_visible()
    yield("/callback WKSRecipeNotebook true 5")
end

function WKSRecipeNotebook:synthesize()
    self:wait_until_visible()
    yield("/callback WKSRecipeNotebook true 6")
end
