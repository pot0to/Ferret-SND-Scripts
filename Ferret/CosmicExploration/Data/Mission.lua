require("Ferret/CosmicExploration/Data/MissionReward")
require("Ferret/Data/Name")

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
    ferret.cosmic_exploration.mission_hud:wait_until_visible()
    ferret:wait(2)
    ferret.cosmic_exploration.mission_hud:start_mission(self.id)
end

function Mission:wait_for_crafting_ui_or_normal()
    ferret.logger:debug("Waiting for Crafting ui or normal status")
    ferret:wait_until(function() return ferret.cosmic_exploration.recipe_notebook_hud:is_visible() or ferret.character:has_condition(Conditions.Normal) end)
    ferret:wait(1)
    ferret.logger:debug("Finished waiting for Crafting ui or normal status")
end

function Mission:handle()
    ferret.logger:debug("Starting mission: " .. self.name:get('en'))
    if not self.has_multiple_recipes then
        ferret.logger:debug("Only 1 recipe")
        ferret:repeat_until(
            function() 
                if ferret.cosmic_exploration.recipe_notebook_hud:is_visible() then
                    ferret.cosmic_exploration.recipe_notebook_hud:synthesize()
                end
            end,
            function() return ferret.character:has_condition(Conditions.Normal) end
        )

    else
        ferret.logger:debug("Multiple recipe")
        local started = false
        repeat
            ferret.logger:debug("Repeat Start")
            for index, count in pairs(self.multi_craft_config) do
                ferret.logger:debug("Starting outer loop")
                self:wait_for_crafting_ui_or_normal()
                if not started or not ferret.character:has_condition(Conditions.Normal) then
                    ferret.cosmic_exploration.recipe_notebook_hud:wait_until_visible()
                    ferret:wait(1)
                    ferret.logger:debug("Setting craft index to: " .. index)
                    ferret.cosmic_exploration.recipe_notebook_hud:set_index(index)
                    for i = 1, count do
                        self:wait_for_crafting_ui_or_normal()
                        ferret.logger:debug("Starting inner loop")
                        if not started or not ferret.character:has_condition(Conditions.Normal) then
                            started = true

                            ferret.cosmic_exploration.recipe_notebook_hud:wait_until_visible()
                            ferret:wait(1)
                            ferret.logger:debug("Crafting: (" .. i .. "/" .. count .. ")")
                            ferret.cosmic_exploration.recipe_notebook_hud:set_hq()
                            ferret:wait(1)
                            ferret.cosmic_exploration.recipe_notebook_hud:synthesize()
                            ferret:wait(1)
                        end
                        
                        ferret.logger:debug("Inner loop done")
                    end
                end
                ferret.logger:debug("Outer loop done")
            end
            ferret.logger:debug("Repeat end")
        until ferret.character:has_condition(Conditions.Normal)
    end

    ferret.logger:debug("Mission compelte")
end

function Mission:report()
    ferret.cosmic_exploration.main_hud:open_mission_menu()
    ferret:wait(2)
    ferret.cosmic_exploration.mission_information_hud:report()
end

function Mission:abandon()
    ferret.cosmic_exploration.main_hud:open_mission_menu()
    ferret:wait(2)
    ferret.cosmic_exploration.mission_information_hud:abandon()
end

function Mission:to_string()
    return string.format(
        "Mission [\n    ID: %s,\n    Name: %s,\n    Job: %s,\n    Class: %s\n]",
        self.id,
        self.name:get('en'),
        self.job,
        self.class
    );
end