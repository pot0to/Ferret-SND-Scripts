NPC = Object:extend()
function NPC:new(name)
    self.name = name
end

function NPC:target()
    yield('/target "' .. self.name:get() .. '"')
end

function NPC:interact()
    self:target()
    Ferret:wait(0.2)
    yield('/interact')
end
