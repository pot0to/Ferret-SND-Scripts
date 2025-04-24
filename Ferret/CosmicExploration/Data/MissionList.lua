require("Ferret/CosmicExploration/Data/Mission")
require("Ferret/Data/Name")

MissionList = {
    missions = {}
}

function MissionList:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function MissionList:filter_by_job(job)
    local filtered = MissionList:new()
    for _, mission in ipairs(self.missions) do
        if mission.job == job then
            filtered.missions[mission.id] = mission
        end
    end

    return filtered
end

function MissionList:filter_by_class(class)
    local filtered = MissionList:new()
    for _, mission in ipairs(self.missions) do
        if mission.class == class then
            filtered.missions[mission.id] = mission
        end
    end

    return filtered
end
