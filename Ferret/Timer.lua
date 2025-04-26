local Timer = Object:extend()

function Timer:new()
    self.startTime = 0
end

function Timer:start()
    self.startTime = os.time()
end

function Timer:seconds()
    return os.difftime(os.time(), self.startTime)
end

return Timer()
