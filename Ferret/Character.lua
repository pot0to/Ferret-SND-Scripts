require("Ferret/Data/Conditions")
require("Ferret/Node")

Character = {}
function Character:new(ferret)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.ferret = ferret
    return o
end

function Character:exists() return not IsLocalPlayerNull() end

function Character:position()
    return create_node(GetPlayerRawXPos(), GetPlayerRawYPos(),
                       GetPlayerRawZPos())
end

function Character:has_condition(condition)
    return GetCharacterCondition(condition)
end

function Character:action(action)
    self.ferret.logger:debug("Action: " .. action)
    yield('/ac \"' .. action .. '\"')

    self.ferret:wait(1)
    while (self:has_condition(Conditions.Gathering42)) do
        self.ferret:wait(0.2)
    end

    self.ferret:wait(0.5)
end

function Character:target(name)
    if not name then return end

    yield('/target ' .. name)
end

function Character:has_target(name) return GetTargetName() ~= "" end

function Character:wait_for_target(name, max)
    self.ferret.logger:debug('Waiting for target')
    local max = max or 0

    self.ferret:repeat_until(function() self:target(name) end,
                             function() return self:has_target() end, 0.1, max)

    self.ferret.logger:debug('   > Done')
end

function Character:get_target_position()
    self.ferret.logger:debug('Getting target position')
    return create_node(GetTargetRawXPos(), GetTargetRawYPos(),
                       GetTargetRawZPos())
end

function Character:get_distance_to_target()
    self.ferret.logger:debug('Getting distance to target')
    if not self:has_target() then
        self.ferret.logger:debug('   > No target')
        return 0
    end

    return GetDistanceToPoint(GetTargetRawXPos(), GetTargetRawYPos(),
                              GetTargetRawZPos())
end

function Character:interact()
    self.ferret.logger:debug('Interacting')
    yield('/interact')
end

function Character:is_moving() return IsMoving() end

function Character:is_available() return IsPlayerAvailable() end

function Character:wait_until_available(max)
    self.ferret.logger:debug('Waiting until character is available')
    local max = max or 0

    self.ferret:waitUntil(function() return self:is_available() end, 0.2, max)

    self.ferret.logger:debug('   > Done')
end

function Character:wait_until_not_available(max)
    self.ferret.logger:debug('Waiting until character is not aviailable')
    local max = max or 0

    self.ferret:wait_until(function() return not self:is_available() end, 0.2,
                           max)

    self.ferret.logger:debug('   > Done')
end

function Character:teleport(destination)
    yield('/tp ' .. destination)
    self:wait_until_not_available(10)
    self:wait_until_available()
    self.ferret:wait(2)
end

-- This requires Yes already - bothers - MaterializeDialog set to true
function Character:extract_materia()
    self.ferret.logger:debug('Checking if materia needs to be extracted')
    if not CanExtractMateria() then
        self.ferret.logger:debug('Materia does not need to be extracted')
        return
    end

    self.ferret.logger:debug('Extracting Materia')
    yield('/ac "Materia Extraction"')
    yield('/waitaddon Materialize')
    while CanExtractMateria(100) do
        yield('/callback Materialize true 2')
        yield('/wait 0.5')
        while GetCharacterCondition(39) do yield('/wait 0.5') end
    end

    yield('/wait 1')
    yield('/callback Materialize true -1')
    yield('/e Extracted all materia')

    self.ferret.logger:debug('   > Done')
end

function Character:repair()
    self.ferret.logger:debug('Checking if gear needs repairing')
    if not NeedsRepair(100) then
        self.ferret.logger:debug('Gear does not need repairing')
        return
    end

    self.ferret.logger:debug('Repairing')
    while not IsAddonVisible('Repair') do
        yield('/ac repair')
        self.ferret:wait(0.5)
    end

    yield('/callback Repair true 0')
    self.ferret:wait(0.1)

    if IsAddonVisible('SelectYesno') then
        yield('/callback SelectYesno true 0')
        self.ferret:wait(0.1)
    end

    while GetCharacterCondition(39) do self.ferret:wait(1) end

    self.ferret:wait(1)
    yield('/callback Repair true -1')

    self.ferret.logger:debug('   > Done')
end

-- Rduction script from king pendragon
function Character:aetherial_reduction()
    -- Open Desynth menu if PurifyItemSelector is not visible and character is not mounted (condition 4)
    while (not IsAddonVisible("PurifyItemSelector")) and
        not GetCharacterCondition(4) do
        yield('/ac "Aetherial Reduction"')
        yield("/wait 0.5")
    end

    -- Main loop: Continue until PurifyItemSelector is visible and a specific node is not visible
    while (not GetCharacterCondition(39)) and
        IsAddonVisible("PurifyItemSelector") and
        not IsNodeVisible("PurifyItemSelector", 1, 7) do
        -- Check if the PurifyResult is visible
        if IsAddonVisible("PurifyResult") then
            yield("/callback PurifyResult true 0")
            yield("/wait 4")

            -- Check if the PurifyItemSelector is visible but PurifyResult is not
        elseif not IsAddonVisible("PurifyResult") and
            IsAddonVisible("PurifyItemSelector") then
            yield("/callback PurifyItemSelector true 12 0")
            yield("/wait 4")

            -- Handle PurifyAutoDialog if it appears
        elseif IsAddonVisible("PurifyAutoDialog") and
            GetNodeText("PurifyAutoDialog", 2, 2) == "Exit" then
            yield("/callback PurifyAutoDialog true 0")
        end
    end
    yield("/wait 2")
    -- Handle PurifyAutoDialog if it appears
    while IsAddonVisible("PurifyAutoDialog") and
        GetNodeText("PurifyAutoDialog", 2, 2) == "Exit" do
        yield("/callback PurifyAutoDialog true 0")
    end
    yield("/wait 2")
    -- Handle PurifyItemSelector when a specific node is visible
    while IsAddonVisible("PurifyItemSelector") and
        not IsAddonVisible("PurifyAutoDialog") and
        IsNodeVisible("PurifyItemSelector", 1, 7) do
        yield("/callback PurifyItemSelector true -1")
    end
end
