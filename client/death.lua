local function OnPlayerDead()
    SetEntityHealth(cache.get('ped'), 0)

    CreateThread(function()
        while cache.get('isDead') do 
            Wait(0)

            DisableControlAction(0)
            ThefeedHideThisFrame()
            HideHudAndRadarThisFrame()
        end
    end)
end

local function DeadThread()
    CreateThread(function()
        while true do 
            if cache.get('ped') and IsPedFatallyInjured(cache.get('ped')) and not cache.get('isDead') then
                cache.set('isDead', true)
                core.utils.Debug('INFO', 'Player is dead')
            end

            Wait(850)
        end
    end)
end

core.events.Register('at:playerSpawned', function()
    core.utils.Debug('INFO', 'Player spawned')

    DeadThread()
end)