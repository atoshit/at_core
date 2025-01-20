---@param spawnCoords table
---@param cam table
local function StartSpawnAnimation(spawnCoords, cam)
    local startTime = GetGameTimer()
    local duration = 5000 

    -- Show spawn UI
    SendNUIMessage({
        type = 'showSpawnUI',
        serverName = GetConvar('sv_projectName', 'AT Core'),
        playerName = cache.get('name')
    })
    SetNuiFocus(true, true)

    -- Register NUI Callback
    RegisterNuiCallback('spawnPlayer', function(data, cb)
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = 'hideSpawnUI'
        })
        cb({})
    end)

    CreateThread(function()
        while GetGameTimer() - startTime < duration do
            local progress = (GetGameTimer() - startTime) / duration
            local height = 15.0 - (10.0 * progress) 
            local distance = 10.0 - (5.0 * progress)
            
            local camX = spawnCoords.x
            local camY = spawnCoords.y - distance
            local camZ = spawnCoords.z + height

            local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(spawnCoords.x, spawnCoords.y, spawnCoords.z + 1.0, camX, camY, camZ, 1, cache.get('ped'), 7 )
            local retval, hit, endCoords = GetShapeTestResult(rayHandle)

            if hit then
                SetCamCoord(cam, endCoords.x, endCoords.y, endCoords.z)
            else
                SetCamCoord(cam, camX, camY, camZ)
            end

            DisableAllControlActions(0)
            DisableAllControlActions(1)
            DisableAllControlActions(2)

            Wait(0)
        end

        SetGameplayCamRelativeHeading(0.0)
        SetCamActive(cam, false)
        RenderScriptCams(false, true, 1000, true, true)
        DestroyCam(cam, true)
        
        FreezeEntityPosition(cache.get('ped'), false)
        
        core.events.Trigger('at:playerSpawned')
        core.events.ToServer('at:playerSpawned')
    end)
end

local function SpawnPlayer()
    DoScreenFadeOut(500)
    
    repeat
        Wait(100)
    until DoesEntityExist(cache.get('ped'))

    RequestModel('mp_m_freemode_01')

    while not HasModelLoaded('mp_m_freemode_01') do
        Wait(100)
    end

    SetPlayerModel(cache.get('clientId'), 'mp_m_freemode_01')

    Wait(550)

    local spawnCoords = vector3(-3058.714, 3329.19, 12.5844)
    SetEntityCoords(cache.get('ped'), spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false, false)
    SetEntityHeading(cache.get('ped'), 180.0)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end

    if DoesEntityExist(cache.get('ped')) then
        SetPedDefaultComponentVariation(cache.get('ped'))
        FreezeEntityPosition(cache.get('ped'), true)
        
        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        
        SetCamCoord(cam, spawnCoords.x, spawnCoords.y - 10.0, spawnCoords.z + 15.0)
        PointCamAtEntity(cam, cache.get('ped'), 0.0, 0.0, 0.0, true)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        
        DoScreenFadeIn(1000)
        Wait(1000)

        StartSpawnAnimation(spawnCoords, cam)
    end
end

CreateThread(function()
    SpawnPlayer()
end)