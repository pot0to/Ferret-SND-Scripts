# Ferret

To be used with https://github.com/Jaksuhn/SomethingNeedDoing

### Stellar Missions example:

```
local ferret = require("Ferret/Templates/StellarMissions")

-- Plugins
require("Ferret/Plugins/ExtractMateria") -- Optional materia extaction plugin

require("Ferret/Plugins/Repair") -- Optional reaair plugin
ferret.plugins.repair.threshold = 50 -- Gear degredation remaining to repair at (%)

require("Ferret/Plugins/CraftingConsumables") -- Optional consumables plugin
ferret.plugins.crafting_consumables.food = "Rroneek Steak <HQ>" -- Add if you want to eat food
ferret.plugins.crafting_consumables.medicine = "Commanding Craftsman's Draught <HQ>" -- Add if you want to use medicine

-- General config
Logger.show_debug = true
Ferret.language = 'en' -- optional 'en', 'de', 'fr', 'jp' default: 'en'

ferret.job = Jobs.Carpenter
-- Define mission list by names
ferret.mission_list = stellar_missions:create_job_list_by_names({
    "A-1: High-grade Paper",
    "A-1: Specialized Materials I",
    "Heat-resistant Resin",
    "A-1: Starship Insulation",
})
-- or by ids
ferret.mission_list = stellar_missions:create_job_list_by_names({
    23,
    35,
    17,
    24,
})
-- or a custom callback
ferret.mission_list = stellar_missions:create_job_list(function(mission)
    return mission.class == "D" or mission.class == "C"
end)

-- ferret:slow_mode() -- optional

ferret:start()
```

### Stellar Crafting Relic example:

```
local ferret = require("Ferret/Templates/StellarCraftingRelic")

ferret.job = Jobs.Weaver
ferret.blacklist = MasterMissionList:filter_by_job(ferret.job):filter(function(mission)
    return mission.class == 'A'
end)

ferret:start()
```

### Plugins

```
local stellar_missions = require("Ferret/Templates/StellarMissions") --example
require("Ferret/Plugins/ExtractMateria") -- plugins are auto registered
require("Ferret/Plugins/Repair")
```
