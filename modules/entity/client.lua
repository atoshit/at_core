--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local SET_ENT_HEADING <const> = SetEntityHeading
local DOES_ENT_EXIST <const> = DoesEntityExist
local FREEZE_ENT_POS <const> = FreezeEntityPosition

--- Freeze an entity
---@param entity number: Entity objet
---@param state boolean?: True or false (optionnal)
---@return function
---@private
local function freeze(entity, state)
    if not entity then return warn("(func: freeze) param entity not found") end

    if not DOES_ENT_EXIST(entity) then 
        return warn("(func: freeze) Entity does exist")
    end

    if state ~= nil or type(state) == "boolean" then
        if state then
            at.Debug("(func: freeze) Changing the entity's freeze state: ".. entity.. " [ -> true ]")
            return FREEZE_ENT_POS(entity, state)
        end

        at.Debug("(func: freeze) Changing the entity's freeze state: " .. entity .. " [ -> false ]")
        return FREEZE_ENT_POS(entity, state)
    end

    local entity_freeze = IsEntityPositionFrozen(entity)
    if not entity_freeze then
        at.Debug("(func: freeze) Changing the entity's freeze state: " .. entity .. " [ false -> true ]")
        return FREEZE_ENT_POS(entity, true)
    end

    at.Debug("(func: freeze) Changing the entity's freeze state: " .. entity .. " [ true -> false ]")
    return FREEZE_ENT_POS(entity, false)
end

--- Set a player heading
---@param entity number: Entity objet
---@param heading number: New heading
---@return function
---@private
local function setHeading(entity, heading)
    if not entity then return warn("(func: setHeading) param entity not found") end
    if not heading then return warn("(func: setHeading) param heading not found") end

    if not DOES_ENT_EXIST(entity) then 
        return warn("(func: setHeading) Entity does exist")
    end

    at.Debug("(func: setHeading) Changing the entity's heading : " .. heading)
    return SET_ENT_HEADING(entity, heading)
end

--- Teleport a player to a position
---@param entity number: Entity objet
---@param coords table: New coords
---@param heading number?: New heading after teleport (optionnal)
---@param deadFlag boolean: Whether to disable physics for dead peds, too, and not just living peds
---@param ragdollFlag boolean: A special flag used for ragdolling peds.
---@param clearArea boolean: Whether to clear any entities in the target area.
---@return function
---@private
local function setCoords(entity, coords, heading, deadFlag, ragdollFlag, clearArea)
    if not entity then return warn("(func: setCoords) param entity not found") end
    if not coords then return warn("(func: setCoords) param coords not found") end

    if not DOES_ENT_EXIST(entity) then 
        return warn("(func: setCoords) Entity does exist")
    end

    if heading and type(heading) == "number" then
        SET_ENT_HEADING(entity, heading)
    end

    at.Debug("(func: setCoords) Changing the entity's position : " .. coords.x, coords.y, coords.z)
    return SetEntityCoords(entity, coords.x, coords.y, coords.z, false, deadFlag, ragdollFlag, clearArea)
end

return {
    freeze = freeze,
    setCoords = setCoords,
    setHeading = setHeading
}