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
    FERRET.cosmic_exploration.mission_hud:wait_until_ready()
    FERRET.cosmic_exploration.mission_hud:start_mission(self.id)
end

function Mission:wait_for_crafting_ui_or_normal()
    FERRET.logger:debug("Waiting for Crafting ui or normal status")
    FERRET:wait_until(function()
        return FERRET.cosmic_exploration.recipe_notebook_hud:is_ready() or
                   FERRET.character:has_condition(Conditions.Normal)
    end)
    FERRET:wait(1)
    FERRET.logger:debug("Finished waiting for Crafting ui or normal status")
end

function Mission:handle()
    FERRET.logger:debug("Starting mission: " .. self.name:get(FERRET.language))
    if not self.has_multiple_recipes then
        FERRET.logger:debug("Only 1 recipe")
        FERRET:repeat_until(function()
            if FERRET.cosmic_exploration.recipe_notebook_hud:is_ready() then
                FERRET.cosmic_exploration.recipe_notebook_hud:synthesize()
            end
        end, function()
            return FERRET.character:has_condition(Conditions.Normal)
        end)

    else
        FERRET.logger:debug("Multiple recipe")
        local started = false
        repeat
            FERRET.logger:debug("Repeat Start")
            for index, count in pairs(self.multi_craft_config) do
                FERRET.logger:debug("Starting outer loop")
                self:wait_for_crafting_ui_or_normal()
                if not started or
                    not FERRET.character:has_condition(Conditions.Normal) then
                    FERRET.cosmic_exploration.recipe_notebook_hud:wait_until_ready()
                    FERRET:wait(0.5)
                    FERRET.logger:debug("Setting craft index to: " .. index)
                    FERRET.cosmic_exploration.recipe_notebook_hud:set_index(
                        index)
                    for i = 1, count do
                        self:wait_for_crafting_ui_or_normal()
                        FERRET.logger:debug("Starting inner loop")
                        if not started or
                            not FERRET.character:has_condition(Conditions.Normal) then
                            started = true

                            FERRET.cosmic_exploration.recipe_notebook_hud:wait_until_ready()
                            -- FERRET:wait(1)
                            FERRET.logger:debug(
                                "Crafting: (" .. i .. "/" .. count .. ")")
                            FERRET.cosmic_exploration.recipe_notebook_hud:set_hq()
                            FERRET:wait(0.5)
                            FERRET.cosmic_exploration.recipe_notebook_hud:synthesize()
                            FERRET:wait(0.5)
                        end

                        FERRET.logger:debug("Inner loop done")
                    end
                end
                FERRET.logger:debug("Outer loop done")
            end
            FERRET.logger:debug("Repeat end")
        until FERRET.character:has_condition(Conditions.Normal)
    end

    FERRET.logger:debug("Mission complete")
end

function Mission:report()
    FERRET.cosmic_exploration.main_hud:open_mission_menu()
    FERRET.cosmic_exploration.mission_information_hud:report()
end

function Mission:abandon()
    FERRET.cosmic_exploration.main_hud:open_mission_menu()
    FERRET.cosmic_exploration.mission_information_hud:abandon()
end

function Mission:to_string()
    return string.format(
               "Mission [\n    ID: %s,\n    Name: %s,\n    Job: %s,\n    Class: %s\n]",
               self.id, self.name:get(FERRET.language), self.job, self.class);
end
