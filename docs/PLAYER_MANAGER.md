# Player manager functions & usage 

## Server-side

### Create Player (global)
- **Description:** Create a new player object
- **Parameters:**
  - `id` (number): Player ID
  - `data` (table): Data table
- **Return:** Player Obj
- **Usage:**
  ```lua
  at.CreatePlayer(1, {
    rank = "admin"
  })
  ```

### Get Player (global)
- **Description:** Get a player object
- **Parameters:**
  - `id` (number): Player ID
- **Return:** Player Obj
- **Usage:**
  ```lua
    local player = at.GetPlayer(1)

    print(player.rank)
    player:save()
  ```