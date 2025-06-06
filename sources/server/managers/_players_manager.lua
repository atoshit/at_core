at.players = {}

local PLAYER <const> = at.LoadModule('player')

--- Create a new player
---@param id number
---@param data table
function at.CreatePlayer(id, data)
    if not at.players[id] then
        at.players[id] = PLAYER.create(id, data)
    end
end

--- Get a player
---@param id number
---@return player|boolean
function at.GetPlayer(id)
    if not at.players[id] then
        return false
    end

    return at.players[id]
end