AddEventHandler('onResourceStop', function(resource)
    if resource == at.resource then
        local LOG <const> = at.LoadModule('discord')

        local WEBHOOK <const> = GetConvar('at_core:webhooks:resourceStop', '')

        collectgarbage('collect')

        local FIELDS <const> = {
            { name = "Resource Name",        value = at.resource,                    inline = true },
            { name = "Resource Version",     value = at.version,                     inline = true },
            { name = "Resource Description", value = at.desc,                        inline = false },
            { name = "Debug",                value = at.debug,                       inline = true },
            { name = "Lang",                 value = at.lang,                        inline = true },
            { name = "Ram (bytes)",          value = collectgarbage('count') .. 'B', inline = true },
            { name = "Repository",           value = at.repository,                  inline = false }
        }

        LOG(WEBHOOK, "Resource Stopping", "The resource `" .. at.resource .. "` has been stop.", "at_core", FIELDS,
            { text = "At Core", icon_url = at.logo }, at.banner, at.logo)
    end
end)
