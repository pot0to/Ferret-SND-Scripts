require("Ferret/Templates/BasicGathering")

ferret.name = 'White Gold Ore'
ferret.basic_gathering.item = 'White Gold Ore'
ferret.debug = true

ferret.gathering.nodeNames = {'Mineral Deposit'}

ferret.pathfinding:add(createNode(-202.7, 29.8, 30.5))
ferret.pathfinding:add(createNode(-329.9, 29.3, -18.8))
ferret.pathfinding:add(createNode(-350.2, 21.5, 174.2))
