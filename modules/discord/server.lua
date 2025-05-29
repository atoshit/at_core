--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local COLORS <const> = {
    ['default'] = 0,
    ['aqua'] = 1752220,
    ['darkaqua'] = 1146986,
    ['green'] = 5763719,
    ['darkgreen'] = 2067276,
    ['blue'] = 3447003,
    ['darkblue'] = 2123412,
    ['purple'] = 10181046,
    ['darkpurple'] = 7419530,
    ['luminousvividpink'] = 15277667,
    ['darkvividpink'] = 11342935,
    ['gold'] = 15844367,
    ['darkgold'] = 12745742,
    ['orange'] = 15105570,
    ['darkorange'] = 11027200,
    ['red'] = 15548997,
    ['darkred'] = 10038562,
    ['grey'] = 9807270,
    ['darkgrey'] = 9936031,
    ['darkergrey'] = 8359053,
    ['lightgrey'] = 12370112,
    ['navy'] = 3426654,
    ['darknavy'] = 2899536,
    ['yellow'] = 16776960,
    ['at_core'] = 65455
}

---Send a log to a webhook
---@param webhook string: The webhook url
---@param title string: The title of the embed
---@param description string: The description of the embed
---@param color string: The color of the embed ("red", yellow ...)
---@param fields table: The fields of the embed ({title = "title", value = "value", inline = true})
---@param footer table: The footer of the embed
---@param image string: The image of the embed
---@param thumbnail string: The thumbnail of the embed
---@private
local function send(webkook, title, description, color, fields, footer, image, thumbnail)
    if not webkook then return warn("(func: send) No webhook provided") end
    
    local embed = {
        ["color"] = (COLORS[color] or COLORS["at_core"]),
        ["title"] = (title or "At Core Logs"),
        ["description"] = (description or ""),
        ["thumbnail"] = {
            ["url"] = (thumbnail or at.logo or ""),
        },
        ["fields"] = (fields or {}),
        ["footer"] = {
            ["text"] = (footer.text or "Atoshi Best Developer"),
            ["icon_url"] = (footer.icon_url or ""),
        },
        ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%S'),
        ["image"] = {
            ["url"] = (image or ""),
        }
    }
    return PerformHttpRequest(webkook, function(err, text, headers) end, 'POST', json.encode({ ["username"] = at.resource, ["avatar_url"] = at.logo, embeds = { embed } }), { ['Content-Type'] = 'application/json' })
end

return send