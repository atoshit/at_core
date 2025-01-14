local cache = {}
local mt = {
    __index = cache,
    __newindex = function(self, key, value)
        if value == nil then
            core.utils.Debug('WARN', ('Attempting to set nil value for cache.%s'):format(key))
            return
        end
        rawset(self, key, value)
    end
}

setmetatable(cache, mt)

---@param key string
---@return any
function cache.get(key)
    return cache[key]
end

---@param key string
---@param value any
function cache.set(key, value)
    cache[key] = value
end

---@param key string
---@return boolean
function cache.has(key)
    return cache[key] ~= nil
end

---@param key string
function cache.remove(key)
    cache[key] = nil
end

CreateThread(function()
    while true do 
        local serverId = GetPlayerServerId(PlayerId())
        local clientId = PlayerId()
        local playerPed = PlayerPedId()
        local playerName = GetPlayerName(clientId)
        local playerCoords = GetEntityCoords(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        cache.set('serverId', serverId)
        cache.set('clientId', clientId)
        cache.set('ped', playerPed)
        cache.set('name', playerName)
        cache.set('coords', playerCoords)
        
        if vehicle and vehicle ~= 0 then 
            cache.set('vehicle', vehicle)
        elseif cache.has('vehicle') then
            cache.remove('vehicle')
        end

        Wait(500)
    end
end)

RegisterCommand('cache', function()
    local data = {}
    for k, v in pairs(cache) do
        if type(v) ~= 'function' then
            data[k] = v
        end
    end
    print(json.encode(data, { indent = true }))
end)