--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]


local CHECK_PLAYER_EXIST_QUERY <const> = 'SELECT `license` FROM `players` WHERE `license` = ? LIMIT 1'
local function playerExist(license)
    local result = MySQL.scalar.await(CHECK_PLAYER_EXIST_QUERY, {license})
    return result ~= nil
end

local SAVE_NEW_PLAYER_QUERY <const> = 'INSERT INTO `players` (`name`, `rank`, `license`, `steam`, `discord`, `ip`, `xbl`, `live`, `tokens`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
local SAVE_PLAYER_QUERY <const> = 'UPDATE `players` SET `name` = ?, `rank` = ?, `steam` = ?, `discord` = ?, `ip` = ?, `xbl` = ?, `live` = ?, `tokens` = ? WHERE `license` = ?'
local function savePlayer(name, rank, identifiers)
    local tokens_json = (type(identifiers.tokens) == 'table' and json.encode(identifiers.tokens) or identifiers.tokens)
    
    if playerExist(license) then
        return MySQL.update.await(SAVE_PLAYER_QUERY, {name, rank, identifiers.steam, identifiers.discord, identifiers.ip, identifiers.xbl, identifiers.live, tokens_json, identifiers.license})
    end

    MySQL.insert.await(SAVE_NEW_PLAYER_QUERY, {name, rank, identifiers.license, identifiers.steam, identifiers.discord, identifiers.ip, identifiers.xbl, identifiers.live, tokens_json})
end

return {
    savePlayer = savePlayer,
    playerExist = playerExist
}