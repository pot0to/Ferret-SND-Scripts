local Logger = Object:extend()

function Logger:new()
    self.log_to_file = false
    self.show_debug = false
end

function Logger:info(contents)
    yield('/e [' .. Ferret.name .. '][Info]: ' .. contents)
end

function Logger:debug(contents)
    if not self.show_debug then
        return
    end

    yield('/e [' .. Ferret.name .. '][Debug]: ' .. contents)
end

function Logger:warn(contents)
    yield('/e [' .. Ferret.name .. '][Warn]: ' .. contents)
end

function Logger:error(contents)
    yield('/e [' .. Ferret.name .. '][Error]: ' .. contents)
end

return Logger()
