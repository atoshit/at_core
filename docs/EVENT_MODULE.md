# Event modules functions & usage 

## Client

### emit.net
- **Description:** Trigger a net event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `...` (any): Arguments to pass to the event
- **Usage:**
  ```lua
    local emit <const> = at.loadModule("emit")

    emit.net("sendPlayerMoney", 1000)

    -- or 

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

    -- or 

    at.emit("sendPlayerMoney", 1000)
  ```

## on.net
- **Description:** Register a net event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `cb` (function): Callback
- **Usage:**
  ```lua
    local on = at.LoadModule('on')

    on.net('sendPlayerMoney', function(money)
        print(money)
    end)

    -- or

    at.on.net('sendPlayerMoney', function(money)
        print(money)
    end)
  ```

## on
- **Description:** Register a event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `cb` (function): Callback
- **Usage:**
  ```lua
    local on = at.LoadModule('on')

    on('sendPlayerMoney', function(money)
        print(money)
    end)

    -- or

    at.on('sendPlayerMoney', function(money)
        print(money)
    end)
  ```

## Server

### on.net
- **Description:** Register a net event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `cb` (function): Callback
- **Usage:**
  ```lua
    local on = at.LoadModule('on')

    on.net('sendPlayerMoney', function(source, money)
        print(source, money)
    end)

    -- or

    at.on.net('sendPlayerMoney', function(source, money)
        print(source, money)
    end)
  ```

### on
- **Description:** Register a event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `cb` (function): Callback
- **Usage:**
  ```lua
    local on = at.LoadModule('on')

    on('sendPlayerMoney', function(money)
        print(money)
    end)

    -- or 

    at.on('sendPlayerMoney', function(money)
        print(money)
    end)
  ```

## emit.net
- **Description:** Trigger a client event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `source` (number|array): Source(s) to trigger the event
  - `...` (any): Arguments to pass to the event
- **Usage:**
  ```lua
    local emit <const> = at.loadModule("emit")

    emit.net("sendPlayerMoney", {1, 2, 3}, 1000)

    -- or

    at.emit.net("sendPlayerMoney", 1, 1000)
  ```

## emit
- **Description:** Trigger a event
- **Parameters:**
  - `eventName` (string): Name of the event
  - `...` (any): Arguments to pass to the event
- **Usage:**
  ```lua
    local emit <const> = at.loadModule("emit")

    emit("sendPlayerMoney", 1000)

    -- or

    at.emit("sendPlayerMoney", 1000)
  ```