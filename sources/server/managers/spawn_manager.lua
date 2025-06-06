local on = at.LoadModule('on')

on.net('at_core:loadPlayer', function(source)
    print('loadPlayer')
    at.CreatePlayer(source, {rank = "admin"})
end)