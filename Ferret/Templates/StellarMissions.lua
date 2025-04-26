require("Ferret/Ferret")

MissionOrder = {
    TopPriority = 1, -- Execute missions in the order they are listed
    Random = 2 -- Execute missions in random order
}

StellarMissions = Ferret:extend()
function StellarMissions:new()
    StellarMissions.super:new("Stellar Missions Template")

    self.mission_list = {};
    self.mission_order = MissionOrder.TopPriority;
    self.missions_to_medicate_on = {};
    self.medicine_to_drink = nil;
    self.food_to_eat = nil;
    self.job = nil;
    self.template_version = Version:new(2, 1, 0);
end

function StellarMissions:setup()
    self.logger:info("Stellar missions " .. self.template_version:to_string())

    if self.job == nil then
        self.logger:error('Job not set')
        self.logger:info(
            "Please set `stellar_missions.job = Jobs.Carpenter` etc.")
        return false
    end

    self.cosmic_exploration:set_job(self.job)

    local error = false
    self.logger:debug("Found missions:")
    local actual_missions = MissionList:new()
    for _, mission in pairs(self.mission_list) do
        local found_mission = self.cosmic_exploration.mission_list:find_by_name(
                                  mission)

        if found_mission ~= nil then
            self.logger:debug(mission .. ": " .. found_mission:to_string())
            actual_missions.missions[found_mission.id] = found_mission
        else
            self.logger:error(mission .. ": Not found")
            error = true
        end
    end

    self.mission_list = actual_missions
    if error then return false end

    PauseYesAlready()

    return true
end

function StellarMissions:loop()
    self.logger:debug('Starting loop')

    self.cosmic_exploration.main_hud:wait_until_ready()

    self.cosmic_exploration.cosmic_fortunes:play()

    self.cosmic_exploration.mission_hud:open_basic_missions()

    local available_missions =
        self.cosmic_exploration.mission_hud:get_available_missions()
    local mission_list = available_missions:get_overlap(self.mission_list)

    if self:get_table_length(mission_list.missions) <= 0 then
        local classes = {}
        for _, mission in pairs(self.mission_list.missions) do
            if not self:table_contains(classes, mission.class) then
                table.insert(classes, mission.class)
            end
        end
        self.logger:debug("Selecting mission to abandon")
        local class = self:table_random(classes)
        local class_missions = available_missions:filter_by_class(class)
        local mission = class_missions:random()
        if mission == nil then mission = available_missions:random() end

        self.logger:debug("mission: " .. mission:to_string())

        mission:start()
        mission:abandon()
        return
    else
        self.logger:debug("Selecting mission to run")
        local mission = nil
        if self.mission_order == MissionOrder.TopPriority then
            mission = mission_list:first()
        elseif self.mission_order == MissionOrder.Random then
            mission = mission_list:random()
        end

        if mission == nil then
            self.logger:error("Error getting a mission.")
            self:stop()
            return
        end

        self.logger:debug("mission: " .. mission:to_string())
        mission:start()
        self.cosmic_exploration.recipe_notebook_hud:wait_until_ready()
        self:emit(Hooks.PRE_CRAFT)

        mission:handle()
        mission:report()
    end
end

local stellar_missions = StellarMissions()
stellar_missions:init()
stellar_missions.name = 'Stellar Missions'
FERRET = stellar_missions

return stellar_missions
