--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local GET_CONVAR <const> = GetConvar
local GET_CONVAR_INT <const> = GetConvarInt

---Update the presence
---@param self table: The object
local function update(self)
    SetDiscordAppId(self.id)
    SetDiscordRichPresenceAsset(self.asset)
    SetDiscordRichPresenceAssetText(self.assetText)
    SetRichPresence(self.presenceMessage)

    if not self.buttons or not next(self.buttons) then
        SetDiscordRichPresenceAction(0, self.buttons[1], self.buttonsUrl[1])

        if #self.buttons > 1 then
            SetDiscordRichPresenceAction(1, self.buttons[2], self.buttonsUrl[2])
        end
    end
end

---Start the loop
---@param self table: The object
local function startLoop(self)
    CreateThread(function ()
        while true do 
            self:update(self)
            Wait(1000 * 30)
        end
    end)
end

---Start the presence
---@param appId string: The application ID
---@param assets table: The assets data
---@param buttons table: The buttons data
---@return table: Object
local function startPresence(appId, asset, assetText, buttons, buttonsUrl, presenceMessage)
    if not appId or not asset or not assetText then
        return at.Debug("(func: startPresence) Missing arguments", "error")
    end

    local self = {}

    self.id = appId
    self.asset = asset
    self.assetText = assetText
    self.buttons = buttons
    self.buttonsUrl = buttonsUrl
    self.presenceMessage = presenceMessage or "Atoshi Best Develoepr"

    self.startLoop = startLoop
    self.update = update

    return self
end

return {
    start = startPresence,
}