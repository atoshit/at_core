--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local GET_CONVAR <const> = GetConvar
local emit = at.LoadModule('emit')

local function spawnTest()
    repeat
        Wait(200)
    until DoesEntityExist(PlayerPedId())

    local MODEL <const> = at.LoadModule('model')
    local ENTITY <const> = at.LoadModule('entity')
    local COORDS <const> = json.decode(GET_CONVAR('at_core:spawn:coords', {}))
    local PED_MODEL <const> = GET_CONVAR('at_core:spawn:ped', 'mp_m_freemode_01')

    MODEL.setToPlayer(PED_MODEL, PlayerId())

    ENTITY.setCoords(PlayerPedId(), vec3(COORDS.x, COORDS.y, COORDS.z), COORDS.w, false, false, false)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end

    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        SetPedDefaultComponentVariation(playerPed)
        ENTITY.freeze(playerPed, false)
        emit.net('at_core:loadPlayer')
    end
end

CreateThread(spawnTest)