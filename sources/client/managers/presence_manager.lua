CreateThread(function()
    local discord = at.LoadModule('discord')

    local APP_ID <const> = GetConvar("at_core:presence:appId", "887588419035271169")
    local ASSET <const> = GetConvar("at_core:presence:asset", "logo")
    local ASSET_TEXT <const> = GetConvar("at_core:presence:assetText", "At Core by atoshi")
    local BUTTONS <const> = json.decode(GetConvar("at_core:presence:buttons", ""))
    local BUTTONS_URL <const> = json.decode(GetConvar("at_core:presence:buttonsUrl", ""))
    local PRESENCE_MESSAGE <const> = "Atoshi Best Developer"

    local presence = discord.start(APP_ID, ASSET, ASSET_TEXT, BUTTONS, BUTTONS_URL, PRESENCE_MESSAGE)

    presence:startLoop()
end)