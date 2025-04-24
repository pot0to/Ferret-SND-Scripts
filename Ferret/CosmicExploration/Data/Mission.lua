require("Ferret/CosmicExploration/Data/MissionReward")
require("Ferret/Data/Name")

Mission = {}

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
