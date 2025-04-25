# Ferret

To be used with https://github.com/Jaksuhn/SomethingNeedDoing

### Stellar Missions example:

```
local stellar_missions = require("Ferret/Templates/StellarMissions")
require("Ferret/Plugins/ExtractMateria")
require("Ferret/Plugins/Repair")

stellar_missions.logger.show_debug = true
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
