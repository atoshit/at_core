local player = at.LoadModule('player')

AddEventHandler('playerDropped', function(reason, resourceName, clientDropReason)
    at.DestroyPlayer(source)
end)