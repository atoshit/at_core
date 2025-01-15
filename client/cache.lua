---@class Cache
---@field private table<string, any>
local Cache = {
    _data = {},
    _methods = {}
}

local mt = {
    __index = function(self, key)
        if Cache._methods[key] then
            return Cache._methods[key]
        end
        return Cache._data[key]
    end,
    __newindex = function(self, key, value)
        if value == nil then
            core.utils.Debug('WARN', ('Attempting to set nil value for cache.%s'):format(key))
            return
        end
        
        local oldValue = Cache._data[key]
        Cache._data[key] = value
        
        -- Notify observers
        if Cache._methods._observers and Cache._methods._observers[key] then
            for _, callback in ipairs(Cache._methods._observers[key]) do
                callback(value, oldValue)
            end
        end
    end
}

function Cache._methods.get(key)
    return Cache._data[key]
end

function Cache._methods.set(key, value)
    if value == nil then return end
    Cache._data[key] = value
end

function Cache._methods.has(key)
    return Cache._data[key] ~= nil
end

function Cache._methods.remove(key)
    Cache._data[key] = nil
end

function Cache._methods.onChange(key, callback)
    if not Cache._methods._observers then
        Cache._methods._observers = {}
    end
    if not Cache._methods._observers[key] then
        Cache._methods._observers[key] = {}
    end
    table.insert(Cache._methods._observers[key], callback)
end

CreateThread(function()
    local clientId = PlayerId()
    Cache._methods.set('clientId', clientId)
    Cache._methods.set('serverId', GetPlayerServerId(clientId))
    Cache._methods.set('name', GetPlayerName(clientId))

    while true do 
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        Cache._methods.set('ped', playerPed)
        Cache._methods.set('coords', coords)
        
        if vehicle and vehicle ~= 0 then 
            Cache._methods.set('vehicle', vehicle)
            
            for i = 0, GetVehicleMaxNumberOfPassengers(veh) do
                if GetPedInVehicleSeat(veh) then 
                    Cache._methods.set('vehicleSeat', i)
                end
            end
        elseif Cache._methods.has('vehicle') then
            Cache._methods.remove('vehicle')
        end

        Wait(500)
    end
end)

-- Debug command
RegisterCommand('cache', function()
    local data = {}
    for k, v in pairs(Cache._data) do
        data[k] = v
    end
    print(json.encode(data, { indent = true }))
end)

local cache = setmetatable({}, mt)

_ENV.cache = cache