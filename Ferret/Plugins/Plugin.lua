Plugin = Object:extend()

function Plugin:new(name, key)
    self.name = name
    self.key = key
end

function Plugin:init(ferret) end

