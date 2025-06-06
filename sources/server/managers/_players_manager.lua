at.players = {}

local PLAYER <const> = at.LoadModule('player')

--- Create a new player
---@param id number
---@param data table
function at.CreatePlayer(id, data)
    if not at.players[id] then
        at.players[id] = PLAYER(id, data)
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

--- Destroy a player object
---@param id number
---@return boolean
function at.DestroyPlayer(id)
    local player = at.GetPlayer(id)

    if not player then return false end

    player:save()
    at.players[id] = nil

    return true
end