# Ferret

To be used with https://github.com/Jaksuhn/SomethingNeedDoing

**Currently you will need to be on the testing version of SND (12.0)**
https://goatcorp.github.io/faq/dalamud_troubleshooting.html#q-how-do-i-enable-plugin-test-builds

## Installation

- Download or clone the Github repository linked above.
  - If you've downloaded the zip, extract it somewhere on your computer.
- Get the path to the folder that contains your copy of Ferret, example:
  - My path to `Ferret.lua` is `C:/ferret/Ferret/Ferret.lua` So the path I will need is `C:/ferret`.
  - Please not if you use backslashes in your path, you will need to double them up. `C:\\ferret`
- Add this path to SND.
  - Open the main SND window (The window where you manage all your scripts and macros)
  - Click the `?` (Help) icon, this will bring up another window
  - Click the `Options` tab
  - Expand the `Lua` section
  - Add your ferret path to the required path list
- You can now use Ferret

## Reporting an issue

Please provide as much information as you can with your report, with the debug output from Ferret.
The best way to get your issue noticed and not lost among messages is by submitting an issue on Github: https://github.com/OhKannaDuh/Ferret/issues/new

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
ferret.mission_list = ferret:create_job_list_by_names({
    "A-1: High-grade Paper",
    "A-1: Specialized Materials I",
    "Heat-resistant Resin",
    "A-1: Starship Insulation",
})
-- or by ids
ferret.mission_list = ferret:create_job_list_by_names({
    23,
    35,
    17,
    24,
})
-- or a custom callback
ferret.mission_list = ferret:create_job_list(function(mission)
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
