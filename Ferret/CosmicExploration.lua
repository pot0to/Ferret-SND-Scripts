CosmicExploration = {
    mission_ids = {
        -- CRP Class D
        [1] = "Multi-purpose Fiberboard",
        [2] = "Fieldwork Fuel",
        [3] = "Gathering Miscellany",
        [4] = "Essential Research Materials",
        [5] = "Charcoal Longevity Testing",
        [6] = "General-purpose Bedding",
        -- CRP Class C
        [7] = "Thin Fiberboard",
        [8] = "Carpentry Provisions",
        [9] = "Worker's Weaving Tools",
        [10] = "Data Entry Paper",
        [11] = "Interior Insulation Materials",
        [12] = "Cosmoliner Supplies",
        [13] = "New Material Earrings",
        -- CRP Class B
        [14] = "???",
        [15] = "???",
        [16] = "High-quality Insulation Materials",
        [17] = "Heat-resistant Resin",
        [18] = "Long-term Storage Paper",
        [19] = "Habitation Module Chairs",
        [20] = "Test Material Gathering Tools",
        [21] = "???",
        -- CRP Class A
        [22] = "???",
        [23] = "A-1: High-grade Paper",
        [24] = "A-1: Starship Insulation",
        [25] = "A-1: High Burn Charcoal",
        [26] = "A-1: Lunar Flora Test Processing",
        [27] = "A-1: Power Transmission Shafts I",
        [28] = "A-1: Specialized Materials I",
        [29] = "???",
        [30] = "???",
        [31] = "???",
        [32] = "A-2: Rest Facility Materials",
        [33] = "A-2: Aquatic Resource Research Tanks"
    }
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

function CosmicExploration:start_craft()
    if IsAddonVisible("WKSRecipeNotebook") then
        yield("/callback WKSRecipeNotebook true 6")
    end
end

function CosmicExploration:get_craftable_item_count() end

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
        if mission ~= "" then table.insert(missions, mission) end
        index = index + 1
    until (mission == "")

    return missions;
end

function CosmicExploration:is_mission_available(mission)
    local available_missions = self:get_available_missions()
    for _, available_mission in ipairs(available_missions) do
        if string.find(available_mission, mission) then return true end
    end

    return false
end

function CosmicExploration:get_mission_id_from_name(name)
    for id, mission in pairs(self.mission_ids) do
        if mission == name then return id end
    end

    return 1
end

function CosmicExploration:start_mission(mission)
    self:start_mission_by_id(self:get_mission_id_from_name(mission))
end

function CosmicExploration:start_mission_by_id(id)
    self:open_basic_mission_ui()
    self.ferret:wait_for_addon("WKSMission")
    self.ferret.logger:debug("/callback WKSMission true 13 " .. id)
    yield("/callback WKSMission true 13 " .. id)
end

function CosmicExploration:report_mission()
    if not IsAddonVisible("WKSMissionInfomation") then
        yield("/callback WKSHud true 11")
        self.ferret:wait_for_addon("WKSMissionInfomation")
    end

    yield("/callback WKSMissionInfomation true 11")
end

function CosmicExploration:abandon_mission()
    if not IsAddonVisible("WKSMissionInfomation") then
        yield("/callback WKSHud true 11")
        self.ferret:wait_for_addon("WKSMissionInfomation")
    end

    yield("/callback WKSMissionInfomation true 12")
end

-- Get's the first mission available
function CosmicExploration:get_first_available_mission()
    for id, name in pairs(self.mission_ids) do
        if self:is_mission_available(name) then return id end
    end

    return nil
end

function CosmicExploration:refresh_missions()
    local id = self:get_first_available_mission()
    if id == nil then return false end

    self:start_mission_by_id(id)
    self.ferret:wait(1)
    self.ferret.logger:debug('Waiting for mission to start')
    self.ferret.chat:wait_for_message('The stellar mission “')
    self.ferret.chat:send_marker()

    self:abandon_mission()
    self.ferret:wait(4)
    return true
end
