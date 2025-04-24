require("Ferret/CosmicExploration/Data/MasterMissionList")
CosmicExploration = {
    custom_solutions = {
        -- CRP
        ["Cosmoliner Supplies"] = (function() end)
    },
    missions = {}
}

function CosmicExploration:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function CosmicExploration:is_main_ui_visible() return IsAddonVisible("WKSHud") end

function CosmicExploration:wait_for_main_ui_to_be_visible()
    self.ferret:wait_until(function() return self:is_main_ui_visible() end);
end

function CosmicExploration:generate_filtered_missions(job)
    self.missions = MasterMissionList:filter_by_job(job)
end

function CosmicExploration:start_craft()
    if IsAddonVisible("WKSRecipeNotebook") then
        yield("/callback WKSRecipeNotebook true 6")
    end
end

function CosmicExploration:select_craft(index)
    if IsAddonVisible("WKSRecipeNotebook") then
        yield("/callback WKSRecipeNotebook true 0 " .. index)
        self.ferret:wait(1)
        yield("/callback WKSRecipeNotebook true 5") -- Set to HQ
        self.ferret:wait(1)
    end
end

function CosmicExploration:has_multiple_items_to_craft()
    return GetNodeText("WKSRecipeNotebook", 52, 2, 14) ~= ""
end

function CosmicExploration:open_mission_ui()
    if IsAddonVisible("WKSHud") then
        if not IsAddonVisible("WKSMission") then
            yield("/callback WKSHud true 11")
            self.ferret:wait_for_addon("WKSMission")
        end
    end
end

function CosmicExploration:open_basic_mission_ui()
    if IsAddonVisible("WKSHud") then
        self:open_mission_ui()
        yield("/callback WKSMission true 15 0")
    end
end

function CosmicExploration:open_critical_mission_ui()
    if IsAddonVisible("WKSHud") then
        self:open_mission_ui()
        yield("/callback WKSMission true 15 1")
    end
end

function CosmicExploration:open_provisional_mission_ui()
    if IsAddonVisible("WKSHud") then
        self:open_mission_ui()
        yield("/callback WKSMission true 15 1")
    end
end

function CosmicExploration:get_available_missions()
    local missions = {}
    local index = 2 -- Start at 2 because that's the first mission node
    repeat
        local mission = GetNodeText("WKSMission", 89, index, 8)
        if mission ~= "" then
            local id = self:get_mission_id_from_name(mission)
            local data = self.filtered_missions[id]
            table.insert(missions, data)
            index = index + 1
        end
    until (mission == "")

    return missions;
end

function CosmicExploration:is_mission_available(mission)
    local available_missions = self:get_available_missions()
    for _, data in ipairs(available_missions) do
        if string.find(data.name, mission, 1, true) then return true end
    end

    return false
end

function CosmicExploration:get_mission_id_from_name(name)
    for id, datum in pairs(self.filtered_missions) do
        if string.find(name, datum.name, 0, true) then return id end
    end

    return 0
end

-- Get's the first mission available
function CosmicExploration:get_first_available_mission_of_class(class)
    for id, datum in pairs(self.filtered_missions) do
        if datum.class == class and self:is_mission_available(datum.name) then
            return id
        end
    end

    return nil
end

function CosmicExploration:wait_to_start_mission()
    self.ferret:wait_for_addon("WKSRecipeNotebook")
end

function CosmicExploration:has_finished_mission()
    return self.ferret.character:has_condition(Conditions.Normal)
end

function CosmicExploration:refresh_missions(class)
    local id = self:get_first_available_mission_of_class(class)
    if id == nil then
        self.ferret.logger:error('No available missions of class ' .. class)
        return false
    end

    local mission_data = self.filtered_missions[id]
    self.ferret.logger:debug('Starting mission: ' .. mission_data.name)
    self.ferret.logger:debug('    mission id:' .. id)
    self.ferret.logger:debug('    mission class:' .. mission_data.class)
    self.ferret.logger:debug('    mission job:' .. mission_data.job)

    self:start_mission(id)
    self.ferret:wait(1)
    self.ferret.logger:debug('Waiting for mission to start')
    self:wait_to_start_mission()

    self.ferret.logger:debug('Abandoning mission')
    self:abandon_mission()
    self.ferret:wait(4)
    return true
end
