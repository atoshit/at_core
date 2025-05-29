--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

AddEventHandler('onResourceStart', function(resource)
    if resource == at.resource then
        local LOG <const> = at.LoadModule('discord')

        local WEBHOOK <const> = GetConvar('at_core:webhooks:resourceStart', '')

        collectgarbage('collect')

        local FIELDS <const> = {
            {name = "Resource Name", value = at.resource, inline = true},
            {name = "Resource Version", value = at.version, inline = true},
            {name = "Resource Description", value = at.desc, inline = false},
            {name = "Debug", value = at.debug, inline = true},
            {name = "Lang",  value = at.lang, inline = true},
            {name = "Ram (bytes)", value = collectgarbage('count') .. 'B', inline = true},
            {name = "Github Repository", value = at.repository, inline = false}
        }

        LOG(WEBHOOK, "Resource Starting", "The resource `" .. at.resource .. "` has been started.", "at_core", FIELDS, { text = "At Core", icon_url = at.logo }, at.banner, at.logo)
    end
end)
