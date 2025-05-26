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
local AT_METADATA <const> = {
    env = CURRENT_ENV,
    lang = LANG,
    debug = DEBUG,
    version = VERSION,
    resource = RESOURCE_NAME
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