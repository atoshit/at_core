local RefSetPlayerModel <const> = SetPlayerModel

SetPlayerModel = setmetatable({}, {
    __call = function(self, playerId, model)
        if not core.utils.LoadModel(model) then return end
        RefSetPlayerModel(playerId, model)
        return SetModelAsNoLongerNeeded(model)
    end
})