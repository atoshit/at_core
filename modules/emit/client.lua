--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local TRIGGER_EVENT <const> = TriggerEvent
local TRIGGER_SERVER_EVENT <const> = TriggerServerEvent
local STRING <const> = at.LoadModule('string')
local token

---comment
---@param _ unknown
---@param name string
---@param ... unknown
---@private
local function playEvent(_, name, ...)
    TriggerEvent(STRING.formatByte(name), ...)
end

at.emit = setmetatable({}, {
    __call = playEvent
})

local cb = at.LoadModule('callback')

--- Trigger a server-side event with a token
---@param name string
---@param ... unknown
---@private
function at.emit.net(name,...)
    if not token then
        token = cb.callServer({
            eventName = STRING.formatByte('at_core:getEventToken'),
            args = {},
            timeout = 5
        })        

        print('TOKEN', token)
    end

    TRIGGER_SERVER_EVENT(STRING.formatByte(name), token,...)
end

return at.emit