require("Ferret/Ferret")

MissionOrder = {
    TopPriority = 1, -- Execute missions in the order they are listed
    Random = 2 -- Execute missions in random order
}

StellarMissions = {
    missions = {}, -- Missions to automatically start
    mission_order = MissionOrder.TopPriority
}

function StellarMissions:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function StellarMissions:get_first_desired_mission()
    local missions = self.missions
    if self.mission_order == MissionOrder.Random then
        function shuffle(tbl)
            for i = #tbl, 2, -1 do
                local j = math.random(i)
                tbl[i], tbl[j] = tbl[j], tbl[i]
            end
            return tbl
        end

        missions = shuffle(missions)
    end

    for _, mission in ipairs(missions) do
        if self.ferret.cosmic_exploration:is_mission_available(mission) then
            return mission
        end
    end

    return nil
end

ferret = Ferret:new("Stellar Missions Template")
ferret:init()

ferret.stellar_missions = StellarMissions:new(ferret)

function Ferret:setup()
    self.logger:info("Steller Missoins V1.0.0")

    return true
end

function Ferret:loop()
    self.logger:debug('Waiting for CE UI to be visible')
    self.cosmic_exploration:wait_for_main_ui_to_be_visible()

    self.cosmic_exploration:open_basic_mission_ui()

    local mission = self.stellar_missions:get_first_desired_mission()
    if mission == nil then
        if not self.cosmic_exploration:refresh_missions() then
            self.logger:error('Could not find mission to abandon')
            self.run = false
            return
        end
    end

    self.cosmic_exploration:start_mission(mission)
    self:wait(1)
    self.cosmic_exploration:wait_to_start_mission()

    self.logger:debug('Mission started')
    self:repeat_until(function() self.cosmic_exploration:start_craft() end,
                      function()
        return self.cosmic_exploration:has_finished_mission()
    end)

    self:wait(4)
    self.cosmic_exploration:report_mission()
    self:wait(2)
end
