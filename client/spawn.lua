local function SpawnPlayer()
    repeat
        Wait(100)
    until DoesEntityExist(cache.get('ped'))

    RequestModel('mp_m_freemode_01')
    while not HasModelLoaded('mp_m_freemode_01') do
        Wait(100)
    end

    SetPlayerModel(cache.get('clientId'), 'mp_m_freemode_01')
    SetEntityCoords(PlayerPedId(), -3058.714, 3329.19, 12.5844, false, false, false, false)
    SetEntityHeading(PlayerPedId(), 180.0)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end

    if DoesEntityExist(PlayerPedId()) then
        SetPedDefaultComponentVariation(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

CreateThread(function()
    SpawnPlayer()
end)