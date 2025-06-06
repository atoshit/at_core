RegisterCommand('players', function()
    print(at.playersCount)
end)

RegisterCommand('player', function(_, args)
    if not args[1] then return warn("/player 'id'") end

    local id = tonumber(#args[1])
    local player = at.GetPlayer(3)

    if not player then return end 

    print(player.name)
    print(player.rank)
end)