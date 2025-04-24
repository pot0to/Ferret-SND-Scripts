require("Ferret/CosmicExploration/Data/MasterMissionList")
require("Ferret/Data/Jobs")
-- require("Ferret/Data/Jobs")
require("Ferret/CosmicExploration/WKSHud")
require("Ferret/CosmicExploration/WKSMission")
require("Ferret/CosmicExploration/WKSMissionInfomation")
require("Ferret/CosmicExploration/WKSRecipeNotebook")

CosmicExploration = {}

function CosmicExploration:new(ferret)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret

    self.job = Jobs.Unknown;
    self.mission_list = {}

    -- Addons
    self.main_hud = WKSHud:new(ferret)
    self.mission_hud = WKSMission:new(ferret)
    self.mission_information_hud = WKSMissionInfomation:new(ferret)
    self.recipe_notebook_hud = WKSRecipeNotebook:new(ferret)

    return o
end

function CosmicExploration:set_job(job)
    self.job = job
    self.mission_list = MasterMissionList:filter_by_job(job)
end
