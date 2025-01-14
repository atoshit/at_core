cache = {}

CreateThread(function()
    while true do 
        local serverId = GetPlayerServerId(PlayerId())
        local clientId = PlayerId()
        local playerPed = PlayerPedId()
        local playerName = GetPlayerName(clientId)
        local playerCoords = GetEntityCoords(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= nil then 
            cache.vehicle = vehicle
        end

        if playerPed ~= nil then 
            cache.ped = playerPed
        end

        if playerName ~= nil then 
            cache.name = playerName
        end

        if playerCoords ~= nil then 
            cache.coords = playerCoords
        end

        if serverId ~= nil then 
            cache.serverId = serverId
        end

        if clientId ~= nil then 
            cache.clientId = clientId
        end

        Wait(500)
    end
end)

RegisterCommand('cache', function()
    print(json.encode(cache, { indent = true }))
end)