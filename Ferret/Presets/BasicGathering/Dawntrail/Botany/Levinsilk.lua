require("Ferret/Templates/BasicGathering")
require("Ferret/Data/GatheringNodes")

ferret.name = 'Levinsilk'
ferret.basic_gathering.item = 'Levinsilk'
ferret.debug = true

ferret.gathering.nodeNames = {GatheringNodes.LushVegatationPatch}

ferret.pathfinding:add(createNode(-387.9, 37.3, -83.8))

ferret.pathfinding:add(createNode(-601.4, 49.6, -170.8))
ferret.pathfinding:add(createNode(-497.1, 49.0, -328.6))

function Pathfinding:getLandableNodeNear(node) return node end
