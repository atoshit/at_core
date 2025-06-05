local minimap_state = true

---@param state boolean
local function display(state)
    if not state then
        minimap_state = (not minimap_state)
        return DisplayRadar(minimap_state)
    end

    DisplayRadar(state)
end

return {
    display = display
}