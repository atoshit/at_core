--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local modules_loaded = {}

local RESOURCE_NAME <const> = GetCurrentResourceName()
local CURRENT_ENV <const> = (IsDuplicityVersion() and 'server') or 'client'
local LANG <const> = GetConvar('at_core:lang', 'en')
local DEBUG <const> = GetConvarInt('at_core:debug', 0)
local VERSION <const> = GetResourceMetadata(RESOURCE_NAME, 'version', 0)
local AT_METADATA <const> = {
    env = CURRENT_ENV,
    lang = LANG,
    debug = DEBUG,
    version = VERSION,
    resource = RESOURCE_NAME,
    modules_loaded = modules_loaded,
    require = function(p)
        if modules_loaded[p] then
            return modules_loaded[p]
        end

        local module_path = ("%s.lua"):format(p)
        local module_file = LoadResourceFile(RESOURCE_NAME, module_path)

        if not module_file then
            warn(('Module not found: %s'):format(module_path))
            return
        end

        modules_loaded[p] = load(module_file)()

        if modules_loaded[p] then
            return modules_loaded[p]
        end

        error(('Failed to load module: %s'):format(module_path))
    end
}

--- Main Object
---@class AtCore
---@field env string<'server'|'client'>
---@field lang string<'example: fr'>
---@field debug number<0|1>
---@field version string<'example: 1.0.0'>
---@field resource string<'at_core'>
local at = {}

setmetatable(at, {
    __index = AT_METADATA,
    __newindex = function(s, k, v)
        rawset(s, k, v)
    end,
    __call = function(s)
        s.init = true
        print('[^5at:core^7] Initializing...')
        return s.init
    end
})

_ENV.at = at

if at() then
    print('[^2at:core^7] Initialized')
end