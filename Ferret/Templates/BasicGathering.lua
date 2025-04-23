require("Ferret/Ferret")

BasicGathering = {
    item = null -- Name of the item for GatherBuddy to teleport you to it
}

function BasicGathering:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

ferret = Ferret:new("BasicGathering Template")
ferret:init()

ferret.basic_gathering = BasicGathering:new(ferret)

function Retainers:reset()
    self.ferret.character:wait_until_available()

    if self.ferret.basic_gathering.item ~= null then
        self.ferret.gatherBuddy:gather(self.ferret.basic_gathering.item)
    end

    self.ferret.mount:mount()

    self.ferret.pathfinding.index = 0
    local start = self.ferret.pathfinding.nodes[1]
    self.ferret.pathfinding:fly_to(start)
    self.ferret.pathfinding:wait_until_at_location(start)
end

function Ferret:setup()
    self.logger:info("BasicGathering Template v1.0.1")
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

    self.mount:mount()
    self.pathfinding:fly_to(node)

    self.gathering:wait_for_nearby_node(30)

    repeat
        self.character:target(self.gathering:get_nearest_node())
        if self.character:has_target() then
            self.pathfinding:stop()

            local target = self.character:get_target_position()
            local floor = self.pathfinding:get_landable_node_near(target)

            self.pathfinding:move_to(floor)
            self.gathering:wait_to_start(10)
            if not self.gathering:is_gathering() then
                self.pathfinding:move_to(target)
                self.gathering:wait_to_start(10)
            end

            self.pathfinding:stop()
            if not self.gathering:is_gathering() then return end

            self.logger:debug("Gathering")
            self.gathering:wait_to_stop()
            self:wait(1)

            self.character:extract_materia()
            self.character:repair()
            self.food:eat()
            self.retainers:check()
        end
    until not self.gathering:has_nearby_nodes()
end
