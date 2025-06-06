--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local mysql = at.LoadModule('mysql')

player_object = {}
player_object.__index = player_object

---@param self player_object
local function save(self)
    at.Debug('(func: save) called')
    return mysql.savePlayer(self.name, self.rank, self.identifiers)
end

---@param id number
---@param data table
---@return player_object
function player_object.new(id, data)
    at.Debug('(func: player_object.new) called')

    local self = setmetatable({}, player_object)

    self.id = id
    self.rank = (data.rank or 'user')
    self.name = (GetPlayerName(self.id) or 'unknown')
    self.identifiers = {
        license = (GetPlayerIdentifierByType(self.id, 'license') or 'unknown'),
        steam = (GetPlayerIdentifierByType(self.id, 'steam') or 'unknown'),
        discord = (GetPlayerIdentifierByType(self.id, 'discord') or 'unknown'),
        ip = (GetPlayerEndpoint(self.id) or 'unknown'),
        xbl = (GetPlayerIdentifierByType(self.id, 'xbl') or 'unknown'),
        live = (GetPlayerIdentifierByType(self.id, 'live') or 'unknown'),
        tokens = (GetPlayerTokens(self.id) or {})
    }

    self.save = save

    return self
end

return player_object.new