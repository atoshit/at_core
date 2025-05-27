print("loaded")

local function spawnTest()
    print('spawnTest')

    repeat
        Wait(200)
    until DoesEntityExist(PlayerPedId())

    local MODEL <const> = at.LoadModule('model')
    local ENTITY <const> = at.LoadModule('entity')

    MODEL.setToPlayer('mp_m_freemode_01', PlayerId())

    local COORDS <const> = vec3(-3058.714, 3329.19, 12.5844)
    ENTITY.setCoords(PlayerPedId(), COORDS, nil, false, false, false)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end

    if DoesEntityExist(PlayerPedId()) then
        SetPedDefaultComponentVariation(PlayerPedId())
        ENTITY.freeze(PlayerPedId(), false)
    end
end

CreateThread(spawnTest)