# AT Core

Framework core pour FiveM avec gestion optimisée des événements, callbacks, système de classes et cache.

## Table des matières
- [Caractéristiques](#caractéristiques)
- [Installation](#installation)
- [Configuration](#configuration)
- [Documentation API](#documentation-api)
  - [Cache](#cache)
  - [Events](#events)
  - [Callbacks](#callbacks)
  - [Classes](#classes)
  - [Utils](#utils)
- [Bonnes pratiques](#bonnes-pratiques)
- [Exemples](#exemples)
- [Sécurité](#sécurité)
- [Performance](#performance)
- [Contribution](#contribution)
- [License](#license)

## Caractéristiques

### Système de Cache
- Gestion optimisée des données en mémoire
- Système d'observateurs pour les changements
- Mise à jour automatique des données joueur
- Protection contre les valeurs nil

### Système d'événements
- Gestion optimisée des événements
- Support multi-handlers avec priorités
- Communication client/serveur simplifiée
- Système anti-spam intégré
- Métriques de performance

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

## Installation

1. Prérequis
```bash
# Dépendances requises
- oxmysql
- FiveM build 3095 ou supérieur
```

2. Installation
```bash
# Cloner le repository
git clone https://github.com/atoshit/at_core

# Copier dans le dossier resources
cp -r at_core /path/to/resources/

# Configurer server.cfg
ensure oxmysql
ensure at_core
```

3. Configuration base de données
```sql
-- Exécuter le script SQL
mysql -u root -p < resources/at_core/at_core.sql
```

## Configuration

### Convars essentiels
```bash
# Debug levels (0: ERROR, 1: WARN, 2: INFO, 3: DEBUG)
setr at:debug 3

# Core settings
setr at:label "Atoshi Core"
setr at:gamebuild 3095
setr at:callbackTimeout 300000

# Gameplay settings
setr at:npcDrops false
setr at:playerHealthRegen false
setr at:dispatch false
setr at:scenario false

# Population settings
setr at:npcPopulation 3
setr at:vehiclePopulation 3
setr at:parkedVehiclePopulation 3
```

## Documentation API

### Cache
```lua
-- Définir une valeur
cache.set('key', value)

-- Récupérer une valeur
local value = cache.get('key')

-- Observer les changements
cache.onChange('key', function(newValue, oldValue)
    print(string.format('Value changed from %s to %s', oldValue, newValue))
end)

-- Vérifier l'existence
if cache.has('key') then
    -- ...
end

-- Supprimer une valeur
cache.remove('key')
```

### Events
```lua
-- Enregistrer avec priorité
core.events.Register('monEvent', function(data)
    print('Event reçu:', data)
end, core.events.Priority.HIGH)

-- Déclencher avec métriques
core.events.Trigger('monEvent', 'données')

-- Communication sécurisée
core.events.ToClient(playerId, 'eventName', ...)
core.events.ToServer('eventName', ...)

-- Broadcast avec vérification
if core.service == 'server' then
    core.events.Broadcast('globalEvent', ...)
end
```

### Callbacks
```lua
-- Server-side avec validation
core.callback.Register('getData', function(source, ...)
    if not source then return false end
    return { success = true, data = {...} }
end)

-- Client-side avec timeout personnalisé
core.callback.Trigger('getData', 5000, function(result)
    if result.success then
        -- ...
    end
end, 'param1')

-- Utilisation synchrone
local success, result = pcall(function()
    return core.callback.Await('getData', 0, 'param1')
end)
```

### Classes
```lua
-- Classe avec données privées et validation
local Player = core.Class('Player')

function Player:init()
    self.private = {
        health = 100,
        armor = 0
    }
    self.public = {
        id = cache.get('serverId'),
        name = cache.get('name')
    }
end

function Player:damage(amount)
    if type(amount) ~= 'number' then return false end
    self.private.health = math.max(0, self.private.health - amount)
    return true
end

-- Héritage avec export
local Admin = core.Class('Admin', Player, true)

function Admin:init()
    Player.init(self)
    self.private.permissions = {'admin.kick', 'admin.ban'}
end
```

## Bonnes pratiques

### Performance
```lua
-- Utiliser les constantes locales
local GetGameTimer = GetGameTimer
local Wait = Wait

-- Éviter les boucles infinies sans Wait
CreateThread(function()
    while true do
        -- Code
        Wait(0)
    end
end)

-- Utiliser le cache plutôt que les appels natifs
local ped = cache.get('ped')
```

### Sécurité
```lua
-- Toujours valider les entrées
core.events.Register('playerAction', function(data)
    if type(data) ~= 'table' then return end
    if not data.action then return end
    -- ...
end)

-- Utiliser les callbacks pour les données sensibles
core.callback.Register('getPlayerData', function(source)
    if not source then return false end
    -- ...
end)
```

## Sécurité

### Protection contre les exploits
- Validation des entrées côté serveur
- Système de rate limiting intégré
- Vérification des permissions
- Protection contre l'injection SQL

### Bonnes pratiques
- Ne jamais faire confiance aux données client
- Toujours valider les types
- Utiliser les callbacks pour les données sensibles
- Implémenter des timeouts appropriés

## Performance

### Optimisations
- Système de cache pour réduire les appels natifs
- Gestion efficace des événements
- Priorisation des handlers
- Métriques de performance intégrées

### Monitoring
- Suivi des événements fréquents
- Mesure des temps d'exécution
- Alertes sur les performances dégradées
- Logs de debug configurables

## Contribution

### Comment contribuer
1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add AmazingFeature'`)
4. Push la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

### Standards de code
- Utiliser la documentation LuaLS/TypeScript
- Suivre les conventions de nommage
- Ajouter des tests unitaires
- Documenter les changements

## License
MIT License - voir [LICENSE](LICENSE) pour plus de détails