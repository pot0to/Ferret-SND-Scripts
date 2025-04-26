Object = require('external/classic')

-- Data enums and objects
require('Ferret/Data/Translatable')
require('Ferret/Data/Conditions')
require('Ferret/Data/Hooks')
require('Ferret/Data/Jobs')
require('Ferret/Data/Name')
require('Ferret/Data/Objects')
require('Ferret/Data/Status')
require('Ferret/Data/Version')

-- Base plugin
require('Ferret/Plugins/Plugin')

-- Addons
require('Ferret/Addons/Addons')

-- Static objects
Character = require('Ferret/Character')
Logger = require('Ferret/Logger')
Timer = require('Ferret/Timer')

-- Modules
require('Ferret/CosmicExploration/Library')
