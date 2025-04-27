--------------------------------------------------------------------------------
--   DESCRIPTION: Stellar Crafting Relic automator
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

require('Ferret/Ferret')
require('Ferret/CosmicExploration/CosmicExploration')

StellarCraftingRelic = Ferret:extend()
function StellarCraftingRelic:new()
    StellarCraftingRelic.super.new(self, 'Stellar Crafting Relic')

    self.job = nil
    self.template_version = Version(0, 1, 1)

    self.cosmic_exploration = CosmicExploration()

    self.wait_timers = {
        pre_open_mission_list = 0,
        post_open_mission_list = 0,
        post_mission_start = 0,
        post_mission_abandon = 0,
    }

    self.blacklist = MissionList()

    self:init()
end

function StellarCraftingRelic:slow_mode()
    self.wait_timers = {
        pre_open_mission_list = 1,
        post_open_mission_list = 1,
        post_mission_start = 1,
        post_mission_abandon = 1,
    }

    Mission.wait_timers.pre_synthesize = 1
    Mission.wait_timers.post_synthesize = 1
end

function StellarCraftingRelic:setup()
    Logger:info(self.name .. ': ' .. self.template_version:to_string())

    if self.job == nil then
        Logger:error('Job not set')
        Logger:info('Please set `stellar_crafting_relic.job = Jobs.Carpenter` etc.')
        return false
    end

    self.cosmic_exploration:set_job(self.job)

    PauseYesAlready()

    return true
end

function StellarCraftingRelic:loop()
    Logger:debug('Starting loop')

    WKSHud:wait_until_ready()

    Ferret:wait(self.wait_timers.pre_open_mission_list)
    WKSMission:open_basic_missions()
    Ferret:wait(self.wait_timers.post_open_mission_list)

    WKSHud:close_cosmic_research()
    Ferret:wait(1)
    WKSHud:open_cosmic_research()
    WKSToolCustomize:wait_until_ready()
    Ferret:wait(1)

    local is_ready_to_upgrade = true
    local progress = {
        WKSToolCustomize:get_exp_1(),
        WKSToolCustomize:get_exp_2(),
        WKSToolCustomize:get_exp_3(),
        WKSToolCustomize:get_exp_4(),
    }

    for i, exp in ipairs(progress) do
        if Ferret:get_table_length(exp) > 0 then
            if exp.current < exp.required then
                is_ready_to_upgrade = false
            end
        end
    end

    if is_ready_to_upgrade then
        Ferret:wait(5)
        yield('/target Researchingway')
        yield('/interact')
        Ferret:wait(1)
        Ferret:repeat_until(function()
            yield('/click Talk Click')
        end, function()
            return not IsAddonVisible('Talk')
        end)
        Ferret:wait(1)
        yield('/callback SelectString true 0')
        Ferret:wait(1)
        yield('/callback SelectIconString true ' .. Ferret.job - 8) -- 5 is list index
        Ferret:wait(1)
        yield('/callback SelectYesno true 0')
        Ferret:repeat_until(function()
            yield('/click Talk Click')
        end, function()
            return not IsAddonVisible('Talk')
        end)
        Ferret:wait(5)

        return
    end

    local mission = WKSMission:get_best_available_mission(self.blacklist)
    if mission == nil then
        Logger:error('Failed to get mission')
        self:stop()
        return
    end

    Logger:info('Mission: ' .. mission:to_string())

    mission:start()

    Ferret:wait(self.wait_timers.post_mission_start)
    WKSRecipeNotebook:wait_until_ready()
    self:emit(Hooks.PRE_CRAFT)

    WKSHud:open_mission_menu()

    mission:handle()

    self:repeat_until(function()
        mission:report()
    end, function()
        return not mission:is_complete()
    end)
end

local ferret = StellarCraftingRelic()
Ferret = ferret

return ferret
