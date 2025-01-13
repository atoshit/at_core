---@class Character
---@field private table Données privées du personnage
---@field id number ID unique du personnage
---@field license string License du propriétaire
---@field firstname string Prénom
---@field lastname string Nom
---@field dateofbirth string Date de naissance
---@field gender string Genre
---@field job string Métier
---@field crew string? Crew/Gang
---@field position vector3 Dernière position
---@field skin table Apparence du personnage
---@field inventory table Inventaire
local Character = core.Class('Character', nil, true)

function Character:init()
    self.private = {
        created_at = os.time(),
        last_played = os.time(),
        health = 200,
        armor = 0,
        is_dead = false,
        jail_time = 0,
        bank_money = 0,
        dirty_money = 0,
    }

    self.id = 0
    self.license = ""
    self.firstname = ""
    self.lastname = ""
    self.dateofbirth = ""
    self.gender = "m"
    self.job = "unemployed"
    self.crew = nil
    self.position = vector3(0, 0, 0)
    self.skin = {}
    self.inventory = {}
end

---Charge les données du personnage depuis la base de données
---@return boolean
function Character:loadData()
    if not self.id then return false end

    local result = core.callback.Await('oxmysql', 0, 'single', [[
        SELECT * FROM characters WHERE id = ? LIMIT 1
    ]], {self.id})

    if result then
        self.license = result.license
        self.firstname = result.firstname
        self.lastname = result.lastname
        self.dateofbirth = result.dateofbirth
        self.gender = result.gender
        self.job = result.job
        self.crew = result.crew
        self.position = json.decode(result.position)
        self.skin = json.decode(result.skin)
        self.inventory = json.decode(result.inventory)

        self.private.health = result.health
        self.private.armor = result.armor
        self.private.is_dead = result.is_dead == 1
        self.private.jail_time = result.jail_time
        self.private.bank_money = result.bank_money
        self.private.dirty_money = result.dirty_money
        self.private.created_at = result.created_at
        self.private.last_played = result.last_played

        return true
    end
    return false
end

---Sauvegarde les données du personnage
---@return boolean
function Character:saveData()
    return core.callback.Await('oxmysql', 0, 'execute', [[
        UPDATE characters SET
            firstname = ?, lastname = ?, position = ?, skin = ?,
            inventory = ?, health = ?, armor = ?, is_dead = ?,
            jail_time = ?, bank_money = ?, dirty_money = ?,
            job = ?, crew = ?, last_played = ?
        WHERE id = ?
    ]], {
        self.firstname,
        self.lastname,
        json.encode(self.position),
        json.encode(self.skin),
        json.encode(self.inventory),
        self.private.health,
        self.private.armor,
        self.private.is_dead and 1 or 0,
        self.private.jail_time,
        self.private.bank_money,
        self.private.dirty_money,
        self.job,
        self.crew,
        os.time(),
        self.id
    }) ~= nil
end

---Récupère un personnage par son ID
---@param id number
---@return Character?
function Character.get(id)
    local char = Character:new({id = id})
    return char:loadData() and char or nil
end

---Met à jour le métier du personnage
---@param job string
---@return boolean
function Character:setJob(job)
    self.job = job
    return self:saveData()
end

---Met à jour le crew du personnage
---@param crew string?
---@return boolean
function Character:setCrew(crew)
    self.crew = crew
    return self:saveData()
end

---Met à jour l'apparence du personnage
---@param skin table
---@return boolean
function Character:setSkin(skin)
    self.skin = skin
    return self:saveData()
end

---Met à jour l'inventaire du personnage
---@param inventory table
---@return boolean
function Character:setInventory(inventory)
    self.inventory = inventory
    return self:saveData()
end

---Ajoute de l'argent au personnage
---@param amount number
---@param type "bank"|"dirty"
---@return boolean
function Character:addMoney(amount, type)
    if type == "bank" then
        self.private.bank_money = self.private.bank_money + amount
    else
        self.private.dirty_money = self.private.dirty_money + amount
    end
    return self:saveData()
end

---Retire de l'argent au personnage
---@param amount number
---@param type "bank"|"dirty"
---@return boolean
function Character:removeMoney(amount, type)
    if type == "bank" then
        if self.private.bank_money < amount then return false end
        self.private.bank_money = self.private.bank_money - amount
    else
        if self.private.dirty_money < amount then return false end
        self.private.dirty_money = self.private.dirty_money - amount
    end
    return self:saveData()
end

---Met à jour la position du personnage
---@param pos vector3
function Character:updatePosition(pos)
    self.position = pos
end

return Character
