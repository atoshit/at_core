# Global functions list & usages

## at.LoadModule
- **Description:** Load a module
- **Parameters:**
  - `module` (string): The name of the module to load
- **Return:** The module object
- **Usage:**
  ```lua
  local module = at.loadModule("moduleName")

  -- Use the module
  module.functionName()
  ```

## at.LoadLocale
- **Description:** Load a language file
- **Parameters:**
  - `lang` (string): The name of the language file to load
- **Return:** The language object
- **Usage:**
  ```lua
  local language = at.loadLocale("fr")

  -- Use the language
  print(language["key"])
  ```

## at.IsResourceStarted
- **Description:** Check if a resource is started
- **Parameters:**
  - `r` (string): The name of the resource to check
- **Return:** `true` if the resource is started, `false` otherwise
- **Usage:**
  ```lua
  if at.isResourceStarted("oxmysql") then
    print("Resource is started")
  else
    print("Resource is not started")
  end
  ```

## at.Info
- **Description:** Print a info message
- **Parameters:**
  - `msg` (string): Message to print
- **Usage:**
  ```lua
  local msg <const> = "Hello World !"

  at.Info(msg)
  ```

## at.Debug
- **Description:** Print a debug message
- **Parameters:**
  - `msg` (string): Message to print
- **Usage:**
  ```lua
  local msg <const> = "Hello World !"

  at.Debug(msg)
  ```

## at.GetModules
- **Description:** Get all loaded modules
- **Return:** A table containing all loaded modules
- **Usage:**
  ```lua
  local modules = at.getModules()

  print("Loaded modules: " .. #modules)
  ```

## at.GetLocales
- **Description:** Get all loaded languages
- **Return:** A table containing all loaded languages
- **Usage:**
  ```lua
  local languages = at.GetLocales()

  print("Loaded languages: ".. #languages)
  ```

## at.CreatePlayer
- **Description:** Create a new player object
- **Parameters:**
  - `id` (number): Player ID
  - `data` (table): Data table
- **Return:** Player Object
- **Usage:**
  ```lua
  local player = at.CreatePlayer(1, {rank = "admin"})

  print("Player rank: ".. player.rank)
  ```

  
## at.GetPlayer
- **Description:** Get a player object
- **Parameters:**
  - `id` (number): Player ID
- **Return:** Player Object
- **Usage:**
  ```lua
  local player = at.GetPlayer(1)

  print("Player rank: ".. player.rank)
  ```

## at.DestroyPlayer
- **Description:** Destroy a player object
- **Parameters:**
  - `id` (number): Player ID
- **Usage:**
  ```lua
  at.DestroyPlayer(1)
  ```