CraftingConsumables = Plugin:extend()

function CraftingConsumables:new()
    CraftingConsumables.super:new("Crafting Consumables", "crafting_consumables")
    self.food = nil
    self.food_threshold = 5
    self.medicine = nil
    self.medicine_threshold = 5

    self.wait_timers = {post_food = 5, post_medicine = 5}

    self.should_eat = function() return true end
    self.should_drink = function() return true end
end

function CraftingConsumables:init(ferret)
    self.ferret = ferret

    ferret:subscribe(Hooks.PRE_CRAFT, function()
        -- Food
        if self:should_eat() and self.food ~= nil then
            local remaining = self:get_remaining_food_time()
            if remaining <= self.food_threshold then
                yield('/item ' .. self.food)
                ferret:wait_until(function()
                    return self:get_remaining_food_time() > remaining
                end)
            end
        end

        if self:should_drink() and self.medicine ~= nil then
            local remaining = self:get_remaining_medicine_time()
            if remaining <= self.medicine_threshold then
                yield('/item ' .. self.medicine)
                ferret:wait_until(function()
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

FERRET:add_plugin(CraftingConsumables())
