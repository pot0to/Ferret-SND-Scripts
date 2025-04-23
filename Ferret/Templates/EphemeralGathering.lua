require("Ferret/Ferret")

EphemeralGathering = {
    item = null, -- Name of the item for GatherBuddy to teleport you to it
    start = null,
    startTime = -1,
    endTime = -1
}

function EphemeralGathering:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function EphemeralGathering:meticulousAction()
    if self.ferret.gathering:is_botanist() then
        self.ferret.character:action('Meticulous Woodsman')
    end

    if self.ferret.gathering:is_miner() then
        self.ferret.character:action('Meticulous Prospector')
    end
end

function EphemeralGathering:integrityAction()
    if self.ferret.gathering:has_eureka() then
        self.ferret.character:action('Wise to the World')
        return
    end

    if self.ferret.gathering:get_gp() < 300 then return end
    if self.ferret.gathering:is_botanist() then
        self.ferret.character:action('Ageless Words')
    end

    if self.ferret.gathering:is_miner() then
        self.ferret.character:action('Solid Reason')
    end
end

function EphemeralGathering:hasRevisit()
    return self.ferret.gathering:collectability() <= 0
end

function EphemeralGathering:revisit()
    self:prep()
    self:collect()
end

function EphemeralGathering:prep()
    if self.ferret.gathering:get_gp() >= 900 then
        if self.ferret.gathering:get_gp() >= 900 then
            self.ferret.character:action('Priming Touch')
        end

        self.ferret.character:action('Scrutiny')
        self:meticulousAction()

        self.ferret.character:action('Priming Touch')
        self.ferret.character:action('Scrutiny')
        self:meticulousAction()

        if self.ferret.gathering:collectability() >= 1000 then return end

        if self.ferret.gathering:collectability() >= 850 then
            self:meticulousAction()
            return
        end

        self.ferret.character:action('Scour')
        if self.ferret.gathering:collectability() < 1000 then
            self:meticulousAction()
        end
    else
        -- This should get us to at least 400 collectability
        self.ferret.character:action('Scour')
        if self.ferret.gathering:collectability() >= 250 or
            self.ferret.gathering:has_collectors_standard() then
            self:meticulousAction()
            if self.ferret.gathering:collectability() < 400 then
                self:meticulousAction()
            end

            return
        end

        self.ferret.character:action('Scour')
    end
end

function EphemeralGathering:collect()
    if self.ferret.gathering:collectability() >= 1000 then
        while self.ferret.gathering:integrity() > 0 and
            self.ferret.gathering:is_gathering_collectable() do
            if self:hasRevisit() then return self:revisit() end

            if self.ferret.gathering:integrity() <= 3 then
                self:integrityAction()
            end

            self.ferret.character:action('Collect')
        end
    else
        while self.ferret.gathering:integrity() > 0 and
            self.ferret.gathering:is_gathering_collectable() do
            if self:hasRevisit() then return self:revisit() end

            self.ferret.character:action('Collect')
        end
    end
end

ferret = Ferret:new("EphemeralGathering Template")
ferret:init()

ferret.ephemeralGathering = EphemeralGathering:new(ferret)

function Retainers:reset()
    self.ferret.character:wait_until_available()

    if self.ferret.ephemeralGathering.item ~= null then
        self.ferret.gatherBuddy:gather(self.ferret.ephemeralGathering.item)
    end

    self.ferret.mount:mount()

    self.ferret.pathfinding.index = 0
    local start = self.ferret.ephemeralGathering.start or
                      self.ferret.pathfinding.nodes[1]
    self.ferret.pathfinding:flyTo(start)
    self.ferret.pathfinding:wait_untilAtLocation(start)

    if not self.ferret.world:isTimeBetween(
        self.ferret.ephemeralGathering.startTime,
        self.ferret.ephemeralGathering.endTime) then
        self.ferret.world:wait_untilTime(
            self.ferret.ephemeralGathering.startTime)
    end
end

function Ferret:setup()
    self.logger:info("EphemeralGathering Template v1.0.1")
    if not self.character:exists() then
        self.logger:error("Unable to get local player")
        return false
    end

    self.retainers:reset()

    return true
end

function Ferret:loop()
    local node = self.pathfinding:next()
    if node == null then
        self.logger:error("No node found")
        self.run = false
        return
    end

    self:wait(2)
    self.mount:mount()
    self.pathfinding:flyTo(node)

    self.gathering:wait_for_nearby_node(30)
    self.character:wait_for_target(self.gathering:get_nearest_node(), 10)
    self.pathfinding:stop()

    local target = self.character:get_target_position()
    local floor = self.pathfinding:getLandableNodeNear(target)

    self.pathfinding:moveTo(floor)
    self.gathering:wait_to_start(10)
    if not self.gathering:is_gathering() then
        self.pathfinding:moveTo(target)
        self.gathering:wait_to_start(10)
    end

    self.pathfinding:stop()
    if not self.gathering:is_gathering() then return end

    self.logger:debug("Gathering")
    self.gathering:wait_to_start_collectable()
    self.logger:debug("Gathering Collectable")
    self.ephemeralGathering:prep()
    self.ephemeralGathering:collect()
    self.gathering:wait_to_stop_collectable()
    self:wait(1)

    if not self.ferret.world:isTimeBetween(
        self.ferret.ephemeralGathering.startTime,
        self.ferret.ephemeralGathering.endTime) then
        self.ferret.world:wait_untilTime(
            self.ferret.ephemeralGathering.startTime)
    end
end
