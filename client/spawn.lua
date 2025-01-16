local function SpawnPlayer()
    --DoScreenFadeOut(0)

    repeat
        Wait(100)
    until DoesEntityExist(cache.get('ped'))

    RequestModel('mp_m_freemode_01')

    while not HasModelLoaded('mp_m_freemode_01') do
        Wait(100)
    end

    SetPlayerModel(cache.get('clientId'), 'mp_m_freemode_01')

    Wait(550)

    SetEntityCoords(cache.get('ped'), -3058.714, 3329.19, 12.5844, false, false, false, false)
    SetEntityHeading(cache.get('ped'), 180.0)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
        --DoScreenFadeIn(0)
    end

    if DoesEntityExist(cache.get('ped')) then
        SetPedDefaultComponentVariation(cache.get('ped'))
        FreezeEntityPosition(cache.get('ped'), false)

        core.events.Trigger('at:playerSpawned')
        core.events.ToServer('at:playerSpawned')
    end
end

CreateThread(function()
    SpawnPlayer()
end)