core.events = {
    registered = {},
    handlers = {},
    handlersCount = {},

    Register = function(eventName, callback)
        if not eventName or type(eventName) ~= 'string' then
            core.utils.Debug('ERROR', 'Invalid event name')
            return false
        end

        if not callback or type(callback) ~= 'function' then
            core.utils.Debug('ERROR', 'Invalid callback for event: ' .. eventName)
            return false
        end

        if not core.events.handlers[eventName] then
            core.events.handlers[eventName] = {}
            core.events.handlersCount[eventName] = 0
            RegisterNetEvent(eventName)
        end

        local nextIndex = core.events.handlersCount[eventName] + 1
        core.events.handlers[eventName][nextIndex] = callback
        core.events.handlersCount[eventName] = nextIndex

        if not core.events.registered[eventName] then
            core.events.registered[eventName] = true
            
            AddEventHandler(eventName, function(...)
                local handlers = core.events.handlers[eventName]
                local count = core.events.handlersCount[eventName]
                
                for i = 1, count do
                    local handler = handlers[i]
                    if handler then
                        handler(...)
                    end
                end
            end)
        end

        return true
    end,

    Unregister = function(eventName, callback)
        if not core.events.handlers[eventName] then return false end

        if callback then
            local handlers = core.events.handlers[eventName]
            local count = core.events.handlersCount[eventName]
            
            for i = 1, count do
                if handlers[i] == callback then
                    for j = i, count - 1 do
                        handlers[j] = handlers[j + 1]
                    end
                    handlers[count] = nil
                    core.events.handlersCount[eventName] = count - 1
                    break
                end
            end
        else
            core.events.handlers[eventName] = nil
            core.events.handlersCount[eventName] = nil
            core.events.registered[eventName] = nil
        end

        return true
    end,

    Trigger = function(eventName, ...)
        if not eventName then
            core.utils.Debug('ERROR', 'Invalid event name for Trigger')
            return false
        end
        TriggerEvent(eventName, ...)
        return true
    end,

    Broadcast = function(eventName, ...)
        if not eventName then
            core.utils.Debug('ERROR', 'Invalid event name for Broadcast')
            return false
        end

        if core.service == 'server' then
            TriggerClientEvent(eventName, -1, ...)
            return true
        else
            core.utils.Debug('ERROR', 'Broadcast can only be called from server')
            return false
        end
    end,

    ToClient = function(playerId, eventName, ...)
        if not eventName or not playerId then
            core.utils.Debug('ERROR', 'Invalid parameters for ToClient')
            return false
        end

        if core.service == 'server' then
            if type(playerId) == 'number' then
                TriggerClientEvent(eventName, playerId, ...)
                return true
            else
                core.utils.Debug('ERROR', 'Invalid player ID')
                return false
            end
        else
            core.utils.Debug('ERROR', 'ToClient can only be called from server')
            return false
        end
    end,

    ToServer = function(eventName, ...)
        if not eventName then
            core.utils.Debug('ERROR', 'Invalid event name for ToServer')
            return false
        end

        if core.service == 'client' then
            TriggerServerEvent(eventName, ...)
            return true
        else
            core.utils.Debug('ERROR', 'ToServer can only be called from client')
            return false
        end
    end
}

--[[ EXEMPLES D'UTILISATION

-- 1. Register - Enregistrement d'événements
--------------------------------------------
-- Simple event
core.events.Register('playerJoined', function(playerId)
    print('Player joined:', playerId)
end)

-- Multiple handlers pour le même événement
local handler1 = function(playerId)
    print('Handler 1:', playerId)
end

local handler2 = function(playerId)
    print('Handler 2:', playerId)
end

core.events.Register('playerJoined', handler1)
core.events.Register('playerJoined', handler2)


-- 2. Unregister - Désenregistrement d'événements
------------------------------------------------
-- Supprimer un handler spécifique
core.events.Unregister('playerJoined', handler1)

-- Supprimer tous les handlers d'un événement
core.events.Unregister('playerJoined')


-- 3. Trigger - Déclencher un événement local
-------------------------------------------
-- Déclencher un événement simple
core.events.Trigger('myEvent')

-- Déclencher avec des paramètres
core.events.Trigger('playerDied', playerId, killerType, weaponHash)


-- 4. Broadcast - Envoyer à tous les clients (SERVER ONLY)
--------------------------------------------------------
-- Broadcast simple
core.events.Broadcast('weatherUpdate', 'RAIN')

-- Broadcast avec multiple paramètres
core.events.Broadcast('gameEvent', eventType, data1, data2)


-- 5. ToClient - Envoyer à un client spécifique (SERVER ONLY)
-----------------------------------------------------------
-- Envoyer à un joueur
core.events.ToClient(playerId, 'personalMessage', 'Bienvenue!')

-- Envoyer des données complexes
core.events.ToClient(playerId, 'updateInventory', {
    items = {'item1', 'item2'},
    money = 1000
})


-- 6. ToServer - Envoyer au serveur (CLIENT ONLY)
-----------------------------------------------
-- Requête simple
core.events.ToServer('requestData')

-- Envoyer des données au serveur
core.events.ToServer('updatePosition', {
    x = 100.0,
    y = 200.0,
    z = 300.0
})


-- EXEMPLE D'UTILISATION COMPLÈTE (Communication Client-Serveur)
-------------------------------------------------------------
-- Sur le serveur:
core.events.Register('playerRequest', function(playerId, requestType)
    if requestType == 'getData' then
        local data = { success = true, message = 'Voici vos données' }
        core.events.ToClient(playerId, 'playerResponse', data)
    end
end)

-- Sur le client:
core.events.Register('playerResponse', function(data)
    if data.success then
        print(data.message)
    end
end)

-- Depuis le client, envoyer une requête:
core.events.ToServer('playerRequest', 'getData')

]]