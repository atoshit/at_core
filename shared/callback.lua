core.callback = {
    pending = {},
    timers = {},
    timeout = GetConvarInt('at:callbackTimeout', 300000),
    prefix = '__at_cb_%s'
}

core.events.Register(core.callback.prefix:format(core.env), function(key, ...)
    local cb = core.callback.pending[key]
    core.callback.pending[key] = nil
    return cb and cb(...)
end)

---@param event string
---@param delay? number|false
---@return boolean
local function CanTriggerEvent(event, delay)
    if not delay or type(delay) ~= 'number' or delay <= 0 then return true end

    local time = GetGameTimer()
    if (core.callback.timers[event] or 0) > time then
        return false
    end

    core.callback.timers[event] = time + delay
    return true
end

---@param success boolean
---@param result any
---@param ... any
---@return any, ...
local function HandleCallbackResponse(success, result, ...)
    if not success then
        if result then
            return print(('^1CALLBACK ERROR: %s^0\n%s'):format(result,
                Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString()) or ''))
        end
        return false
    end
    return result, ...
end

if core.service == 'client' then

    ---@param event string
    ---@param delay number | false| nil
    ---@param cb function | false
    ---@param ... any
    ---@return ...
    local function TriggerServerCallback(event, delay, cb, ...)
        if not CanTriggerEvent(event, delay) then return end

        local key
        repeat
            key = ('%s:%s'):format(event, math.random(0, 100000))
        until not core.callback.pending[key]

        core.events.ToServer(core.callback.prefix:format(event), core.env, key, ...)

        ---@type promise|false
        local promise = not cb and promise.new()

        core.callback.pending[key] = function(response, ...)
            response = { response, ... }
            if promise then
                return promise:resolve(response)
            end
            if cb then
                cb(table.unpack(response))
            end
        end

        if promise then
            SetTimeout(core.callback.timeout, function()
                promise:reject(("callback event '%s' timed out"):format(key))
            end)
            return table.unpack(core.Await(promise))
        end
    end

    core.callback.Trigger = setmetatable({}, {
        __call = function(_, event, delay, cb, ...)
            if not cb then
                core.utils.Debug('WARN', ("callback event '%s' will await response"):format(event))
            else
                assert(type(cb) == 'function', ("expected callback function, got %s"):format(type(cb)))
            end
            return TriggerServerCallback(event, delay, cb, ...)
        end
    })

    ---@param event string
    ---@param delay? number|false
    function core.callback.Await(event, delay, ...)
        return TriggerServerCallback(event, delay, false, ...)
    end

elseif core.service == 'server' then

    ---@param event string
    ---@param playerId number
    ---@param cb function|false
    ---@param ... any
    ---@return ...
    local function TriggerClientCallback(event, playerId, cb, ...)
        assert(DoesPlayerExist(playerId --[[@as string]]), ("target playerId '%s' does not exist"):format(playerId))

        local key
        repeat
            key = ('%s:%s:%s'):format(event, math.random(0, 100000), playerId)
        until not core.callback.pending[key]

        core.events.ToClient(playerId, core.callback.prefix:format(event), core.env, key, ...)

        ---@type promise | false
        local promise = not cb and promise.new()

        core.callback.pending[key] = function(response, ...)
            response = { response, ... }
            if promise then
                return promise:resolve(response)
            end
            if cb then
                cb(table.unpack(response))
            end
        end

        if promise then
            SetTimeout(core.callback.timeout, function()
                promise:reject(("callback event '%s' timed out"):format(key))
            end)
            return table.unpack(core.Await(promise))
        end
    end

    core.callback.Trigger = setmetatable({}, {
        __call = function(_, event, playerId, cb, ...)
            if not cb then
                core.utils.Debug('WARN', ("callback event '%s' will await response"):format(event))
            else
                assert(type(cb) == 'function', ("expected callback function, got %s"):format(type(cb)))
            end
            return TriggerClientCallback(event, playerId, cb, ...)
        end
    })

    ---@param event string
    ---@param playerId number
    function core.callback.Await(event, playerId, ...)
        return TriggerClientCallback(event, playerId, false, ...)
    end
end

---@param name string
---@param cb function
function RegisterCallback(name, cb)
    core.events.Register(core.callback.prefix:format(name), function(resource, key, ...)
        local source = source
        if core.service == 'client' then
            core.events.ToServer(core.callback.prefix:format(resource), key, HandleCallbackResponse(pcall(cb, ...)))
        else
            core.events.ToClient(source, core.callback.prefix:format(resource), key, HandleCallbackResponse(pcall(cb, source, ...)))
        end
    end)
end

core.callback.Register = RegisterCallback

-- Exemple d'utilisation:
--[[
    -- Server side
    core.callback.Register('getPlayerData', function(source, type)
        local data = {}
        -- Get player data logic here
        return data
    end)

    -- Client side
    -- Method 1: Using callback
    core.callback.trigger('getPlayerData', 0, function(data)
        print('Got player data:', json.encode(data))
    end, 'inventory')

    -- Method 2: Using Await
    local data = core.callback.Await('getPlayerData', 0, 'inventory')
    print('Got player data:', json.encode(data))
]]
