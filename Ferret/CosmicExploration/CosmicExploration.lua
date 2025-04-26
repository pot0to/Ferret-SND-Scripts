CosmicExploration = Object:extend()
function CosmicExploration:new()
    self.job = Jobs.Unknown
    self.mission_list = {}
end

function CosmicExploration:set_job(job)
    self.job = job
    self.mission_list = MasterMissionList:filter_by_job(job)
end
