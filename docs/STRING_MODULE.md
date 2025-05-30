# String modules functions & usage 

## Shared

### formatByte
- **Description:** Format a string in bytes
- **Parameters:**
  - `str` (string): The string to format
- **Usage:**
  ```lua
  local string <const> = at.loadModule("string")

  local test = "TEST123"
  local formattedString = string.formatByte(test)

  print(formattedString) -- Output: 7 bytes
  ```

## generateToken
- **Description:** Generate a token
- **Usage:**
  ```lua
  local string <const> = at.loadModule("string")

  local event_token = string.generateToken()

  print(event_token) 
  ```