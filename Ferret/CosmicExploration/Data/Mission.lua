require('Ferret/CosmicExploration/Data/MissionReward')
require('Ferret/Data/Name')

Mission = Object:extend()

function Mission:new(id, name, job, class)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.id = id
    o.name = name
    o.job = job
    o.class = class

    o.time_limit = 0
    o.silver_threshold = 0
    o.gold_threshold = 0
    o.has_secondary_job = false
    o.secondary_job = nil
    o.cosmocredit = 0
    o.lunarcredit = 0
    o.exp_reward = {}
    o.has_multiple_recipes = false
    o.multi_craft_config = {}

    return o
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
    Ferret.cosmic_exploration.mission_hud:wait_until_ready()
    Ferret.cosmic_exploration.mission_hud:start_mission(self.id)
end

function Mission:is_complete()
    local current_score, gold_star_requirement =
        ToDoList:get_stellar_mission_scores()
    if current_score and gold_star_requirement then
        return current_score >= gold_star_requirement
    end

    return false
end

function Mission:wait_for_crafting_ui_or_mission_complete()
    Logger:debug('Waiting for Crafting ui or mission complete')
    Ferret:wait_until(function()
        return Ferret.cosmic_exploration.recipe_notebook_hud:is_ready() or
                   self:is_complete()
    end)
    Ferret:wait(1)
    Logger:debug('Finished waiting for Crafting ui or Mission complete')
end

function Mission:handle()
    Logger:debug('Starting mission: ' .. self.name:get(Ferret.language))
    if not self.has_multiple_recipes then
        Logger:debug('Only 1 recipe')
        Ferret:repeat_until(function()
            if Ferret.cosmic_exploration.recipe_notebook_hud:is_ready() then
                Ferret.cosmic_exploration.recipe_notebook_hud:synthesize()
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
                    Ferret.cosmic_exploration.recipe_notebook_hud:wait_until_ready()
                    Ferret:wait(0.5)
                    Logger:debug('Setting craft index to: ' .. index)
                    Ferret.cosmic_exploration.recipe_notebook_hud:set_index(
                        index)
                    for i = 1, count do
                        self:wait_for_crafting_ui_or_mission_complete()
                        if not self:is_complete() then
                            Ferret.cosmic_exploration.recipe_notebook_hud:wait_until_ready()
                            -- Ferret:wait(1)
                            Logger:debug(
                                'Crafting: (' .. i .. '/' .. count .. ')')
                            Ferret.cosmic_exploration.recipe_notebook_hud:set_hq()
                            Ferret:wait(0.5)
                            Ferret.cosmic_exploration.recipe_notebook_hud:synthesize()
                            Ferret:wait(0.5)
                        end

                    end
                end
            end
        until self:is_complete()
    end

    Logger:debug('Mission complete')
end

function Mission:report()
    Ferret.cosmic_exploration.main_hud:open_mission_menu()
    Ferret.cosmic_exploration.mission_information_hud:report()
end

function Mission:abandon()
    Ferret.cosmic_exploration.main_hud:open_mission_menu()
    Ferret.cosmic_exploration.mission_information_hud:abandon()
end

function Mission:to_string()
    return string.format(
        'Mission [\n    ID: %s,\n    Name: %s,\n    Job: %s,\n    Class: %s\n]',
        self.id, self.name:get(Ferret.language), self.job, self.class);
end
