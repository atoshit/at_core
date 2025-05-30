--[[
    https://github.com/atoshit/at_core

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Atoshi <https://github.com/atoshit>
]]

local function generateToken()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local length = 50
    local result = ""
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        result = result .. string.sub(chars, randomIndex, randomIndex)
    end
    return result
end

---@param str string
---@return string
local function formatByte(str)
    local binaryString = ""
    for i = 1, #str do
        local byte <const> = str:byte(i)
        local bits = {}
        for j = 7, 0, -1 do
            bits[#bits + 1] = (byte >> j) & 1
        end
        binaryString = binaryString .. table.concat(bits)
    end
    return binaryString
end

return {
    generateToken = generateToken,
    formatByte = formatByte
}