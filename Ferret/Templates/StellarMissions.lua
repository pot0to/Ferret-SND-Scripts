require("Ferret/Ferret")

MissionOrder = {
    TopPriority = 1, -- Execute missions in the order they are listed
    Random = 2 -- Execute missions in random order
}

StellarMissions = {
    missions = {}, -- Missions to automatically start
    mission_order = MissionOrder.TopPriority,
    job = nil,
    version = Version:new(1, 1, 0)
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

        self.ferret.logger:debug('Checking mission: ' .. mission)
        if self.ferret.cosmic_exploration:is_mission_available(mission) then
            return mission
        end
    end

    return nil
end

function StellarMissions:get_mission_class()
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
        local id = self.ferret.cosmic_exploration:get_mission_id_from_name(
                       mission)

        return self.ferret.cosmic_exploration.filtered_missions[id].class
    end
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

    self.cosmic_exploration:generate_filtered_missions(self.stellar_missions.job)

    return true
end

function Ferret:loop()
    self.logger:debug('Starting loop')
    self.logger:debug('Waiting for CE UI to be visible')
    self.cosmic_exploration:wait_for_main_ui_to_be_visible()

    self.logger:debug('Ensuring Mission UI is open')
    self.cosmic_exploration:open_basic_mission_ui()

    self.logger:debug('Getting desired mission')
    local mission = self.stellar_missions:get_first_desired_mission()
    if mission == nil then
        self.logger:debug('No desired mission found')
        local class = self.stellar_missions:get_mission_class()
        self.logger:debug('Abandoning mission with class: ' .. class)
        if not self.cosmic_exploration:refresh_missions(class) then
            self.logger:error('Could not find mission to abandon')
            self.run = false
        end

        return
    end

    local mission_id = self.cosmic_exploration:get_mission_id_from_name(mission)
    local mission_data = self.cosmic_exploration.filtered_missions[mission_id]
    self.logger:debug('Starting mission: ' .. mission)
    self.logger:debug('    mission id:' .. mission_id)
    self.logger:debug('    mission class:' .. mission_data.class)
    self.logger:debug('    mission job:' .. mission_data.job)

    self.cosmic_exploration:start_mission(mission_id)

    self:wait(1)
    self.cosmic_exploration:wait_to_start_mission()

    self.logger:debug('Mission started')

    if self.cosmic_exploration:has_multiple_items_to_craft() then
        if mission_data.multi_craft_config ~= nil then
            self.logger:debug('Using multi craft config')

            local craft_index = 0
            repeat
                local crafts_required =
                    mission_data.multi_craft_config[craft_index]
                local crafts_complete = 0
                self.logger:debug('Crafting item ' .. craft_index)
                self.cosmic_exploration:select_craft(craft_index)
                self:wait(1)
                repeat
                    self:wait_for_addon('WKSRecipeNotebook')
                    self:wait(1)
                    self.logger:debug('Starting craft...')
                    self.cosmic_exploration:start_craft()
                    self.logger:debug('Waiting to start craft...')
                    self:wait_for_addon('Synthesis')
                    self.logger:debug('Waiting to finish craft...')

                    crafts_complete = crafts_complete + 1
                    self.logger:debug('Crafts complete (' .. crafts_complete ..
                                          '/' .. crafts_required .. ')')
                until crafts_complete >= crafts_required
                craft_index = craft_index + 1
            until craft_index > #mission_data.multi_craft_config
        else
            self.logger:debug('Multiple items to craft, user take over')
            -- Let user handle crafting if there are multiple items
            self:wait_until(function()
                self.cosmic_exploration:has_finished_mission()
            end)
        end
    else
        self.logger:debug('Single item to craft, starting crafting')
        self:repeat_until(function()
            self.cosmic_exploration:start_craft()
        end, function()
            return self.cosmic_exploration:has_finished_mission()
        end)
    end

    self.logger:debug('Crafting finished, waiting to report')
    self:wait(4)
    self.logger:debug('Reporting mission')
    self.cosmic_exploration:report_mission()
    self.logger:debug('Mission reported')
    self:wait(2)

    self.logger:debug('End of loop')
end
