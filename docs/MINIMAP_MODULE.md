# Minimap modules functions & usage 

## Client

### display
- **Description:** Display radar
- **Parameters:**
  - `state` (boolean) (optionnal): Show or hide the radar
- **Usage:**
  ```lua
    local minimap <const> = at.loadModule("minimap")

    minimap.display()

    or 

    minimap.display(true)
    minimap.display(false)
  ```