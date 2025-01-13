---@class Player
---@field private table Données privées du joueur
---@field source number Source du joueur
---@field name string Nom du joueur
---@field rank string Rang du joueur
---@field vip boolean Statut VIP
---@field tokens table Tokens du joueur
---@field identifiers table Identifiants du joueur
---@field characters table<number, number> Liste des IDs des personnages
local Player = core.Class('Player', nil, true)

Player.__instances = {} 

function Player:init()
    self.private = {
        discord = nil,
        ip = nil,
        steam = nil,
        license = nil,
        tokens = {},
        created_at = os.time(),
        last_connection = os.time(),
        banned = false,
        ban_reason = nil,
        whitelist = false,
    }

    self.source = self.source or 0
    self.name = "Unknown"
    self.rank = "user"
    self.vip = false
    self.tokens = {}
    self.identifiers = {}
    self.characters = {}

    if self.source > 0 then
        Player.__instances[self.source] = self
    end
end

---Charge les identifiants du joueur
---@private
function Player:loadIdentifiers()
    local identifiers = {}
    local playerTokens = {}

    for i = 0, GetNumPlayerTokens(self.source) - 1 do
        playerTokens[#playerTokens + 1] = GetPlayerToken(self.source, i)
    end
    self.tokens = playerTokens
    self.private.tokens = playerTokens

    for _, v in ipairs(GetPlayerIdentifiers(self.source)) do
        local idType, value = v:match("([^:]+):(.+)")
        identifiers[idType] = value

        if idType == "discord" then self.private.discord = value
        elseif idType == "steam" then self.private.steam = value
        elseif idType == "license" then self.private.license = value
        elseif idType == "ip" then self.private.ip = value
        end
    end
    
    self.identifiers = identifiers
    self.name = GetPlayerName(self.source)
end

---Charge les données du joueur depuis la base de données
---@return boolean
function Player:loadData()
    local license = self.private.license
    if not license then return false end

    local result = core.callback.Await('oxmysql', 0, 'single', [[
        SELECT * FROM players WHERE license = ? LIMIT 1
    ]], {license})

    if result then
        self.rank = result.rank
        self.vip = result.vip == 1
        self.private.whitelist = result.whitelist == 1
        self.private.banned = result.banned == 1
        self.private.ban_reason = result.ban_reason
        return true
    end

    local success = core.callback.Await('oxmysql', 0, 'insert', [[
        INSERT INTO players (license, name, discord, steam, ip, created_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ]], {
        license,
        self.name,
        self.private.discord,
        self.private.steam,
        self.private.ip,
        self.private.created_at
    })

    return success ~= nil
end

---Charge les personnages du joueur
---@return boolean
function Player:loadCharacters()
    local license = self.private.license
    if not license then return false end

    local characters = core.callback.Await('oxmysql', 0, 'execute', [[
        SELECT id FROM characters WHERE license = ?
    ]], {license})

    if characters then
        self.characters = {} 
        for _, char in ipairs(characters) do
            self.characters[#self.characters + 1] = char.id
        end
        return true
    end
    return false
end

---Récupère tous les personnages du joueur
---@return table<number, table>
function Player:getAllCharacters()
    local chars = {}
    for _, charId in ipairs(self.characters) do
        local char = core.Character:get(charId)
        if char then
            chars[#chars + 1] = char
        end
    end
    return chars
end

---Récupère un personnage spécifique du joueur
---@param charId number
---@return table?
function Player:getCharacter(charId)
    for _, id in ipairs(self.characters) do
        if id == charId then
            return core.Character:get(charId)
        end
    end
    return nil
end

---Crée un nouveau personnage
---@param data table
---@return number? characterId
function Player:createCharacter(data)
    local maxChars = 5 
    if #self.characters >= maxChars then
        return nil
    end

    data.license = self.private.license
    
    local char = core.Character:new(data)
    if char then
        self.characters[#self.characters + 1] = char.id
        
        if char:saveData() then
            return char.id
        end
    end
    return nil
end

---Supprime un personnage
---@param charId number
---@return boolean
function Player:deleteCharacter(charId)
    local found = false
    for i, id in ipairs(self.characters) do
        if id == charId then
            table.remove(self.characters, i)
            found = true
            break
        end
    end

    if not found then return false end

    return core.callback.Await('oxmysql', 0, 'execute', [[
        DELETE FROM characters WHERE id = ? AND license = ?
    ]], {charId, self.private.license}) ~= nil
end

---@param charId number
---@return boolean
function Player:ownsCharacter(charId)
    for _, id in ipairs(self.characters) do
        if id == charId then
            return true
        end
    end
    return false
end

---@return boolean
---@return string?
function Player:isBanned()
    return self.private.banned, self.private.ban_reason
end

---@param reason string
---@return boolean
function Player:ban(reason)
    self.private.banned = true
    self.private.ban_reason = reason

    return core.callback.Await('oxmysql', 0, 'execute', [[
        UPDATE players SET banned = 1, ban_reason = ? WHERE license = ?
    ]], {reason, self.private.license}) ~= nil
end

---@return boolean
function Player:unban()
    self.private.banned = false
    self.private.ban_reason = nil

    return core.callback.Await('oxmysql', 0, 'execute', [[
        UPDATE players SET banned = 0, ban_reason = NULL WHERE license = ?
    ]], {self.private.license}) ~= nil
end

---@param rank string
---@return boolean
function Player:setRank(rank)
    self.rank = rank
    return core.callback.Await('oxmysql', 0, 'execute', [[
        UPDATE players SET rank = ? WHERE license = ?
    ]], {rank, self.private.license}) ~= nil
end

---@param status boolean
---@return boolean
function Player:setVIP(status)
    self.vip = status
    return core.callback.Await('oxmysql', 0, 'execute', [[
        UPDATE players SET vip = ? WHERE license = ?
    ]], {status and 1 or 0, self.private.license}) ~= nil
end

---Récupère un joueur par sa source
---@param source number
---@return Player?
function Player.get(source)
    if Player.__instances[source] then
        return Player.__instances[source]
    end

    if GetPlayerPing(source) == 0 then
        return nil
    end

    local player = Player:new({source = source})
    if player:loadIdentifiers() and player:loadData() then
        player:loadCharacters()
        return player
    end

    return nil
end

---Supprime un joueur du cache
---@param source number
function Player.remove(source)
    Player.__instances[source] = nil
end

function Player:destroy()
    self:saveData()
    
    Player.__instances[self.source] = nil
end

return Player
