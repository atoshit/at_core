# Callback modules functions & usage 

## Client-side

### register
- **Description:** Register a client callback
- **Parameters:**
  - `args` (table): All arguments
- **Usage:**
  ```lua
    local cb <const> = at.loadModule("callback")

    cb.register({
        eventName = "getPlayerPosition",
        eventCallback = function()
            local x, y, z = GetEntityCoords(PlayerPedId())
            return x, y, z
        end
    })
  ```

### callServer
- **Description:** Trigger a server callback
- **Parameters:**
  - `args` (table): All arguments
- **Usage:**
  ```lua
    -- Async
    local cb <const> = at.loadModule("callback")

    cb.callServer({
        eventName = "getPlayerMoney",
        args = {"arg1"},
        timeout = 5,
        callback = function(cash, bank)
            print("Argent du joueur:", cash, "Banque:", bank)
        end
    })

    -- Sync
    local cash, bank = cb.callServer({
        eventName = "getPlayerMoney",
        args = {123},
        timeout = 5
    })
    print("Argent du joueur:", cash, "Banque:", bank)
  ```

## unregister
- **Description:** Unregister a callback
- **Parameters:**
  - `eventName` (string): Name of the callback
- **Usage:**
  ```lua
    local cb <const> = at.loadModule("callback")

    cb.unregister("getPlayerMoney")
  ```

## Server-side

### register
- **Description:** Register a server callback
- **Parameters:**
  - `args` (table): All arguments
- **Usage:**
  ```lua
    local cb <const> = at.loadModule("callback")

    cb.register({
        eventName = "getPlayerMoney",
        eventCallback = function(source, arg1)
            print(arg1)
            local player = GetPlayerFromId(source)
            return player.getMoney(), player.getBank()
        end
    })
  ```

### callClient
- **Description:** Emit a client callback
- **Parameters:**
  - `args` (table): All arguments
- **Usage:**
  ```lua
    -- Async 
    local cb <const> = at.loadModule("callback")

    cb.callClient({
        source = playerId,
        eventName = "getPlayerPosition",
        args = {},
        timeout = 5, -- secondes
        timedout = function()
            print("La requête a expiré")
        end,
        callback = function(x, y, z)
            print("Position du joueur:", x, y, z)
        end
    })

    -- Sync
    local x, y, z = cb.callClient({
        source = playerId,
        eventName = "getPlayerPosition",
        timeout = 5
    })
    print("Position du joueur:", x, y, z)
  ```

## unregister
- **Description:** Unregister a callback
- **Parameters:**
  - `eventName` (string): Name of the callback
- **Usage:**
  ```lua
    local cb <const> = at.loadModule("callback")

    cb.unregister("getPlayerMoney")
  ```