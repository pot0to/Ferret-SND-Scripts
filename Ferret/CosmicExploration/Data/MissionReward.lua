MissionReward = {}

function MissionReward:new(job, tier, amount)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.job = job
    o.tier = tier
    o.amount = amount

    return o
end
