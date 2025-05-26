# Global functions list & usages

## at.loadModule
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

## at.loadConfig
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

## at.loadLocale
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

## at.isResourceStarted
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