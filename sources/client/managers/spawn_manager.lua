--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local GET_CONVAR <const> = GetConvar
local EMIT <const> = at.LoadModule('emit')

local function spawnCharacter(data)
    repeat
        Wait(200)
    until DoesEntityExist(PlayerPedId())

    local MODEL <const> = at.LoadModule('model')
    local ENTITY <const> = at.LoadModule('entity')
    local PED_MODEL <const> = GET_CONVAR('at_core:spawn:ped', 'mp_m_freemode_01')

    MODEL.setToPlayer(PED_MODEL, PlayerId())

    if not data.coords then
        local COORDS <const> = json.decode(GET_CONVAR('at_core:spawn:coords', {}))

        ENTITY.setCoords(PlayerPedId(), vec3(COORDS.x, COORDS.y, COORDS.z), COORDS.w, false, false, false)
    else
        ENTITY.setCoords(PlayerPedId(), vec3(-391.3216, 4363.728, 58.65862), 345.3, false, false, false)
    end

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end

    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        SetPedDefaultComponentVariation(playerPed)
        ENTITY.freeze(playerPed, false)

        EMIT.net('at_core:playerLoaded')
        EMIT('at_core:playerLoaded')
    end
end

local CB <const> = at.LoadModule('callback')

CB.callServer({
    eventName = 'at_core:loadPlayer',
    args = {},
    timeout = 5,
    callback = function(data)
        spawnCharacter(data)
    end
})