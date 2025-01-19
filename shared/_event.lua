core.events = {
    registered = {},
    handlers = {},
    handlersCount = {},
    metrics = {},
    thresholds = {
        executionTime = 10,
        frequency = {
            count = 50, 
            window = 1000, 
        }
    },

    Priority = {
        HIGHEST = 1,
        HIGH = 2,
        NORMAL = 3,
        LOW = 4,
        LOWEST = 5
    },

    ---@param eventName string
    ---@param callback function
    ---@param priority? number
    ---@return boolean
    Register = function(eventName, callback, priority)
        if not eventName or type(eventName) ~= 'string' then
            error('Invalid event name')
            return false
        end

        if not callback or type(callback) ~= 'function' then
            error('Invalid callback for event: ' .. eventName)
            return false
        end

        if not core.events.handlers[eventName] then
            core.events.handlers[eventName] = {}
            core.events.handlersCount[eventName] = 0
            core.events.metrics[eventName] = {
                calls = 0,
                lastReset = GetGameTimer(),
                totalTime = 0,
                maxTime = 0
            }
            RegisterNetEvent(eventName)
        end

        local handler = {
            callback = callback,
            priority = priority or core.events.Priority.NORMAL
        }
        
        -- Insert handler with priority
        local inserted = false
        for i = 1, core.events.handlersCount[eventName] do
            if core.events.handlers[eventName][i].priority > handler.priority then
                table.insert(core.events.handlers[eventName], i, handler)
                inserted = true
                break
            end
        end
        
        if not inserted then
            table.insert(core.events.handlers[eventName], handler)
        end
        
        core.events.handlersCount[eventName] = core.events.handlersCount[eventName] + 1

        if not core.events.registered[eventName] then
            core.events.registered[eventName] = true
            
            AddEventHandler(eventName, function(...)
                local handlers = core.events.handlers[eventName]
                local count = core.events.handlersCount[eventName]
                local metrics = core.events.metrics[eventName]
                local startTime = GetGameTimer()
                
                metrics.calls = metrics.calls + 1
                local currentTime = startTime
                if (currentTime - metrics.lastReset) >= core.events.thresholds.frequency.window then
                    if metrics.calls >= core.events.thresholds.frequency.count then
                        core.utils.Debug('WARN', string.format("Event '%s' called %d times in %dms", eventName, metrics.calls, core.events.thresholds.frequency.window))
                    end
                    metrics.calls = 0
                    metrics.lastReset = currentTime
                end

                for i = 1, count do
                    local handler = handlers[i]
                    if handler then
                        local handlerStart = GetGameTimer()
                        handler.callback(...)
                        local executionTime = GetGameTimer() - handlerStart
                        
                        metrics.totalTime = metrics.totalTime + executionTime
                        metrics.maxTime = math.max(metrics.maxTime, executionTime)

                        if executionTime > core.events.thresholds.executionTime then
                            core.utils.Debug('WARN', string.format("Event '%s' handler took %dms to execute", eventName, executionTime))
                        end
                    end
                end
            end)
        end

        return true
    end,

    ---@param eventName string
    ---@param callback? function
    ---@return boolean
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
            core.events.metrics[eventName] = nil
        end

        return true
    end,

    ---@param eventName string
    ---@param ... any
    ---@return boolean
    Trigger = function(eventName, ...)
        if not eventName then
            error('Invalid event name for Trigger')
            return false
        end
        TriggerEvent(eventName, ...)
        return true
    end,

    ---@param eventName string
    ---@param ... any
    ---@return boolean
    Broadcast = function(eventName, ...)
        if not eventName then
            error('Invalid event name for Broadcast')
            return false
        end

        if core.service == 'server' then
            TriggerClientEvent(eventName, -1, ...)
            return true
        else
            error('Broadcast can only be called from server')
            return false
        end
    end,

    ---@param playerId number
    ---@param eventName string
    ---@param ... any
    ---@return boolean
    ToClient = function(playerId, eventName, ...)
        if not eventName or not playerId then
            error('Invalid parameters for ToClient')
            return false
        end

        if core.service == 'server' then
            if type(playerId) == 'number' then
                TriggerClientEvent(eventName, playerId, ...)
                return true
            else
                error('Invalid player ID')
                return false
            end
        else
            error('ToClient can only be called from server')
            return false
        end
    end,

    ---@param eventName string
    ---@param ... any
    ---@return boolean
    ToServer = function(eventName, ...)
        if not eventName then
            error('Invalid event name for ToServer')
            return false
        end

        if core.service == 'client' then
            TriggerServerEvent(eventName, ...)
            return true
        else
            error('ToServer can only be called from server')
            return false
        end
    end,

    ---@param eventName string
    ---@return table<string, any>|nil
    GetMetrics = function(eventName)
        if not eventName or not core.events.metrics[eventName] then return nil end
        return core.events.metrics[eventName]
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


-- 7. Vérifier les métriques d'un événement
------------------------------------------
local metrics = core.events.GetMetrics('playerJoined')
if metrics then
    print(string.format(
        "Event 'playerJoined' stats:\nCalls: %d\nTotal time: %dms\nMax time: %dms",
        metrics.calls,
        metrics.totalTime,
        metrics.maxTime
    ))
end

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