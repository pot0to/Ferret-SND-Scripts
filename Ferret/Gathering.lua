require("Ferret/Data/Conditions")
require("Ferret/Data/Objects")
require("Ferret/Data/Jobs")

Gathering = {scanRange = 2048, nodeNames = {}}

function Gathering:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Gathering:is_gathering()
    return self.ferret.character:has_condition(Conditions.Gathering)
end

function Gathering:is_gathering_collectable()
    return IsAddonVisible("GatheringMasterpiece")
end

function Gathering:collectability()
    return tonumber(GetNodeText("GatheringMasterpiece", 140))
end

function Gathering:integrity()
    if self:is_gathering_collectable() then
        return tonumber(GetNodeText("GatheringMasterpiece", 61))
    end

    if self:is_gathering() then return tonumber(GetNodeText("Gathering", 33)) end

    return 0
end

function Gathering:has_eureka() return HasStatus("Eureka Moment") end

function Gathering:wait_to_start(max)
    self.ferret.logger:debug('Waiting to start gathering')

    self.ferret:wait_until(function() return self:is_gathering() end, 0.5, max)

    self.ferret.logger:debug('   > Done')
end

function Gathering:wait_to_stop(max)
    self.ferret.logger:debug('Waiting to stop gathering')

    self.ferret:wait_until(function() return not self:is_gathering() end, 0.5,
                           max)

    self.ferret:wait(0.5)
    self.ferret.logger:debug('   > Done')
end

function Gathering:wait_to_start_collectable(max)
    self.ferret.logger:debug('Waiting to start gathering collectable')

    self.ferret:wait_until(
        function() return self:is_gathering_collectable() end, 0.5, max)

    self.ferret.logger:debug('   > Done')
end

function Gathering:wait_to_stop_collectable(max)
    self.ferret.logger:debug('Waiting to stop gathering collectable')

    self.ferret:wait_until(function()
        return not self:is_gathering_collectable()
    end, 0.5, max)

    self.ferret.logger:debug('   > Done')
end

function Gathering:is_valid_node_name(name)
    for index, nodeName in pairs(self.nodeNames) do
        if nodeName == name then return true end
    end

    return false
end

function Gathering:get_nearby_nodes()
    local list = GetNearbyObjectNames(self.scanRange, Objects.GatheringPoint)
    local nodes = {}

    for i = 0, list.Count - 1 do table.insert(nodes, list[i]) end

    return nodes
end

function Gathering:get_nearest_node()
    local nodes = self:get_nearby_nodes()
    for index, node in ipairs(nodes) do
        if self:is_valid_node_name(node) then return node end
    end

    return null
end

function Gathering:has_nearby_nodes()
    return self.ferret:get_table_length(self:get_nearby_nodes()) > 0
end

function Gathering:wait_for_nearby_node(max)
    self.ferret.logger:debug('Waiting for nearby gathering nodes')
    self.ferret:wait_until(function() return self:has_nearby_nodes() end, 0.2,
                           max)

    self.ferret.logger:debug('   > Done')
end

function Gathering:has_collectors_standard()
    return HasStatus("Collector's High Standard") or
               HasStatus("Collector's Standard")
end

function Gathering:is_botanist() return GetClassJobId() == Jobs.Botanist end

function Gathering:is_miner() return GetClassJobId() == Jobs.Miner end

function Gathering:get_gp() return GetGp() end

function Gathering:get_max_gp() return GetMaxGp() end
