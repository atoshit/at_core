local RefSetPlayerModel <const> = SetPlayerModel

SetPlayerModel = setmetatable({}, {
    __call = function(self, playerId, model)
        RefSetPlayerModel(playerId, model)
        return SetModelAsNoLongerNeeded(model)
    end
})