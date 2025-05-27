--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]


local RESOURCE_NAME <const> = GetCurrentResourceName()
local CURRENT_ENV <const> = (IsDuplicityVersion() and 'server') or 'client'
local LANG <const> = GetConvar('at_core:lang', 'en')
local DEBUG <const> = GetConvarInt('at_core:debug', 0)
local VERSION <const> = GetResourceMetadata(RESOURCE_NAME, 'version', 0)

--- Load a file
---@param p string : Path of the file to load
---@return any
---@private
local function loadFile(p)
    if not p then
        return warn('(func: loadFile) param p not found')
    end

    local module_path = ("%s.lua"):format(p)
    local module_file = LoadResourceFile(RESOURCE_NAME, module_path)

    if not module_file then
        return warn(('(func: loadFile) File not found: %s'):format(module_path))
    end

    local file = load(module_file)()

    if file then
        return file
    end

    return error(('(func: loadFile) Failed to load file: %s'):format(module_path))
end

local modules = {}

--- Load a module
---@param module string<'example: version'> : Module to load
---@return table|nil
---@private
local function loadModule(module)
    if not module then
        return warn('(func: loadModule) param module not found')
    end

    if modules[module] then
        return modules[module]
    end

    modules[module] = loadFile(('modules/%s/%s'):format(module, CURRENT_ENV))

    if not modules[module] then
        return warn(('(func: loadModule) Failed to load module: %s'):format(module))
    end

    return modules[module]
end

local locales = {}

--- Load a language
---@param lang string | nil : Language to load
---@return table|nil
---@private
local function loadLocale(lang)
    local language = (lang or LANG)

    print(language)

    if locales[language] then
        return locales[language]
    end

    locales[language] = loadFile(('locales/%s'):format(language))

    if not locales[language] then
        return warn('(func: loadLocale) Failed to load locale: ' .. language)
    end

    return locales[language]
end

---@param module string<'example: version'> : Module to unload
---@return boolean<'true'|'false'>
---@private
local function unloadModule(module)
    if not module then
        return warn('(func: unloadModule) param module not found')
    end

    if not modules[module] then
        return warn(('(func: unloadModule) Module not loaded: %s'):format(module))
    end

    modules[module] = nil

    collectgarbage('collect')

    return true
end

--- Check if a resource is started
---@param r string: Resource Name
---@return boolean<'true'|'false'>
---@private
local function isResourceStarted(r)
    return GetResourceState(r) == 'started'
end

--- Log a debug message
---@param msg string: Message to print
---@return any
---@private
local function debug(msg)
    if not DEBUG == 0 then return end

    if not msg or type(msg) ~= 'string' then return end

    if CURRENT_ENV == 'server' then
        local timestamp = os.date('%X')
        return print("[^6at_core:debug^7] [^6".. timestamp .. "^7] " .. msg)
    end

    return print("[^6at_core:debug^7] " .. msg)
end

--- Log a information message
---@param msg string: Message to print
---@return any
---@private
local function info(msg)
    if not msg or type(msg) ~= 'string' then return end

    if CURRENT_ENV == 'server' then
        local timestamp = os.date('%X')
        return print("[^4at_core:info^7] [^4".. timestamp .. "^7] " .. msg)
    end

    return print("[^4at_core:info^7] " .. msg)
end

local AT_METADATA <const> = {
    env = CURRENT_ENV,
    lang = LANG,
    debug = DEBUG,
    version = VERSION,
    resource = RESOURCE_NAME,
    modules = modules,
    locales = locales,
    LoadModule = loadModule,
    LoadLocale = loadLocale,
    UnloadModule = unloadModule,
    IsResourceStarted = isResourceStarted,
    Debug = debug,
    Info = info
}

--- Main Object
---@class AtCore
---@field env string<'server'|'client'>
---@field lang string<'example: fr'>
---@field debug number<0|1>
---@field version string<'example: 1.0.0'>
---@field resource string<'at_core'>
---@field modules table<{[string]: table}>
---@field locales table<{[string]: table}>
---@field LoadModule function
---@field LoadLocale function
---@field UnloadModule function
---@field IsResourceStarted function
---@field Debug function
---@field Info function 
local at = {}

local MT <const> = {
    __index = AT_METADATA,
    __newindex = function(s, k, v)
        rawset(s, k, v)
    end
}

setmetatable(at, MT)

_ENV.at = at