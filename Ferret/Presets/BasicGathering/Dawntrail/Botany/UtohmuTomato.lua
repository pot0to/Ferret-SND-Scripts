require("Ferret/Templates/BasicGathering")
require("Ferret/Data/GatheringNodes")

ferret.name = 'Ut\'ohmu Tomato'
ferret.basic_gathering.item = 'Ut\'ohmu Tomato'
ferret.debug = true

ferret.gathering.nodeNames = {GatheringNodes.LushVegatationPatch}

ferret.pathfinding:add(createNode(-180.6, 11.8, -354.1))
ferret.pathfinding:add(createNode(-26.3, 13.2, -468.6))
ferret.pathfinding:add(createNode(-164.5, 30.7, -520.5))

function Pathfinding:getLandableNodeNear(node) return node end
