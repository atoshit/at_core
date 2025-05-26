# Entity modules functions & usage 

## Client-side

### freeze
- **Description:** Freeze an entity
- **Parameters:**
  - `entity` (number): Entity objet
  - `state` (number) (optionnal): Disable or enable freeze (if the parameter has not been set it gets the freeze state of the player and sets the opposite)
- **Usage:**
  ```lua
  local entity <const> = at.loadModule("entity")

  local playerPed = PlayerPedId()

  entity.freeze(playerPed, true)
  ```

### setHeading
- **Description:** Set a player heading
- **Parameters:**
  - `entity` (number): Entity objet
  - `heading` (number) : New heading
- **Usage:**
  ```lua
  local entity <const> = at.loadModule("entity")

  local playerPed = PlayerPedId()

  entity.setHeading(playerPed, 55.0)
  ```

### setCoords
- **Description:** Teleport a player to a position
- **Parameters:**
  - `entity` (number): Entity objet
  - `coords` (table) : New coordinate to set
  - `heading` (number) (optionnal): New heading after teleport
  - `deadFlag` (boolean) : Whether to disable physics for dead peds, too, and not just living peds
  - `ragdollFlag` (boolean) : A special flag used for ragdolling peds.
  - `clearArea` (boolean) : Whether to clear any entities in the target area.
- **Usage:**
  ```lua
  local entity <const> = at.loadModule("entity")

  local playerPed = PlayerPedId()
  local newCoords = vec3(254.4, 543.1, -732.4)

  -- With heading
  entity.setCoords(playerPed, newCoords, 55.0, false, false, true)

  -- No Heading
  entity.setCoords(playerPed, newCoords, nil, false, false, true)
  ```