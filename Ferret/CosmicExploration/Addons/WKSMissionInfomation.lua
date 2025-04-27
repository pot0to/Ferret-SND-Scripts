local WKSMissionInfomation = Addon:extend()
function WKSMissionInfomation:new()
    WKSMissionInfomation.super.new(self, 'WKSMissionInfomation')
end

function WKSMissionInfomation:report()
    self:wait_until_ready()
    Character:wait_until_done_crafting()
    Ferret:callback(self, true, 11)
    repeat
        Ferret:wait(0.1)
    until not self:is_visible()
end

function WKSMissionInfomation:abandon()
    repeat
        if self:is_ready() then
            Ferret:callback(self, true, 12)
        end
        Ferret:wait(0.1)
    until SelectYesno:is_visible()
    repeat
        if SelectYesno:is_ready() then
            SelectYesno:yes()
        end
        Ferret:wait(0.1)
    until not WKSMissionInfomation:is_visible()
end

return WKSMissionInfomation()
