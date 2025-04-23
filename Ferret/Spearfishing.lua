Spearfishing = {last = '', caught = {}}

function Spearfishing:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Spearfishing:is_spearfishing() return IsAddonVisible("SpearFishing") end

function Spearfishing:wait_to_start(max)
    self.ferret.logger:debug('Waiting to start spearfishing')

    self.ferret:wait_until(function() return self:is_spearfishing() end, 0.5,
                           max)

    self.ferret.logger:debug('   > Done')
end

function Spearfishing:wait_to_stop(max)
    self.ferret.logger:debug('Waiting to stop spearfishing')

    self.ferret:wait_until(function() return not self:is_spearfishing() end,
                           0.5, max)

    self.ferret.logger:debug('   > Done')
end

function Spearfishing:get_wariness()
    return GetNodeWidth("SpearFishing", 34, 3) /
               GetNodeWidth("SpearFishing", 34, 0)
end

function Spearfishing:get_latest()
    return {
        name = GetNodeText("SpearFishing", 53, 3, 10),
        size = GetNodeText("SpearFishing", 53, 3, 7)
    }
    -- return GetNodeText("SpearFishing", 53, 3, 10) .. '-' .. GetNodeText("SpearFishing", 53, 3, 7)
end

function Spearfishing:get_list()
    return {
        {
            name = GetNodeText("SpearFishing", 53, 3, 10),
            size = GetNodeText("SpearFishing", 53, 3, 7)
        }, {
            name = GetNodeText("SpearFishing", 53, 4, 10),
            size = GetNodeText("SpearFishing", 53, 4, 7)
        }, {
            name = GetNodeText("SpearFishing", 53, 5, 10),
            size = GetNodeText("SpearFishing", 53, 3, 7)
        }
    }
end

function Spearfishing:get_last_index()
    for index, entry in ipairs(self:get_list()) do
        if (entry.name .. '-' .. entry.size) == self.last then
            return index
        end
    end

    return -1
end
