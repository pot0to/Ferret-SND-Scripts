# Ferret

To be used with https://github.com/Jaksuhn/SomethingNeedDoing


### Stellar Missions example: 
```
local stellar_missions = require("Ferret/Templates/StellarMissions")

stellar_missions.logger.show_debug = true
stellar_missions.language = 'en' -- optional 'en', 'de', 'fr', 'jp' default: 'en'
stellar_missions.food_to_eat = "Ceviche <hq>" -- leave blank if you don't want to eat food
stellar_missions.medicine_to_drink = "" -- leave blank if you don't want to drink medication 

stellar_missions.job = Jobs.Carpenter
stellar_missions.mission_list = {
    "Gathering Miscellany",
}

stellar_missions.missions_to_medicate_on = { -- Chooses which missions to medicate on, will only medicate on things in this list
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
