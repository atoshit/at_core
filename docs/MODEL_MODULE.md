# Model modules functions & usage 

## Client-side

### request
- **Description:** Loaded a model
- **Parameters:**
  - `model` (string): Model name
- **Return:** `true` if success or false
- **Usage:**
  ```lua
  local model <const> = at.loadModule("model")

  model.request("mp_m_freemode_01")
  ```

### setToPlayer
- **Description:** Set a player model
- **Parameters:**
  - `model` (string): Model name
  - `player` (number) : Local player id ( PlayerId() )
- **Usage:**
  ```lua
  local model <const> = at.loadModule("model")

  local player = PlayerId()

  model.setToPlayer("mp_m_freemode_01", player)
  ```