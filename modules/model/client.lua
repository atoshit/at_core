--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

--- Loaded a model
---@param model string: Model to load
---@return boolean: Model loaded?
---@private
local function request(model)
    if not model or type(model) ~= "string" then
        at.Debug("(func: request) Invalid type of model")
        return false
    end

    if not IsModelInCdimage(model) or not IsModelValid(model) then
        at.Debug("(func: request) Model doesn't exist")
        return false
    end

    RequestModel(model)

    repeat
        Wait(200)
    until HasModelLoaded(model)

    at.Debug("(func: request) Model loaded : " .. model)
    return true
end

--- Set a model to a player
---@param model string: Model to set
---@param player number: Player to set
---@return boolean: Model set?
---@private
local function setToPlayer(model, player)
    if not model or type(model) ~= "string" then
        at.Debug("(func: setToPlayer) Invalid type of model")
        return false
    end

    if not player or type(player) ~= "number" then
        at.Debug("(func: setToPlayer) Invalid type of player")
        return false
    end

    if not request(model) then
        at.Debug("(func: setToPlayer) Model not loaded")
        return false
    end

    SetPlayerModel(player, model)
    SetModelAsNoLongerNeeded(model)

    at.Debug("(func: setToPlayer) Model " .. model .." set to player ".. player)
    return true
end

return {
    request = request,
    setToPlayer = setToPlayer,
}