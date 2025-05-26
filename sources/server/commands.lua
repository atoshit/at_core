RegisterCommand('memory', function(s)
    if s ~= 0 then return end
    print(collectgarbage('count').. ' bytes')
    collectgarbage('collect')
end)