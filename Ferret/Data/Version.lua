Version = {}

function Version:new(major, minor, patch)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.major = major or 0
    o.minor = minor or 0
    o.patch = patch or 0
    return o
end

function Version:to_string()
    return string.format("v%d.%d.%d", self.major, self.minor, self.patch)
end
