local on = at.LoadModule('on')
local player = at.LoadModule('player')

on.net('at_core:loadPlayer', function(source)
    print('loadPlayer')
    player.create(source, {rank = "admin"})
end)