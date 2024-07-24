Timer = {
    ferret = nil,
    startTime = 0
}

function Timer:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Timer:start()
    self.startTime = os.time()
end

function Timer:seconds()
    return os.difftime(os.time(), self.startTime)
end
