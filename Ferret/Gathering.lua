require("Ferret/Data/Conditions")
require("Ferret/Data/Objects")
require("Ferret/Data/Jobs")

Gathering = {
    scanRange = 2048,
    nodeNames = {}
}

function Gathering:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Gathering:isGathering()
    return self.ferret.character:hasCondition(Conditions.Gathering)
end

function Gathering:isGatheringCollectable()
    return IsAddonVisible("GatheringMasterpiece")
end

function Gathering:collectability()
    return tonumber(GetNodeText("GatheringMasterpiece", 140))
end

function Gathering:integrity()
    if self:isGatheringCollectable() then
        return tonumber(GetNodeText("GatheringMasterpiece", 61))
    end

    if self:isGathering() then
        return tonumber(GetNodeText("Gathering", 33))
    end

    return 0
end

function Gathering:hasEureka()
    return HasStatus("Eureka Moment")
end

function Gathering:waitToStart(max)
    self.ferret.logger:debug('Waiting to start gathering')

    self.ferret:waitUntil(
        function() return self:isGathering() end,
        0.5,
        max
    )

    self.ferret.logger:debug('   > Done')
end

function Gathering:waitToStop(max)
    self.ferret.logger:debug('Waiting to stop gathering')

    self.ferret:waitUntil(
        function() return not self:isGathering() end,
        0.5,
        max
    )

    self.ferret:wait(0.5)
    self.ferret.logger:debug('   > Done')
end

function Gathering:waitToStartColletable(max)
    self.ferret.logger:debug('Waiting to start gathering collectable')

    self.ferret:waitUntil(
        function() return self:isGatheringCollectable() end,
        0.5,
        max
    )

    self.ferret.logger:debug('   > Done')
end

function Gathering:waitToStopColletable(max)
    self.ferret.logger:debug('Waiting to stop gathering collectable')

    self.ferret:waitUntil(
        function() return not self:isGatheringCollectable() end,
        0.5,
        max
    )

    self.ferret.logger:debug('   > Done')
end

function Gathering:isValidNodeName(name)
    for index, nodeName in pairs(self.nodeNames) do
        if nodeName == name then
            return true
        end
    end

    return false
end

function Gathering:getNearbyNodes()
    local list = GetNearbyObjectNames(self.scanRange, Objects.GatheringPoint)
    local nodes = {}
    
    for i = 0, list.Count - 1 do
        table.insert(nodes, list[i])
    end

    return nodes
end

function Gathering:getNearestNode()
    local nodes = self:getNearbyNodes()
    for index, node in ipairs(nodes) do
        if self:isValidNodeName(node) then
            return node
        end
    end

    return null
end

function Gathering:hasNearbyNodes()
    return self.ferret:getTableLength(self:getNearbyNodes()) > 0
end

function Gathering:waitForNearbyNode(max)
    self.ferret.logger:debug('Waiting for nearby gathering nodes')
    self.ferret:waitUntil(
        function() return self:hasNearbyNodes() end,
        0.2,
        max
    )

    self.ferret.logger:debug('   > Done')
end

function Gathering:hasCollectorsStandard()
    return HasStatus("Collector's High Standard") or HasStatus("Collector's Standard")
end

function Gathering:isBotanist()
    return GetClassJobId() == Jobs.Botanist
end

function Gathering:isMiner()
    return GetClassJobId() == Jobs.Miner
end

function Gathering:getGp()
    return GetGp()
end

function Gathering:getMaxGp()
    return GetMaxGp()
end
