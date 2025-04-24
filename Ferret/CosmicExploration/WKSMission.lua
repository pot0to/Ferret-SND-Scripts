WKSMission = {}

function WKSMission:new(ferret)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function WKSMission:is_visible() return IsAddonVisible("WKSMission") end

function WKSMission:wait_until_visible() self.ferret:wait_for_addon("WKSMission") end

function WKSMission:start_mission(id)
    self:wait_until_visible()
    yield("/callback WKSMission true 13 " .. id)
    repeat
        if IsAddonReady("SelectYesno") then
            yield("/callback SelectYesno true 0")
        end
        self.ferret:wait(0.1)
    until not IsAddonReady("WKSMission")
end

function WKSMission:open()
    self.ferret.logger:debug('Opening mission ui')
    self.ferret.cosmic_exploration.main_hud:open_mission_menu()
    self:wait_until_visible()
    self.ferret:wait(1)
end

function WKSMission:open_basic_missions()
    self:open()
    self.ferret.logger:debug('Opening basic mission ui')
    yield("/callback WKSMission true 15 0")
end

function WKSMission:open_critical_missions()
    self:open()
    self.ferret.logger:debug('Opening critical mission ui')
    yield("/callback WKSMission true 15 1")
end

function WKSMission:open_provisional_missions()
    self:open()
    self.ferret.logger:debug('Opening provisional mission ui')
    yield("/callback WKSMission true 15 2")
end

function WKSMission:get_mission_name_by_index(index)
    return GetNodeText("WKSMission", 89, index, 8)
end

function WKSMission:get_available_missions()
    self.ferret.logger:debug("Getting missions from mission list:")

    local missions = MissionList:new()
    local index = 2 -- Start at 2 because that's the first mission node

    repeat
        local mission = self:get_mission_name_by_index(index):gsub(" ", "")
        if mission ~= "" then
            local found_mission =
                self.ferret.cosmic_exploration.mission_list:find_by_name(mission)
            if found_mission ~= nil then
                -- self.ferret.logger:debug(mission .. ": " .. found_mission:to_string())
                missions.missions[found_mission.id] = found_mission
            else
                self.ferret.logger:error(mission .. ": Not found")
            end
            index = index + 1
        end
    until (mission == "")

    return missions
end
