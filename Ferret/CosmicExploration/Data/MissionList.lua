require("Ferret/CosmicExploration/Data/Mission")
require("Ferret/Data/Name")

MissionList = Object:extend()

function MissionList:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.missions = {}

    return o
end

function MissionList:filter_by_job(job)
    local filtered = MissionList:new()
    for _, mission in ipairs(self.missions) do
        if mission.job == job then
            filtered.missions[mission.id] =  mission;
        end
    end

    return filtered
end

function MissionList:filter_by_class(class)
    local filtered = MissionList:new()
    for _, mission in pairs(self.missions) do
        if mission.class == class then
            filtered.missions[mission.id] =  mission;
        end
    end

    return filtered
end

function MissionList:find_by_name(name, lang)
    for _, mission in pairs(self.missions) do
        local start_index = string.find(mission.name:get('en'), name, 0, true)

        if start_index ~= nil and start_index <= 4 then
            return mission; 
        end
    end

    return nil
end

function MissionList:first()
    for _, mission in pairs(self.missions) do
        return mission
    end

    return nil
end

function MissionList:random()
    local keys = {}

    for _, mission in pairs(self.missions) do
        table.insert(keys, mission.id)
    end

    local key = keys[math.random(1, #keys)]
    ferret.logger:info("key: " .. key)
    return self.missions[key]
end

function MissionList:has_id(id)
    return self.missions[id] ~= nil
end

function MissionList:get_overlap(other)
    local overlap = MissionList:new()

    for _, mission in pairs(self.missions) do
        if other:has_id(mission.id) then
            -- ferret.logger:debug(mission or "NA")
            overlap.missions[mission.id] = mission
        end
    end

    return overlap
end