local WKSToolCustomize = Addon:extend()
function WKSToolCustomize:new()
    WKSToolCustomize.super.new(self, 'WKSToolCustomize')
end

function WKSToolCustomize:get_exp(index)
    return ResearchProgressBar(
        Ferret:parse_number(GetNodeText(self.key, 8, index, 6) or '0'),
        Ferret:parse_number(GetNodeText(self.key, 8, index, 4) or '0'),
        Ferret:parse_number(GetNodeText(self.key, 8, index, 2) or '0')
    )
end

function WKSToolCustomize:get_exp_1()
    return self:get_exp(2)
end

function WKSToolCustomize:get_exp_2()
    return self:get_exp(3)
end

function WKSToolCustomize:get_exp_3()
    return self:get_exp(4)
end

function WKSToolCustomize:get_exp_4()
    return self:get_exp(5)
end

return WKSToolCustomize()
