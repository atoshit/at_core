# AT Core

Core pour FiveM avec gestion optimisée des événements et des utilitaires.

## Caractéristiques

- Système d'événements optimisé
- Gestion des convars
- Debug système configurable
- Support MySQL intégré
- Compatibilité client/serveur
- Système de métadonnées

## Configuration

### Convars disponibles
- `at:label`: Nom d'affichage du core
- `at:gamebuild`: Version du build GTA
- `at:debug`: Niveau de debug (1: WARN, 2: INFO, 3: DEBUG)

## Installation

1. Assurez-vous d'avoir `oxmysql` installé
2. Placez la ressource dans votre dossier `resources`
3. Ajoutez `ensure at_core` à votre `server.cfg`

## Usage

### Système d'événements

```lua
-- Enregistrer un événement
core.events.Register('monEvent', function(data)
    print('Event reçu:', json.encode(data, {indent = true}))
end)

-- Déclencher un événement
core.events.Trigger('monEvent', {
    message = 'Hello, world!',
    data = {
        name = 'John',
        age = 30
    }
})
```

### Debug

```lua
core.utils.Debug('INFO', 'Message de debug')
core.utils.Debug('WARN', 'Message de debug')
core.utils.Debug('ERROR', 'Message de debug')
```

## Documentation 

### Events
- `Register(eventName, callback)`: Enregistre un événement
- `Unregister(eventName, [callback])`: Désenregistre un événement
- `Trigger(eventName, ...)`: Déclenche un événement local
- `Broadcast(eventName, ...)`: Diffuse à tous les clients
- `ToClient(playerId, eventName, ...)`: Envoie à un client spécifique
- `ToServer(eventName, ...)`: Envoie au serveur

### Utils
- `Debug(type, message)`: Système de logging
- `Convar(name, default, type)`: Gestion des convars
- `IsType(value, expected)`: Vérification de type
- `IsResourceStarted(resource)`: Vérifie si une ressource est active

## License
MIT License