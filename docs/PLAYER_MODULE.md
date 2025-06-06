# Model modules functions & usage 

## Server-side

### Create Player 
- **Description:** Create a new player object
- **Parameters:**
  - `id` (number): Player ID
  - `data` (table): Data table
- **Metamethods:**
  - `save` (function): Save a player in database
- **Metadatas:**
  - `rank` (string): Player Rank
- **Return:** Player Obj
- **Usage:**
  ```lua
  local player <const> = at.loadModule("player")

  local player = player(1, {
    rank = "admin"
  })

  print(player.rank)
  player:save()
  ```