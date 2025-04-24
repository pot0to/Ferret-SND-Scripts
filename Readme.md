# Ferret

To be used with https://github.com/Jaksuhn/SomethingNeedDoing


### Stellar Missions example: 
```
require("Ferret/Templates/StellarMissions")

ferret.name = 'Stellar Missions'
ferret.logger.show_debug = false
ferret.language = 'en' -- optional 'en', 'de', 'fr', 'jp' default: 'en'

ferret.stellar_missions.job = Jobs.Carpenter
ferret.stellar_missions.mission_list = {
    "Gathering Miscellany",
}


ferret:start()
```