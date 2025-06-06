--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

RegisterCommand('memory', function(s)
    if s ~= 0 then return end
    at.Info(collectgarbage('count').. ' bytes')
    collectgarbage('collect')
end)