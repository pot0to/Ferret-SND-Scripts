--------------------------------------------------------------------------------
--   DESCRIPTION: Plugin that consumes food and medicine before crafting
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
-- OPTIONS:
--- food: [string] The in game name of the food you'd like to consume
--- food_threshold: [integer] The number of minutes remaining on the well fed buff before
---                 you consume more
--- medicine: [string] The in game name of the medicine you'd like to consume
--- medicine_threshold: [integer] The number of minutes remaining on the medicated buff
---                     before you consume more
--- should_eat: [function(context) -> bool] Add custom logic to food
--- should_drink: [function(context) -> bool] Add custum logic to medicine
--------------------------------------------------------------------------------

CraftingConsumables = Plugin:extend()
function CraftingConsumables:new()
    CraftingConsumables.super.new(self, 'Crafting Consumables', 'crafting_consumables')
    self.food = ''
    self.food_threshold = 5
    self.medicine = ''
    self.medicine_threshold = 5

    self.wait_time = 5

    self.should_eat = function()
        return true
    end

    self.should_drink = function()
        return true
    end
end

function CraftingConsumables:init()
    Ferret:subscribe(Hooks.PRE_CRAFT, function(context)
        -- Food
        if self:should_eat() and (self.food ~= nil and self.food ~= '') then
            local remaining = self:get_remaining_food_time()
            if remaining <= self.food_threshold then
                yield('/item ' .. self.food)
                Ferret:wait_until(function()
                    return self:get_remaining_food_time() > remaining
                end)
                Ferret:wait(self.wait_time)
            end
        end

        if self:should_drink() and (self.medicine ~= nil and self.medicine ~= '') then
            local remaining = self:get_remaining_medicine_time()
            if remaining <= self.medicine_threshold then
                yield('/item ' .. self.medicine)
                Ferret:wait_until(function()
                    return self:get_remaining_medicine_time() > remaining
                end)
            end
        end
    end)
end

function CraftingConsumables:get_remaining_food_time()
    return math.floor(GetStatusTimeRemaining(Status.WellFed) / 60)
end
function CraftingConsumables:get_remaining_medicine_time()
    return math.floor(GetStatusTimeRemaining(Status.Medicated) / 60)
end

Ferret:add_plugin(CraftingConsumables())
