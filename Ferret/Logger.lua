Logger = {
    ferret = nil,
    logToFile = false,
    showDebug = false
}

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
    if not self.showDebug then
        return
    end

    yield('/e [' .. self.ferret.name .. '][Debug]: ' .. contents)
end

function Logger:warn(contents)
    yield('/e [' .. self.ferret.name .. '][Warn]: ' .. contents)
end

function Logger:error(contents)
    yield('/e [' .. self.ferret.name .. '][Error]: ' .. contents)
end

function Logger:setDebug(value)
    self.showDebug = value
end
