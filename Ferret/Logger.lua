Logger = {ferret = nil, log_to_file = false, show_debug = false}

function Logger:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    self.path = ferret.name .. '.log'
    return o
end

function Logger:info(contents)
    yield('/e [' .. self.ferret.name .. '][Info]: ' .. contents)
end

function Logger:debug(contents)
    if not self.show_debug then return end

    yield('/e [' .. self.ferret.name .. '][Debug]: ' .. contents)
end

function Logger:warn(contents)
    yield('/e [' .. self.ferret.name .. '][Warn]: ' .. contents)
end

function Logger:error(contents)
    yield('/e [' .. self.ferret.name .. '][Error]: ' .. contents)
end

function Logger:set_debug(value) self.show_debug = value end
