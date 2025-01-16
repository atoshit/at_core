local AT_CORE <const>, SERVICE <const> = "at_core", (IsDuplicityVersion() and "server") or "client"
local GetResourceMetadata <const>, GetCurrentResourceName <const>, Await <const> = GetResourceMetadata, GetCurrentResourceName, Citizen.Await

---@class Debug
---@field level table<string, number>
---@field color table<string, string>
local DEBUG <const> = {
    level = {
        ERROR = 0,
        WARN = 1,
        INFO = 2,
        DEBUG = 3,
    },
    color = {
        ERROR = "^1",
        WARN = "^3",
        INFO = "^5",
        DEBUG = "^2",
        RESET = "^7",
    }
}

---@param name string Convar name
---@param default any Default value
---@param type "string" | "number" | "boolean" | "float"
---@return any
local function Convar(name, default, type)
    if not name then return default end
    
    local GetConvar <const> = GetConvar
    local GetConvarInt <const> = GetConvarInt
    local GetConvarBool <const> = GetConvarBool
    local GetConvarFloat <const> = GetConvarFloat

    local result
    if type == "string" then
        result = GetConvar(name, tostring(default))
    elseif type == "number" then
        result = GetConvarInt(name, tonumber(default) or 0)
    elseif type == "boolean" then
        result = GetConvarBool(name, default)
    elseif type == "float" then
        result = GetConvarFloat(name, tonumber(default) or 0.0)
    end

    return result or default
end

---@param type string ERROR | WARN | INFO | DEBUG
---@param message string|number
---@return nil
local function Debug(type, message)
    if not DEBUG.level[type] or not message then return end
    
    if DEBUG.level[type] <= Convar("at:debug", 3, "number") then
        local prefix = string.format("%s[%s]%s", 
            DEBUG.color[type],
            SERVICE == "server" and os.date("%Y-%m-%d %H:%M:%S") or GetCurrentResourceName(),
            DEBUG.color.RESET
        )
        print(string.format("%s %s", prefix, message))
    end
end

---@param value any
---@param expected string
---@return boolean
local function IsType(value, expected)
    return type(value) == expected
end

---@param resource string
---@return boolean
local function IsResourceStarted(resource)
    return GetResourceState(resource) == "started"
end

---@type table<string, any>
local METADATA <const> = {
    name = AT_CORE,
    label = Convar("at:label", "Atoshi Core", "string"),
    service = SERVICE,
    env = GetCurrentResourceName(),
    author = GetResourceMetadata(GetCurrentResourceName(), "author", 0),
    description = GetResourceMetadata(GetCurrentResourceName(), "description", 0),
    version = GetResourceMetadata(GetCurrentResourceName(), "version", 0),
    exportsCount = 0,
    build = Convar("at:gamebuild", 0, "number"),
    Await = Await,
}

local function Initialize()

    ---@class Core
    ---@field name string
    ---@field label string
    ---@field service string
    ---@field env string
    ---@field author string
    ---@field description string
    ---@field version string
    ---@field build number
    ---@field exportsCount number
    ---@field utils table
    ---@field events table
    ---@field server table?
    ---@field client table?
    ---@field mysql table?
    local core = setmetatable({}, {
        __index = METADATA,
        __newindex = function(self, name, value)
            if type(value) == 'function' then
                exports(name, value)
                METADATA.exportsCount += 1
            end
            rawset(self, name, value)
        end,
        __tostring = function(self)
            return string.format("AT Core [%s] [%s]", self.version, self.service)
        end
    })

    _ENV.core = core

    if SERVICE == "server" then core.server = {} end
    if SERVICE == "client" then core.client = {
        --LoadModel = LoadModel,
    } end
    if IsResourceStarted("oxmysql") then core.mysql = {} end

    core.utils = {
        Debug = Debug,
        Convar = Convar,
        IsType = IsType,
        IsResourceStarted = IsResourceStarted
    }

    local REQUIRED_FIELDS <const> = {'service', 'env', 'name', 'author', 'description', 'version'}
    for _, field in ipairs(REQUIRED_FIELDS) do
        if not core[field] then
            Debug('ERROR', string.format('Missing required field: %s', field))
            return false
        end
    end

    Debug("INFO", string.format("Core initialized [%s] [%s] [Build: %s]", core.version, core.service, core.build))
    return true
end

if not Initialize() then
    error('Failed to initialize AT Core')
end