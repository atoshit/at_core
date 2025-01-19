local mt_private = {
    __metatable = 'private',
    __ext = 0,
    __pack = function() return '' end,
}

---@class ClassOptions
---@field private? table Table de données privées
---@field export? string Nom d'export de la classe
---@field init? function Fonction d'initialisation

---@param obj ClassOptions
---@return table
local function NewInstance(self, obj)
    obj = obj or {}
    
    if obj.private or self.private then
        obj.private = obj.private or {}
        setmetatable(obj.private, mt_private)
    end

    setmetatable(obj, self)

    if self.init then 
        obj:init() 
    end

    if obj.export then
        self.__exports[obj.export] = obj
    end

    return obj
end

---@class ClassDefinition
---@field __name string Nom de la classe
---@field __parent? table Classe parente
---@field __exports table<string, table> Table des instances exportées
---@field __exportMethods table<string, boolean> Table des méthodes exportées
---@field new function Fonction de création d'instance

---@param name string Nom de la classe
---@param parent? table Classe parente
---@param exportable? boolean Permet l'export des méthodes
---@return ClassDefinition
local function NewClass(name, parent, exportable)
    if not name then 
        return error('Class name is required')
    end

    local class = {
        __name = name,
        __parent = parent,
        __exports = {},
        __exportMethods = {},
        new = NewInstance,
    }

    class.__index = class

    if parent then
        if parent.private then
            class.private = table.clone(parent.private)
        end
    end

    if parent or exportable then
        if exportable then
            setmetatable(class, {
                __index = parent,
                __newindex = function(self, key, value)
                    rawset(self, key, value)
                    if type(value) == 'function' then
                        self.__exportMethods[key] = true
                    end
                end
            })

            core[name] = function(method, ...)
                local export = class.__exports[name]
                if export and export[method] then
                    return export[method](export, ...)
                end
                error(('Invalid export call: %s.%s'):format(name, method or 'nil'))
                return nil
            end
        elseif parent then
            setmetatable(class, {
                __index = parent
            })
        end
    end

    return class
end

core.Class = NewClass

-- Exemples d'utilisation
--[[
-- 1. Classe simple
local Animal = core.Class('Animal')

function Animal:init()
    self.alive = true
end

function Animal:makeSound()
    return 'Some sound'
end

local dog = Animal:new({
    name = 'Rex',
    private = {
        age = 5
    }
})

-- 2. Héritage
local Dog = core.Class('Dog', Animal)

function Dog:init()
    Animal.init(self) -- Appel du constructeur parent
    self.species = 'dog'
end

function Dog:makeSound()
    return 'Woof!'
end

local myDog = Dog:new({
    name = 'Max',
    private = {
        age = 3
    }
})

-- 3. Classe exportable
local Vehicle = core.Class('Vehicle', nil, true)

function Vehicle:init()
    self.speed = 0
end

function Vehicle:accelerate(amount)
    self.speed = self.speed + amount
    return self.speed
end

local car = Vehicle:new({
    export = 'mainVehicle',
    model = 'Tesla'
})

-- Utilisation de l'export
local speed = core.Vehicle('accelerate', 10)

-- 4. Héritage avec export
local Car = core.Class('Car', Vehicle, true)

function Car:init()
    Vehicle.init(self)
    self.wheels = 4
end

function Car:honk()
    return 'Beep!'
end

local tesla = Car:new({
    export = 'tesla',
    model = 'Model S'
})

-- 5. Utilisation des données privées
local Player = core.Class('Player')

function Player:init()
    self.private.health = 100
    self.private.armor = 0
end

function Player:damage(amount)
    self.private.health = math.max(0, self.private.health - amount)
    return self.private.health
end

local player = Player:new({
    private = {},
    name = 'John'
})
]]
