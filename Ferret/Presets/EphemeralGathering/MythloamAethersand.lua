require("Ferret/Templates/EphemeralGathering")

ferret.name = 'Mythloam Aethersand'
ferret.ephemeralGathering.item = 'Brightwind Ore'
ferret.ephemeralGathering.start = createNode(-547.4, 8.2, -518.1)
ferret.ephemeralGathering.startTime = 0
ferret.ephemeralGathering.endTime = 4

ferret.gathering.nodeNames = {
    'Ephemeral Rocky Outcrop'
}

ferret.pathfinding:add(createNode(-555.6, -7.7, -648.1))
ferret.pathfinding:add(createNode(-687.6, -4.0, -473.1))
ferret.pathfinding:add(createNode(-403.3, -5.0, -439.0))
