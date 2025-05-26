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

## at.LoadConfig
- **Description:** Load a config file
- **Parameters:**
  - `config` (string): The name of the config file to load
- **Return:** The config object
- **Usage:**
  ```lua
  local config = at.loadConfig("configName")

  -- Use the config
  print(config.key)
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