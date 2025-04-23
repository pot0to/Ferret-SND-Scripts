require("Ferret/Templates/EphemeralGathering")

ferret.name = 'Mythroot Aethersand'
ferret.ephemeralGathering.item = 'Volcanic Grass'
ferret.ephemeralGathering.start = createNode(260.9, 59.5, -603.5)
ferret.ephemeralGathering.startTime = 16
ferret.ephemeralGathering.endTime = 20

ferret.gathering.nodeNames = {
    'Ephemeral Lush Vegetation Patch'
}

ferret.pathfinding:add(createNode(297.9, 44.7, -595.1))
ferret.pathfinding:add(createNode(163.0, 39.1, -737.9))
ferret.pathfinding:add(createNode(352.8, 49.2, -784.7))
