require("Ferret/Node")

Pathfinding = {nodes = {}, index = 0}

function Pathfinding:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Pathfinding:add(node)
    self.ferret.logger:debug("Adding node to pathfinshing: " ..
                                 node_to_string(node))
    table.insert(self.nodes, node)
end

function Pathfinding:count()
    self.ferret.logger:debug("Counting nodes")
    local count = self.ferret:get_table_length(self.nodes)
    self.ferret.logger:debug("   count: " .. count)

    return count
end

function Pathfinding:get(index)
    self.ferret.logger:debug("Getting node at index: " .. index)
    return self.nodes[index]
end

function Pathfinding:current()
    self.ferret.logger:debug("Getting current node")
    return self:get(self.index)
end

function Pathfinding:next()
    self.ferret.logger:debug("Getting next node")
    local count = self:count()
    if count <= 0 then
        self.ferret.logger:debug("No nodes found, adding zeroed node")
        self:add(create_node(0, 0, 0))
    end

    self.index = self.index + 1
    if self.index > count then
        self.ferret.logger:debug("Reseting to start of list")
        self.index = 1
    end

    local node = self.nodes[self.index]
    self.ferret.logger:debug('Node: (' .. self.index .. '/' .. count .. ')')
    self.ferret.logger:debug(' > ' .. node_to_string(node))

    return node
end

function Pathfinding:distance()
    self.ferret.logger:debug("Getting distance to current node")
    local node = self:current()

    return GetDistanceToPoint(node.x, node.y, node.z)
end

function Pathfinding:fly_to(node)
    self.ferret.logger:debug("Flying to node: " .. node_to_string(node))
    yield('/vnavmesh flyto ' .. node.x .. ' ' .. node.y .. ' ' .. node.z)
end

function Pathfinding:walkTo(node)
    self.ferret.logger:debug("Walking to node: " .. node_to_string(node))
    if self:distance() >= 500 then self.ferret.character:action('sprint') end

    yield('/vnavmesh moveto ' .. node.x .. ' ' .. node.y .. ' ' .. node.z)
end

function Pathfinding:move_to(node)
    if self.ferret.mount:isFlying() then return self:fly_to(node) end

    self:walkTo(node)
end

function Pathfinding:fly_to_flag()
    self.ferret.logger:debug("Flying to flag")
    yield('/vnavmesh flyflag')
end

function Pathfinding:walk_to_flag()
    self.ferret.logger:debug("Walking to flag")
    if self:distance() >= 500 then self.ferret.character:action('sprint') end

    yield('/vnavmesh moveflag')
end

function Pathfinding:move_to_flag()
    if self.ferret.mount:isFlying() then return self:fly_to_flag(node) end

    self:walk_to_flag(node)
end

function Pathfinding:stop()
    self.ferret.logger:debug("Stopping pathfinding and movement")
    yield('/vnavmesh stop')
end

function Pathfinding:wait_to_start(max)
    self.ferret.logger:debug("Waiting to start moving")
    local max = max or 10

    self.ferret:wait_until(function()
        return self.ferret.character:is_moving()
    end, 0.5, max)

    self.ferret.logger:debug("   > Done")
end

function Pathfinding:wait_to_stop(max)
    self.ferret.logger:debug("Waiting to stop moving")
    local max = max or 60

    self.ferret:wait_until(function()
        return not self.ferret.character:is_moving()
    end, 0.5, max)

    self.ferret.logger:debug("   > Done")
end

function Pathfinding:is_node_similar(a, b, threshold)
    local threshold = threshold or 1

    return (math.abs(a.x - b.x) <= threshold) and
               (math.abs(a.y - b.y) <= threshold) and
               (math.abs(a.z - b.z) <= threshold)
end

function Pathfinding:wait_until_at_location(location, max)
    self.ferret.logger:debug("Waiting to be at location: " ..
                                 node_to_string(location))
    local max = max or 60

    self.ferret:wait_until(function()
        return self:is_node_similar(self.ferret.character:position(), location)
    end, 0.5, max)

    self.ferret.logger:debug("   > Done")
end

function Pathfinding:wait_until_close(distance, max)
    self.ferret.logger:debug("Waiting to be at close to target")
    local max = max or 60

    self.ferret:wait_until(function()
        return self.ferret.character:get_distance_to_target() <= distance
    end, 0.1, max)

    self.ferret.logger:debug("   > Done")
end

function Pathfinding:get_landable_node_near(node)
    local fx = nil
    local fy = nil
    local fz = nil
    local i = 0

    self.ferret.logger:debug("Finding landable node near: " ..
                                 node_to_string(node))
    while not fx or not fy or not fz do
        fx = QueryMeshPointOnFloorX(node.x, node.y, node.z, false, i)
        fy = QueryMeshPointOnFloorY(node.x, node.y, node.z, false, i)
        fz = QueryMeshPointOnFloorZ(node.x, node.y, node.z, false, i)
        i = i + 1
    end

    local floor = create_node(fx, fy, fz)
    self.ferret.logger:debug("   > Iterations: " .. i)
    self.ferret.logger:debug("   > Node: " .. node_to_string(floor))

    return floor
end
