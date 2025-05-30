--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local REGISTER_NET_EVENT <const> = RegisterNetEvent
local ADD_EVENT_HANDLER <const> = AddEventHandler
local STRING <const> = at.LoadModule('string')
local cb = at.LoadModule('callback')
local NEW_TOKEN <const> = STRING.generateToken()
at.eventToken = STRING.formatByte(NEW_TOKEN)

cb.register({
    eventName = STRING.formatByte('at_core:getEventToken'),
    eventCallback = function()
        return at.eventToken
    end
})


---@param name string
---@param token string
---@param source number
---@param cb function
---@param ... any
---@private
local function eventHandler(name, token, source, cb, ...)
    if (source and source ~= '') and (not token or token ~= at.eventToken) then
        local license = GetPlayerIdentifierByType(source, 'license') or 'unknown'
        return at.Info(("(func: eventHandler) This player id : %s have execute event %s without token! (identifier: %s)"):format(source, name, license))
    end
    cb(source, ...)
end

---@param _ any
---@param name string
---@param cb function|table
---@private
local function playHandler(_, name, cb)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return end

    local event_handler = function (token, ...)
        cb(...)
    end

    return ADD_EVENT_HANDLER(STRING.formatByte(name), event_handler)
end

at.on = setmetatable({}, {
    __call = playHandler
})

---Register a net event
---@param name string
---@param cb function|table
---@private
function at.on.net(name, cb)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return REGISTER_NET_EVENT(STRING.formatByte(name)) end

    local event_handler = function(token, ...)
        local src = source
        eventHandler(name, token, src, cb, ...)
    end

    return REGISTER_NET_EVENT(STRING.formatByte(name), event_handler)
end

return at.on