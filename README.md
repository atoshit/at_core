# AT Core

Framework core pour FiveM avec gestion optimisée des événements, callbacks, et système de classes.

## Caractéristiques

### Système d'événements
- Gestion optimisée des événements
- Support multi-handlers
- Communication client/serveur simplifiée
- Système anti-spam intégré

### Système de Callbacks
- Support synchrone (await) et asynchrone (trigger)
- Gestion des timeouts
- Protection contre les appels multiples
- Communication bidirectionnelle client/serveur

### Système de Classes
- Support de l'héritage
- Données privées
- Système d'export intégré
- Support TypeScript/LSP

### Utilitaires
- Gestion des convars
- Debug système configurable
- Support MySQL intégré
- Compatibilité client/serveur
- Système de métadonnées

## Configuration

### Convars disponibles
```
# Debug levels
setr at:debug 3 # 0: ERROR, 1: WARN, 2: INFO, 3: DEBUG

# Core settings
setr at:label "Atoshi Core"
setr at:gamebuild 3095
setr at:callbackTimeout 300000
```

## Installation

1. Assurez-vous d'avoir `oxmysql` installé
2. Placez la ressource dans votre dossier `resources`
3. Ajoutez `ensure at_core` à votre `server.cfg`

## Documentation API

### Events
```lua
-- Enregistrer un événement
core.events.Register('monEvent', function(data)
    print('Event reçu:', data)
end)

-- Déclencher un événement
core.events.Trigger('monEvent', 'données')

-- Broadcast (server only)
core.events.Broadcast('eventName', ...)

-- Communication client/serveur
core.events.ToClient(playerId, 'eventName', ...)
core.events.ToServer('eventName', ...)
```

### Callbacks
```lua
-- Server-side
core.callback.register('getData', function(source, ...)
    return { success = true, data = {...} }
end)

-- Client-side (Async)
core.callback.trigger('getData', 0, function(result)
    print(result.success)
end, 'param1', 'param2')

-- Client-side (Sync)
local result = core.callback.await('getData', 0, 'param1', 'param2')
```

### Classes
```lua
-- Définition d'une classe simple
local Animal = core.class('Animal')

function Animal:init()
    self.alive = true
end

-- Héritage
local Dog = core.class('Dog', Animal)

function Dog:init()
    Animal.init(self)
    self.species = 'dog'
end

-- Classe avec export
local Vehicle = core.class('Vehicle', nil, true)

-- Instance avec données privées
local instance = Vehicle:new({
    export = 'mainVehicle',
    private = {
        data = 'private'
    }
})
```

### Utils
```lua
-- Debug
core.utils.Debug('INFO', 'Message')

-- Convars
local value = core.utils.Convar('at:debug', 3, 'number')

-- Type checking
core.utils.IsType(value, 'string')

-- Resource check
core.utils.IsResourceStarted('resource_name')
```

## Exemples d'utilisation

### Système complet de joueur
```lua
-- Définition de la classe
local Player = core.class('Player', nil, true)

function Player:init()
    self.private.health = 100
    self.private.inventory = {}
end

-- Enregistrement des callbacks
core.callback.register('getPlayerData', function(source)
    local player = Player.__exports[source]
    return player and player:getData() or false
end)

-- Enregistrement des événements
core.events.Register('playerDamage', function(playerId, damage)
    local player = Player.__exports[playerId]
    if player then
        player:damage(damage)
    end
end)
```

## License
MIT License