RegisterCommand('memory', function(s)
    if s ~= 0 then return end
    at.Info(collectgarbage('count').. ' bytes')
    collectgarbage('collect')
end)