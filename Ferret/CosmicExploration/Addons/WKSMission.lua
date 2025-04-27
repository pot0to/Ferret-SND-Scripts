local WKSMission = Addon:extend()
function WKSMission:new()
    WKSMission.super.new(self, 'WKSMission')
end

function WKSMission:start_mission(id)
    self:wait_until_ready()

    repeat
        if IsAddonReady('WKSMission') then
            yield('/callback WKSMission true 13 ' .. id)
        end
        Ferret:wait(0.1)
    until IsAddonVisible('SelectYesno')

    repeat
        if IsAddonReady('SelectYesno') then
            yield('/callback SelectYesno true 0')
        end
        Ferret:wait(0.1)
    until not IsAddonReady('WKSMission')
end

function WKSMission:open()
    Logger:debug('Opening mission ui')
    WKSHud:open_mission_menu()
    self:wait_until_ready()
    Ferret:wait(1)
end

function WKSMission:open_basic_missions()
    self:open()
    Logger:debug('Opening basic mission ui')
    yield('/callback WKSMission true 15 0')
end

function WKSMission:open_critical_missions()
    self:open()
    Logger:debug('Opening critical mission ui')
    yield('/callback WKSMission true 15 1')
end

function WKSMission:open_provisional_missions()
    self:open()
    Logger:debug('Opening provisional mission ui')
    yield('/callback WKSMission true 15 2')
end

function WKSMission:get_mission_name_by_index(index)
    return GetNodeText('WKSMission', 89, index, 8)
end

function WKSMission:get_available_missions()
    Logger:debug('Getting missions from mission list:')

    local missions = MissionList()
    local index = 2 -- Start at 2 because that's the first mission node

    repeat
        local mission = self:get_mission_name_by_index(index):gsub(' ', '')
        if mission ~= '' then
            local found_mission = MasterMissionList:filter_by_job(Ferret.job):find_by_name(mission)
            if found_mission ~= nil then
                -- Logger:debug(mission .. ": " .. found_mission:to_string())
                -- missions.missions[found_mission.id] = found_mission
                table.insert(missions.missions, found_mission)
            else
                Logger:error(mission .. ': Not found')
            end
            index = index + 1
        end
    until (mission == '') or index >= 24

    return missions
end

function WKSMission:get_best_available_mission(blacklist)
    -- Function to select the best mission based on urgency-weighted progress
    local function select_best_mission(progress, rewards)
        local urgencies = {}

        -- Step 1: Calculate urgency for each bar
        for i, bar in ipairs(progress) do
            local current, max = bar.current, bar.required
            if max and max > 0 then
                urgencies[i] = 1 - (current / max)
            else
                urgencies[i] = 0
            end
        end

        -- Step 2: Score each mission
        local best_score = -math.huge
        local best_index = -1

        for i, mission in pairs(rewards) do
            local score = 0
            for bar_index, progress in pairs(mission) do
                if urgencies[bar_index] then
                    score = score + urgencies[bar_index] * progress
                end
            end

            if score > best_score then
                best_score = score
                best_index = i
            end
        end

        return best_index
    end

    WKSHud:close_cosmic_research()
    Ferret:wait(1)

    WKSHud:open_cosmic_research()
    WKSHud:open_mission_menu()
    Ferret:wait(1)

    local progress = {
        WKSToolCustomize:get_exp_1(),
        WKSToolCustomize:get_exp_2(),
        WKSToolCustomize:get_exp_3(),
        WKSToolCustomize:get_exp_4(),
    }

    local rewards = {}
    local missions = WKSMission:get_available_missions()
    for index, mission in pairs(missions.missions) do
        Logger:info('Checking mission: ' .. mission.name:get())
        if not blacklist:has_id(mission.id) then
            Logger:info('Mission \'' .. mission.name:get() .. '\' is not blacklsited.')
            local r = {}
            for _, reward in pairs(mission.exp_reward) do
                r[reward.tier] = reward.amount
            end

            rewards[index] = r
        else
            Logger:info('Mission \'' .. mission.name:get() .. '\' is blacklsited.')
        end
    end

    return missions.missions[select_best_mission(progress, rewards)]
end

return WKSMission()
