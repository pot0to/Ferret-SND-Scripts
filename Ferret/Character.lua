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

function Character:position()
    return createNode(GetPlayerRawXPos(), GetPlayerRawYPos(), GetPlayerRawZPos())
end

function Character:hasCondition(condition)
    return GetCharacterCondition(condition)
end

function Character:action(action)
    self.ferret.logger:debug("Action: " .. action)
    yield('/ac \"' .. action .. '\"')

    self.ferret:wait(1)
    while (self:hasCondition(Conditions.Gathering42)) do
        self.ferret:wait(0.2)
    end

    self.ferret:wait(0.5)
end

function Character:target(name)
    if not name then
        return
    end

    yield('/target ' .. name)
end

function Character:hasTarget(name)
    return GetTargetName() ~= ""
end

function Character:waitForTarget(name, max)
    self.ferret.logger:debug('Waiting for target')
    local max = max or 0

    self.ferret:repeatUntil(
        function() self:target(name) end,
        function () return self:hasTarget() end,
        0.1,
        max
    )

    self.ferret.logger:debug('   > Done')
end

function Character:getTargetPosition()
    self.ferret.logger:debug('Getting target position')
    return createNode(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos())
end

function Character:getDistanceToTarget()
    self.ferret.logger:debug('Getting distance to target')
    if not self:hasTarget() then
        self.ferret.logger:debug('   > No target')
        return 0
    end

    return GetDistanceToPoint(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos())
end

function Character:interact()
    self.ferret.logger:debug('Interacting')
    yield('/interact')
end

function Character:isMoving()
    return IsMoving()
end

function Character:isAvialable()
    return IsPlayerAvailable()
end

function Character:waitUntilAvailable(max)
    self.ferret.logger:debug('Waiting until character is available')
    local max = max or 0

    self.ferret:waitUntil(
        function () return self:isAvialable() end,
        0.2,
        max
    )

    self.ferret.logger:debug('   > Done')
end

function Character:waitUntilNotAvailable(max)
    self.ferret.logger:debug('Waiting until character is not aviailable')
    local max = max or 0

    self.ferret:waitUntil(
        function () return not self:isAvialable() end,
        0.2,
        max
    )

    self.ferret.logger:debug('   > Done')
end

function Character:teleport(destination)
    yield('/tp ' .. destination)
    self:waitUntilNotAvailable(10)
    self:waitUntilAvailable()
    self.ferret:wait(2)
end

-- This requires Yes already - bothers - MaterializeDialog set to true
function Character:extractMateria()
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
        while GetCharacterCondition(39) do
            yield('/wait 0.5')
        end
    end

    yield('/wait 1')
    yield('/callback Materialize true -1')
    yield('/e Extracted all materia')

    self.ferret.logger:debug('   > Done')
end

function Character:repair()
    self.ferret.logger:debug('Checking if gear needs repairing')
    if not NeedsRepair(50) then
        self.ferret.logger:debug('Gear does not need repairing')
        return
    end

    self.ferret.logger:debug('Repairing')
    while not IsAddonVisible('Repair') do
        yield('/ac repair')
        wait(0.5)
    end

    yield('/callback Repair true 0')
    wait(0.1)

    if IsAddonVisible('SelectYesno') then
        yield('/callback SelectYesno true 0')
        wait(0.1)
    end

    while GetCharacterCondition(39) do
        wait(1)
    end

    wait(1)
    yield('/callback Repair true -1')

    self.ferret.logger:debug('   > Done')
end

-- Rduction script from king pendragon
function Character:aetherialReduction()
   -- Open Desynth menu if PurifyItemSelector is not visible and character is not mounted (condition 4)
   while (not IsAddonVisible("PurifyItemSelector")) and not GetCharacterCondition(4) do
    yield('/ac "Aetherial Reduction"')
    yield("/wait 0.5")
  end

  -- Main loop: Continue until PurifyItemSelector is visible and a specific node is not visible
  while (not GetCharacterCondition(39)) and IsAddonVisible("PurifyItemSelector") and not IsNodeVisible("PurifyItemSelector", 1, 7) do
    -- Check if the PurifyResult is visible
    if IsAddonVisible("PurifyResult") then
      yield("/callback PurifyResult true 0")
      yield("/wait 4")
    
    -- Check if the PurifyItemSelector is visible but PurifyResult is not
    elseif not IsAddonVisible("PurifyResult") and IsAddonVisible("PurifyItemSelector") then
      yield("/callback PurifyItemSelector true 12 0")
      yield("/wait 4")


    -- Handle PurifyAutoDialog if it appears
    elseif IsAddonVisible("PurifyAutoDialog") and GetNodeText("PurifyAutoDialog", 2, 2) == "Exit" then
      yield("/callback PurifyAutoDialog true 0")
    end
  end
  yield("/wait 2")
  -- Handle PurifyAutoDialog if it appears
  while IsAddonVisible("PurifyAutoDialog") and GetNodeText("PurifyAutoDialog", 2, 2) == "Exit" do
    yield("/callback PurifyAutoDialog true 0")
  end
  yield("/wait 2")
  -- Handle PurifyItemSelector when a specific node is visible
  while IsAddonVisible("PurifyItemSelector") and not IsAddonVisible("PurifyAutoDialog") and IsNodeVisible("PurifyItemSelector", 1, 7) do
    yield("/callback PurifyItemSelector true -1")
  end
end