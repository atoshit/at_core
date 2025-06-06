--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local mysql = at.LoadModule('mysql')

local players_instance = {}
player_object = {}
player_object.__index = player_object

---@param self player_object
local function save(self)
    at.Debug('(func: save) called')
    return mysql.savePlayer(self.name, self.rank, self.identifiers.license, self.identifiers.steam, self.identifiers.discord, self.identifiers.ip, self.identifiers.xbl, self.identifiers.live, self.identifiers.tokens)
end

---@param self player_object
local function destroy(self)
    at.Debug('(func: destroy) called')

    if not players_instance[self.id] then
        return
    end

    players_instance[self.id] = nil
end

---@param id number
---@param data table
---@return player_object
function player_object.new(id, data)
    at.Debug('(func: new) called')

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
    self.destroy = destroy

    players_instance[self.id] = self

    return self
end

---@param id number
---@return player_object
function at.GetPlayer(id)
    at.Debug('(func: at.GetPlayer) called')

    if players_instance[id] then
        return players_instance[id]
    end
end

---@param id number
---@return 
function at.DestroyPlayer(id)
    at.Debug('(func: at.DestroyPlayer) called')

    if not players_instance[id] then
        return at.Debug('(func: at.DestroyPlayer) player not found')
    end

    return players_instance[id] = nil
end

return {
    create = player_object.new,
    get = at.GetPlayer,
    destroy = at.DestroyPlayer
}