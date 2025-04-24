require("Ferret/Ferret")

MissionOrder = {
    TopPriority = 1, -- Execute missions in the order they are listed
    Random = 2 -- Execute missions in random order
}


StellarMissions = Object:extend()
function StellarMissions:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret

    self.mission_list = {};
    self.mission_order = MissionOrder.TopPriority;
    self.job = nil;
    self.version = Version:new(2, 0, 0);

    return o
end

ferret = Ferret:new("Stellar Missions Template")
ferret:init()

ferret.stellar_missions = StellarMissions:new(ferret)

function Ferret:setup()
    self.logger:info("Steller Missoins " ..
                         self.stellar_missions.version:to_string())

    if self.stellar_missions.job == nil then
        self.logger:error('Job not set')
        self.logger:info(
            "Please set `ferret.stellar_missions.job = Jobs.Carpenter` etc.")
        return false
    end

    self.cosmic_exploration:set_job(self.stellar_missions.job)


    local error = false
    self.logger:debug("Found missions:")
    local actual_missions = MissionList:new()
    for _, mission in pairs(self.stellar_missions.mission_list) do
        local found_mission = self.cosmic_exploration.mission_list:find_by_name(mission)

        if found_mission ~= nil then
            self.logger:debug(mission .. ": " .. found_mission:to_string())
            actual_missions.missions[found_mission.id] = found_mission
        else
            self.logger:error(mission .. ": Not found")
            error = true
        end
    end

    self.stellar_missions.mission_list = actual_missions
    if error then return false end


    return true
end

function Ferret:loop()
    self.logger:debug('Starting loop')

    self.cosmic_exploration.main_hud:wait_until_visible()
    self:wait(1)

    self.cosmic_exploration.mission_hud:open_basic_missions()
    self:wait(1)


    local available_missions = self.cosmic_exploration.mission_hud:get_available_missions()
    local mission_list = available_missions:get_overlap(self.stellar_missions.mission_list)

    if self:get_table_length(mission_list.missions) <= 0 then
        local classes = {}
        for _, mission in pairs(self.stellar_missions.mission_list.missions) do
            if not self:table_contains(classes, mission.class) then
                table.insert(classes, mission.class)
            end
        end
        self.logger:debug("Selection mission to abandon")
        local class = self:table_random(classes)
        local class_missions = available_missions:filter_by_class(class)
        local mission = class_missions:random()

        self.logger:debug("mission: " .. mission:to_string())
        
        mission:start()
        self.cosmic_exploration.recipe_notebook_hud:wait_until_visible()
        self:wait(1)
        mission:abandon()
        self:wait(5)
        return
    else
        self.logger:debug("Selection mission to run")
        local mission = mission_list:random()
        self.logger:debug("mission: " .. mission:to_string())
        mission:start()
        self.cosmic_exploration.recipe_notebook_hud:wait_until_visible()
        self:wait(1)
        mission:handle()
        self:wait(5)
        mission:report()
    end
end
