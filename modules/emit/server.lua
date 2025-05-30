--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local TRIGGER_EVENT <const> = TriggerEvent
local TRIGGER_CLIENT_EVENT <const> = TriggerClientEvent
local TRIGGER_CLIENT_EVENT_INTERNAL <const> = TriggerClientEventInternal
local STRING <const> = at.LoadModule('string')

---@param name string
---@private
local function playEvent(_, name, _, ...)
    TRIGGER_EVENT(STRING.formatByte(name), at.eventToken, ...)
end

at.emit = setmetatable({}, {
    __call = playEvent
})

---@param name string
---@param source number
---@param ... unknown
---@return function
---@private
function at.emit.net(name, source, ...)
    local payload <const> = msgpack.pack_args(...)
    local payloadSize <const> = #payload

    if type(source) == 'table' and table.type(source) == 'array' then
        for i = 1, #source do
            local _source = source[i]
            TRIGGER_CLIENT_EVENT_INTERNAL(STRING.formatByte(name), _source, payload, payloadSize)
        end
        return
    end

    return TRIGGER_CLIENT_EVENT_INTERNAL(STRING.formatByte(name), source, payload, payloadSize)
end