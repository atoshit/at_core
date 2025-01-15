local function ClearClientGame()
    local ped = cache.get('ped')

    ClearAllBrokenGlass()
    ClearAllHelpMessages()
    LeaderboardsReadClearAll()
    ClearBrief()
    ClearGpsFlags()
    ClearPrints()
    ClearSmallPrints()
    ClearReplayStats()
    LeaderboardsClearCacheData()
    ClearFocus()
    ClearHdArea()
    ClearPedBloodDamage(ped)
    ClearPedWetness(ped)
    ClearPedEnvDirt(ped)
    ResetPedVisibleDamage(ped)
end

CreateThread(function()
    local SetVehicleModelIsSuppressed <const> = SetVehicleModelIsSuppressed
    local SetPedModelIsSuppressed <const> = SetPedModelIsSuppressed
    local SetRandomBoats <const> = SetRandomBoats
    local SetRandomTrains <const> = SetRandomTrains
    local SetGarbageTrucks <const> = SetGarbageTrucks
    local SetCreateRandomCops <const> = SetCreateRandomCops
    local SetCreateRandomCopsNotOnScenarios <const> = SetCreateRandomCopsNotOnScenarios
    local SetCreateRandomCopsOnScenarios <const> = SetCreateRandomCopsOnScenarios
    local SetDispatchCopsForPlayer <const> = SetDispatchCopsForPlayer
    local SetPedPopulationBudget <const> = SetPedPopulationBudget
    local SetVehiclePopulationBudget <const> = SetVehiclePopulationBudget
    local SetNumberOfParkedVehicles <const> = SetNumberOfParkedVehicles
    local playerId = cache.get('clientId')

    core.client.ToggleNpcDrops(core.utils.Convar('at:npcDrops'), playerId)
    core.client.TogglePlayerRegen(core.utils.Convar('at:playerHealthRegen'), playerId)
    SetCanAttackFriendly(cache.get('ped'), true, false)
    NetworkSetFriendlyFireOption(true)
    ClearPlayerWantedLevel(playerId)
    SetDispatchCopsForPlayer(playerId, core.utils.Convar('at:dispatch'))
    SetMaxWantedLevel(0)
    core.client.ToggleScenarios(core.utils.Convar('at:scenario'))
    SetRandomBoats(core.utils.Convar('at:enableBoats'))
    SetRandomTrains(core.utils.Convar('at:enableTrains'))
    SetGarbageTrucks(core.utils.Convar('at:enableGarbageTruck'))
    SetCreateRandomCops(core.utils.Convar('at:enableCops'))
    SetCreateRandomCopsNotOnScenarios(core.utils.Convar('at:enableCops'))
    SetCreateRandomCopsOnScenarios(core.utils.Convar('at:enableCops'))
    SetDispatchCopsForPlayer(cache.playerid, core.utils.Convar('at:enableCops'))
    SetPedPopulationBudget(core.utils.Convar('at:npcPopulation'))
    SetVehiclePopulationBudget(core.utils.Convar('at:vehiclePopulation'))
    SetNumberOfParkedVehicles(core.utils.Convar('at:parkedVehiclePopulation'))

    if core.utils.Convar('at:blacklistedPed') and #core.utils.Convar('at:blacklistedPed') > 0 then
        for i = 1, #core.utils.Convar('at:blacklistedPed') do
            local ped = core.utils.Convar('at:blacklistedPed')[i]
            ped = type(ped) == 'number' and ped or joaat(ped)
            SetPedModelIsSuppressed(ped, true)
        end
    end

    if core.utils.Convar('at:blacklistedVehicle') and #core.utils.Convar('at:blacklistedVehicle') > 0 then
        for i = 1, #core.utils.Convar('at:blacklistedVehicle') do
            local veh = core.utils.Convar('at:blacklistedVehicle')[i]
            veh = type(veh) == 'number' and veh or joaat(veh)
            SetVehicleModelIsSuppressed(veh, true)
        end
    end

    while true do
        ClearClientGame()
        Wait(5000)
    end
end)