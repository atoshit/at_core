local AT_CORE <const>, SERVICE <const> = "at_core", (IsDuplicityVersion() and "server") or "client"
local GetResourceMetadata <const>, GetCurrentResourceName <const> = GetResourceMetadata, GetCurrentResourceName

---@param name string Convar name
---@param default string Default value
---@param type string string | number | boolean | float | nil
---@return string | number | boolean | float | nil
local function Convar(name, default, type)
    local GetConvar <const> = GetConvar
    local GetConvarInt <const> = GetConvarInt
    local GetConvarBool <const> = GetConvarBool
    local GetConvarFloat <const> = GetConvarFloat

    if type == "string" or nil then
        return GetConvar(name, default) or "Convar not found"
    elseif type == "number" then
        return GetConvarInt(name, default) or "Convar not found"
    elseif type == "boolean" then
        return GetConvarBool(name, default) or "Convar not found"
    elseif type == "float" then
        return GetConvarFloat(name, default) or "Convar not found"
    end
end

---@type table<string, any>
---@field level table<string, number>
---@field color table<string, string>
local DEBUG <const> = {

    ---@type table<string, number>
    ---@field WARN number
    ---@field INFO number
    ---@field DEBUG number
    level = {
        WARN = 1,
        INFO = 2,
        DEBUG = 3,
    },
    
    ---@type table<string, string>
    ---@field WARN string
    ---@field INFO string
    ---@field DEBUG string
    ---@field RESET string
    color = {
        WARN = "^3",
        INFO = "^5",
        DEBUG = "^2",
        RESET = "^7",
    }
}

local function Debug(type, message)
    if DEBUG.level[type] <= Convar("at:debug", 3, "number") then
        if SERVICE == "server" then
            local date = os.date("%Y-%m-%d %H:%M:%S")

            print(string.format("%s[%s] %s%s", DEBUG.color[type], date, message, DEBUG.color.RESET))
        else
            print(string.format("%s[%s] %s%s", DEBUG.color[type], GetCurrentResourceName(), message, DEBUG.color.RESET))
        end
    end
end

---@type table<string, any>
---@field name string
---@field service string
---@field env string
---@field author string
---@field description string
---@field version string
---@field exportsCount number
local METADATA <const> = {
    name = AT_CORE, ---@type string
    label = Convar("at:label", "Atoshi Core", "string"), ---@type string
    service = SERVICE, ---@type string
    env = GetCurrentResourceName(), ---@type string
    author = GetResourceMetadata(GetCurrentResourceName(), "author", 0), ---@type string
    description = GetResourceMetadata(GetCurrentResourceName(), "description", 0), ---@type string
    version = GetResourceMetadata(GetCurrentResourceName(), "version", 0), ---@type string
    exportsCount = 0, ---@type number
    build = Convar("at:gamebuild", 0, "number"), ---@type number
}

local function Init()
    ---@type table<string, any> 
    ---@field __index table<string, any>
    ---@field __newindex function
    local core = setmetatable({}, {
        __index = METADATA,
    }, {
        __newindex = function(self, name, value)
            if type(value) == 'function' then
                exports(name, value)
    
                METADATA.exportsCount += 1
            end
    
            rawset(self, name, value)
        end
    })
    
    _ENV.core = core

    core.utils = {
        Debug = Debug,
        Convar = Convar,
    }

    if core and core.service and core.env and core.name and core.author and core.description and core.version then
        Debug("INFO", string.format("Core initialized [%s] [%s] [%s] [%s] [%s] [%s] [%s] [%s]", core.name, core.service, core.env, core.author, core.description, core.version, core.build, core.label))
    else
        error(string.format("Core initialization failed [%s] [%s] [%s] [%s] [%s] [%s] [%s] [%s]", core.name or "nil", core.service or "nil", core.env or "nil", core.author or "nil", core.description or "nil", core.version or "nil", core.build or "nil", core.label or "nil"))
    end
end

Init()