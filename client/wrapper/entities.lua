local _SetPlayerModel <const> = SetPlayerModel
local _SetEntityCoords <const> = SetEntityCoords

SetPlayerModel = setmetatable({}, {
    __call = function(self, player, model)
        if not player or not model then
            return error('Invalid arguments')
        end

        if not IsModelValid(model) or not IsModelInCdimage(model) then
            return error('Invalid model')
        end

        if not HasModelLoaded(model) then
            RequestModel(model)
        end

        while not HasModelLoaded(model) do
            Wait(0)
        end

        return _SetPlayerModel(player, model)
    end
})


SetEntityCoords = setmetatable({}, {
    __call = function(self, entity, x, y, z, alive, deadFlag, ragdollFlag, clearArea)
        local coords = vector3(x, y, z)
        local entity = entity
        local alive = alive or false
        local deadFlag = deadFlag or false
        local ragdollFlag = ragdollFlag or false
        local clearArea = clearArea or false

        --if not DoesEntityExist(entity) then
        --    return error('Entity does not exist')
        --end

        if not coords then
            return error('Coordinates are required')
        end

        return _SetEntityCoords(entity, coords.x, coords.y, coords.z, alive, deadFlag, ragdollFlag, clearArea)
    end
})
