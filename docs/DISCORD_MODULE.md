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

## Client-side

### send
- **Description:** Send a discord log
- **Parameters:**
  - `webhook` (string): The webhook url
  - `title` (string): The title of the embed
  - `description` (string): The description of the embed
  - `color` (string): The color of the embed ("red", yellow...)
  - `fields` (table): The fields of the embed ({name = "title", value = "value", inline = true})
  - `footer` (table): The footer of the embed
  - `image` (string): The image of the embed
  - `thumbnail` (string): The thumbnail of the embed
- **Usage:**
  ```lua
  local log <const> = at.loadModule("discord")

  local WEBHOOK <const> = "WEBHOOK_URL"
  local IMAGE <const> = "IMAGE_URL"

  local FIELDS <const> = {
    {name = "Title", value = "Value", inline = true}, 
    {name = "Title2", value = "Value2", inline = true}
  }

  log(WEBHOOK, "Title", "Description", "red", FIELDS, {text = "Text", icon_url = IMAGE}, IMAGE, IMAGE)
  ```