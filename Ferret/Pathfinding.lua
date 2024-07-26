require("Ferret/Node")

Pathfinding = {
    nodes = {},
    index = 0
}

function Pathfinding:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Pathfinding:add(node)
    self.ferret.logger:debug("Adding node to pathfinshing: " .. nodeToString(node))
    table.insert(self.nodes, node)
end

function Pathfinding:count()
    self.ferret.logger:debug("Counting nodes")
    local count = self.ferret:getTableLength(self.nodes)
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
        self:add(createNode(0, 0, 0))
    end

    self.index = self.index + 1
    if self.index > count then
        self.ferret.logger:debug("Reseting to start of list")
        self.index = 1
    end

    local node = self.nodes[self.index]
    self.ferret.logger:debug('Node: (' .. self.index .. '/' .. count .. ')')
    self.ferret.logger:debug(' > ' .. nodeToString(node))

    return node
end

function Pathfinding:distance()
    self.ferret.logger:debug("Getting distance to current node")
    local node = self:current()

    return GetDistanceToPoint(node.x, node.y, node.z)
end

function Pathfinding:flyTo(node)
    self.ferret.logger:debug("Flying to node: " .. nodeToString(node))
    yield('/vnavmesh flyto ' .. node.x .. ' ' .. node.y .. ' ' .. node.z)
end

function Pathfinding:walkTo(node)
    self.ferret.logger:debug("Walking to node: " .. nodeToString(node))
    if self:distance() >= 500 then
        self.ferret.character:action('sprint')
    end

    yield('/vnavmesh moveto ' .. node.x .. ' ' .. node.y .. ' ' .. node.z)
end

function Pathfinding:moveTo(node)
    if self.ferret.mount:isFlying() then
        return self:flyTo(node)
    end

    self:walkTo(node)
end

function Pathfinding:flyToFlag()
    self.ferret.logger:debug("Flying to flag")
    yield('/vnavmesh flyflag')
end

function Pathfinding:walkToFlag()
    self.ferret.logger:debug("Walking to flag")
    if self:distance() >= 500 then
        self.ferret.character:action('sprint')
    end

    yield('/vnavmesh moveflag')
end

function Pathfinding:moveToFlag()
    if self.ferret.mount:isFlying() then
        return self:flyToFlag(node)
    end

    self:walkToFlag(node)
end

function Pathfinding:stop()
    self.ferret.logger:debug("Stopping pathfinding and movement")
    yield('/vnavmesh stop')
end

function Pathfinding:waitToStart(max)
    self.ferret.logger:debug("Waiting to start moving")
    local max = max or 10

    self.ferret:waitUntil(
        function() return self.ferret.character:isMoving() end,
        0.5,
        max
    )

    self.ferret.logger:debug("   > Done")
end

function Pathfinding:waitToStop(max)
    self.ferret.logger:debug("Waiting to stop moving")
    local max = max or 60

    self.ferret:waitUntil(
        function() return not self.ferret.character:isMoving() end,
        0.5,
        max
    )

    self.ferret.logger:debug("   > Done")
end

function Pathfinding:isNodeSimilar(a, b, threshold)
    local threshold = threshold or 1

    return (math.abs(a.x - b.x) <= threshold) and (math.abs(a.y - b.y) <= threshold) and (math.abs(a.z - b.z) <= threshold)
end

function Pathfinding:waitUntilAtLocation(location, max)
    self.ferret.logger:debug("Waiting to be at location: " .. nodeToString(location))
    local max = max or 60

    self.ferret:waitUntil(
        function() return self:isNodeSimilar(self.ferret.character:position(), location) end,
        0.5,
        max
    )

    self.ferret.logger:debug("   > Done")
end

function Pathfinding:waitUntilClose(distance, max)
    self.ferret.logger:debug("Waiting to be at close to target")
    local max = max or 60

    self.ferret:waitUntil(
        function() return self.ferret.character:getDistanceToTarget() <= distance end,
        0.1,
        max
    )

    self.ferret.logger:debug("   > Done")
end

function Pathfinding:getLandableNodeNear(node)
    local fx = nil
    local fy = nil
    local fz = nil
    local i = 0

    self.ferret.logger:debug("Finding landable node near: " .. nodeToString(node))
    while not fx or not fy or not fz do
        fx = QueryMeshPointOnFloorX(node.x, node.y, node.z, false, i)
        fy = QueryMeshPointOnFloorY(node.x, node.y, node.z, false, i)
        fz = QueryMeshPointOnFloorZ(node.x, node.y, node.z, false, i)
        i = i + 1
    end

    local floor = createNode(fx, fy, fz)
    self.ferret.logger:debug("   > Iterations: " .. i)
    self.ferret.logger:debug("   > Node: " .. nodeToString(floor))

    return floor
end
