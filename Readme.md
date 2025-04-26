# Ferret

To be used with https://github.com/Jaksuhn/SomethingNeedDoing

### Stellar Missions example:

```
local stellar_missions = require("Ferret/Templates/StellarMissions")

-- Plugins
require("Ferret/Plugins/ExtractMateria") -- Optional materia extaction plugin

require("Ferret/Plugins/Repair") -- Optional reaair plugin
stellar_missions.plugins.repair.threshold = 50 -- Gear degredation remaining to repair at (%)

require("Ferret/Plugins/CraftingConsumables") -- Optional consumables plugin
stellar_missions.plugins.crafting_consumables.food = "Rroneek Steak <HQ>" -- Add if you want to eat food
stellar_missions.plugins.crafting_consumables.medicine = "Commanding Craftsman's Draught <HQ>" -- Add if you want to use medicine

-- General config
Logger.show_debug = true
stellar_missions.language = 'en' -- optional 'en', 'de', 'fr', 'jp' default: 'en'

stellar_missions.job = Jobs.Carpenter
stellar_missions.mission_list = {
    "Gathering Miscellany",
}

stellar_missions:start()
```

### Plugins

```
local stellar_missions = require("Ferret/Templates/StellarMissions") --example
require("Ferret/Plugins/ExtractMateria") -- plugins are auto registered
require("Ferret/Plugins/Repair")
```
