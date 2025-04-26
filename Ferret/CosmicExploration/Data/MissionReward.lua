--------------------------------------------------------------------------------
--   DESCRIPTION: CosmicExploration Mission Reward object
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

MissionReward = Object:extend()
function MissionReward:new(job, tier, amount)
    self.job = job
    self.tier = tier
    self.amount = amount
end
