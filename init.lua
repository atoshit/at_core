--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local GET_CONVAR <const> = GetConvar
local GET_RESOURCE_METADATA <const> = GetResourceMetadata
local RESOURCE_NAME <const> = GetCurrentResourceName()
local CURRENT_ENV <const> = (IsDuplicityVersion() and 'server') or 'client'
local LANG <const> = GET_CONVAR('at_core:lang', 'en')
local LOGO <const> = GET_CONVAR('at_core:logo', 'https://media.discordapp.net/attachments/1376355947097755698/1376355976537571419/at_core_logo512.png?ex=6837a9e4&is=68365864&hm=abefc837b7bdc39a49549bec189a199b2428d050405edadff95edc169f779134&=&format=webp&quality=lossless')
local BANNER <const> = GET_CONVAR('at_core:banner', 'https://media.discordapp.net/attachments/1376355947097755698/1376355975929532517/at_core_banner_with_outline.png?ex=6838fb64&is=6837a9e4&hm=f83ddda4c966bb05c76d8527d78b08393f8c95fa9306abfcb7753f527956c421&=&format=webp&quality=lossless&width=1768&height=292')
local DEBUG <const> = GetConvarInt('at_core:debug', 0)
local VERSION <const> = GET_RESOURCE_METADATA(RESOURCE_NAME, 'version', 0)
local DESC <const> = GET_RESOURCE_METADATA(RESOURCE_NAME, 'description', 0)
local REPO <const> = GET_RESOURCE_METADATA(RESOURCE_NAME, 'repository', 0)

--- Log a debug message
---@param msg string: Message to print
---@return any
---@private
local function debug(msg)
    if DEBUG == 0 then return end

    if not msg or type(msg) ~= 'string' then return end

    if CURRENT_ENV == 'server' then
        local timestamp = os.date('%X')
        return print("[^6at_core:debug^7] [^6" .. timestamp .. "^7] " .. msg)
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
        return print("[^4at_core:info^7] [^4" .. timestamp .. "^7] " .. msg)
    end

    return print("[^4at_core:info^7] " .. msg)
end

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

    debug("(func: loadModule) Load module: ".. module)
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

    debug("(func: loadLocale) Load language: " .. lang)
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

local function getModules()
    return modules
end

local function getLocales()
    return locales
end

local AT_METADATA <const> = {
    env = CURRENT_ENV,
    lang = LANG,
    debug = DEBUG,
    version = VERSION,
    resource = RESOURCE_NAME,
    desc = DESC,
    repository = REPO,
    logo = LOGO,
    banner = BANNER,
    GetModules = getModules,
    GetLocales = getLocales,
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
        debug(('(metamethod: __newindex for AtCore obj) New key: %s (%s)'):format(k, type(v)))
    end,
    __call = function(s)
        if s.env and s.lang and s.resource and s.version and s.debug and s.LoadModule and s.LoadLocale and s.UnloadModule and s.IsResourceStarted then
            return info(('(metamethod: __call for AtCore obj) AtCore is initialized\n- Version: ^4%s^7\n- Env: ^4%s^7\n- Resource: ^4%s^7\n- Debug: ^4%s^7\n- Lang: ^4%s^7'):format(s.version, s.env, s.resource, s.debug, s.lang))
        end

        return warn('(metamethod: __call for AtCore obj) AtCore was not initialized correctly')
    end
}

setmetatable(at, MT)

_ENV.at = at

at()