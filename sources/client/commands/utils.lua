RegisterCommand('minimap', function()
    print('minimap')
    local minimap = at.LoadModule('minimap')

    minimap.display()
end)

RegisterCommand('id', function()
    print(GetPlayerServerId(PlayerId()))
end)

RegisterCommand('playerid', function()
    print(PlayerId())
end)

RegisterCommand('memory', function()
    print(collectgarbage('count').. ' bytes')
    collectgarbage('collect')
end)