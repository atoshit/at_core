local player = at.LoadModule('player')

AddEventHandler('playerDropped', function(reason, resourceName, clientDropReason)
    local player_obj = player.get(source)

    if not player_obj then return end

    player_obj:save()
    player_obj:destroy()
end)