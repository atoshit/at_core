# Discord modules functions & usage 

## Client-side

### start
- **Description:** Start then discord rich presence
- **Parameters:**
  - `appId` (string): Application ID
  - `asset` (string): Image name upload in the discord application
  - `assetText` (string): Hover text
  - `buttons` (table): Buttons name
  - `buttonsUrl` (table): Buttons url
  - `presenceMessage` (string): Main message in the rich presence
- **Metamethods:**
  - `startLoop` (function): Launch the loop
  - `update` (string): Update info on the rich presence
- **Metadatas:**
  - `id` (string): Application ID
  - `asset` (string): Image name upload in the discord application
  - `assetText` (string): Hover text
  - `buttons` (table): Buttons name
  - `buttonsUrl` (table): Buttons url
  - `presenceMessage` (string): Main message in the rich presence
- **Usage:**
  ```lua
  local discord <const> = at.loadModule("discord")

  local presence = discord.start("1234567890", "image", "Hover text", {"Button 1", "Button 2"}, {"URL_ADDRESS.com", "URL_ADDRESS.com"}, "First Message")

  presence:startLoop()

  -- Update the presence message
  pesence.presenceMessage = "Second message"
  ```