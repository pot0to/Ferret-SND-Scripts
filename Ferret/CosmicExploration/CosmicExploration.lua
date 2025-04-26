require('Ferret/CosmicExploration/Data/MasterMissionList')
require('Ferret/CosmicExploration/WKSHud')
require('Ferret/CosmicExploration/WKSMission')
require('Ferret/CosmicExploration/WKSMissionInfomation')
require('Ferret/CosmicExploration/WKSRecipeNotebook')

CosmicExploration = Object:extend()
function CosmicExploration:new(ferret)
    self.job = Jobs.Unknown;
    self.mission_list = {}

    -- Addons
    self.main_hud = WKSHud:new(ferret)
    self.mission_hud = WKSMission:new(ferret)
    self.mission_information_hud = WKSMissionInfomation:new(ferret)
    self.recipe_notebook_hud = WKSRecipeNotebook:new(ferret)
end

function CosmicExploration:set_job(job)
    self.job = job
    self.mission_list = MasterMissionList:filter_by_job(job)
end
