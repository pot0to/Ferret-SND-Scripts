--------------------------------------------------------------------------------
--   DESCRIPTION: CosmicExploration Mission
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

Mission = Object:extend()
Mission.wait_timers = {
    pre_synthesize = 0,
    post_synthesize = 0,
}

function Mission:new(id, name, job, class)
    self.id = id
    self.name = name
    self.job = job
    self.class = class

    self.time_limit = 0
    self.silver_threshold = 0
    self.gold_threshold = 0
    self.has_secondary_job = false
    self.secondary_job = nil
    self.cosmocredit = 0
    self.lunarcredit = 0
    self.exp_reward = {}
    self.has_multiple_recipes = false
    self.multi_craft_config = {}
end

function Mission:with_de_name(name)
    self.name = self.name:with_de(name)
    return self
end

function Mission:with_fr_name(name)
    self.name = self.name:with_fr(name)
    return self
end

function Mission:with_jp_name(name)
    self.name = self.name:with_jp(name)
    return self
end

function Mission:with_time_limit(time_limit)
    self.time_limit = time_limit
    return self
end

function Mission:with_silver_threshold(silver_threshold)
    self.silver_threshold = silver_threshold
    return self
end

function Mission:with_gold_threshold(gold_threshold)
    self.gold_threshold = gold_threshold
    return self
end

function Mission:with_has_secondary_job()
    self.has_secondary_job = true
    return self
end

function Mission:with_secondary_job(job)
    self.secondary_job = job
    return self:with_has_secondary_job()
end

function Mission:with_cosmocredit(cosmocredit)
    self.cosmocredit = cosmocredit
    return self
end

function Mission:with_lunarcredit(lunarcredit)
    self.lunarcredit = lunarcredit
    return self
end

function Mission:with_exp_reward(reward)
    table.insert(self.exp_reward, reward)
    return self
end

function Mission:with_multiple_recipes()
    self.has_multiple_recipes = true
    return self
end

function Mission:with_multi_craft_config(config)
    self.multi_craft_config = config
    return self
end

function Mission:start()
    WKSMission:wait_until_ready()
    WKSMission:start_mission(self.id)
end

function Mission:is_complete()
    local current_score, gold_star_requirement = ToDoList:get_stellar_mission_scores()
    if current_score and gold_star_requirement then
        return current_score >= gold_star_requirement
    end

    return false
end

function Mission:wait_for_crafting_ui_or_mission_complete()
    Logger:debug('Waiting for Crafting ui or mission complete')
    Ferret:wait_until(function()
        return WKSRecipeNotebook:is_ready() or self:is_complete()
    end)
    Ferret:wait(1)
    Logger:debug('Finished waiting for Crafting ui or Mission complete')
end

function Mission:handle()
    Logger:debug('Starting mission: ' .. self.name:get())

    if not self.has_multiple_recipes then
        Logger:debug('Only 1 recipe')
        Ferret:repeat_until(function()
            if WKSRecipeNotebook:is_ready() then
                Ferret:wait(Mission.wait_timers.pre_synthesize)
                WKSRecipeNotebook:synthesize()
                Ferret:wait(Mission.wait_timers.post_synthesize)
            end
        end, function()
            return self:is_complete()
        end)
    else
        Logger:debug('Multiple recipe')
        repeat
            Logger:debug('Repeat Start')
            for index, count in pairs(self.multi_craft_config) do
                self:wait_for_crafting_ui_or_mission_complete()
                if not self:is_complete() then
                    WKSRecipeNotebook:wait_until_ready()
                    Ferret:wait(0.5)
                    Logger:debug('Setting craft index to: ' .. index)
                    WKSRecipeNotebook:set_index(index)
                    for i = 1, count do
                        self:wait_for_crafting_ui_or_mission_complete()
                        if not self:is_complete() then
                            WKSRecipeNotebook:wait_until_ready()
                            -- Ferret:wait(1)
                            Logger:debug('Crafting: (' .. i .. '/' .. count .. ')')
                            WKSRecipeNotebook:set_hq()
                            Ferret:wait(Mission.wait_timers.pre_synthesize)
                            WKSRecipeNotebook:synthesize()
                            Ferret:wait(Mission.wait_timers.post_synthesize)
                        end
                    end
                end
            end
        until self:is_complete()
    end

    Logger:debug('Mission complete')
end

function Mission:report()
    WKSHud:open_mission_menu()
    WKSMissionInfomation:report()
end

function Mission:abandon()
    WKSHud:open_mission_menu()
    WKSMissionInfomation:abandon()
end

function Mission:to_string()
    return string.format(
        'Mission [\n    ID: %s,\n    Name: %s,\n    Job: %s,\n    Class: %s\n]',
        self.id,
        self.name:get(),
        self.job,
        self.class
    )
end
