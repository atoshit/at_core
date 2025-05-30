--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local REGISTER_NET_EVENT <const> = RegisterNetEvent
local ADD_EVENT_HANDLER <const> = AddEventHandler
local STRING <const> = at.LoadModule('string')

---@param _ unknown
---@param event string
---@param callback function
---@private
local function addEventHandler(_, event, callback)
    return ADD_EVENT_HANDLER(STRING.formatByte(event), callback)
end

at.on = setmetatable({}, {
    __call = addEventHandler
})

---@param name string
---@param callback function|table
---@return function
---@private
function at.on.net(name, callback)
    if type(name) ~= 'string' then return at.Debug("(func: at.on.net) Param name is invalid") end
    if callback and (type(callback) ~= 'table' and type(callback) ~= 'function') then return REGISTER_NET_EVENT(STRING.formatByte(name)) end

    return REGISTER_NET_EVENT(STRING.formatByte(name), callback)
end

return at.on