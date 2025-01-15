function core.client.TogglePlayerRegen(state, playerId)
    if state then 
        SetPlayerHealthRechargeMultiplier(playerId, 1.0)
    else
        SetPlayerHealthRechargeMultiplier(playerId, 0.0)
    end
end