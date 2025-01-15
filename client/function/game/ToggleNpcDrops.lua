function core.client.ToggleNpcDrops(state, playerId)
    local weaponPickups = {
        `PICKUP_WEAPON_CARBINERIFLE`,
        `PICKUP_WEAPON_PISTOL`,
        `PICKUP_WEAPON_PUMPSHOTGUN`
    }

    for i = 1, #weaponPickups do
        local pickup = weaponPickups[i]
        ToggleUsePickupsForPlayer(playerId, pickup, state)
    end
end