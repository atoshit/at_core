# Event modules functions & usage 

## Client

### net
- **Description:** Trigger a net event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `...` (any): Arguments to pass to the event
- **Usage:**
  ```lua
    local emit <const> = at.loadModule("emit")

    emit.net("sendPlayerMoney", 1000)

    or 

    at.emit.net("sendPlayerMoney", 1000)
  ```

### emit
- **Description:** Trigger a event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `...` (any): Arguments to pass to the event
- **Usage:**
  ```lua
    local emit <const> = at.loadModule("emit")

    emit("sendPlayerMoney", 1000)

    or 

    at.emit("sendPlayerMoney", 1000)
  ```

## Server

### net
- **Description:** Register a net event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `...` (any): Arguments to pass to the event
- **Usage:**
  ```lua
    local on = at.LoadModule('on')

    on.net('sendPlayerMoney', function(source, money)
        print(source, money)
    end)

    or

    at.on.net('sendPlayerMoney', function(source, money)
        print(source, money)
    end)
  ```

### on
- **Description:** Register a event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `...` (any): Arguments to pass to the event
- **Usage:**
  ```lua
    local on = at.LoadModule('on')

    on('sendPlayerMoney', function(money)
        print(money)
    end)

    or 

    at.on('sendPlayerMoney', function(money)
        print(money)
    end)
  ```