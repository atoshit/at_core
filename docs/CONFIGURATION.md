# Configuration

## Create & Configure Database
1. Install [oxmysql](https://overextended.dev/oxmysql) in your resources folder.
2. Create a new database in your MySQL server.
3. Copy this content into the `server.cfg` file after `endpoint_add_tcp`:
```
set mysql_connection_string "user=root;password=;host=localhost;port=3306;database=at_core_database"
set mysql_slow_query_warning 300
set mysql_debug true

ensure oxmysql
```
4. Configure the `mysql_connection_string` variable to match your MySQL server's credentials.
5. Configure the `mysql_slow_query_warning` variable to match your desired slow query warning threshold.
6. Configure the `mysql_debug` variable to match your desired debug mode.

## Resource configuration
1. Install & put last release of [at_core](https://github.com/atoshit/at_core/releases) in your resources folder.
2. In your `server.cfg` file, add this content after `ensure oxmysql`:
```
exec at_core_settings.cfg
add_ace resource.at_core command allow
ensure at_core
```
3. Create a new file in your server's root directory called `at_core_settings.cfg`
4. Copy this content into the file:
```
# Global
setr at_core:debug 1 # 0 by default (0 == false, 1 == true)
setr at_core:lang "en" # "en" by default
setr at_core:logo "YOUR_LOGO_URL_HERE"

# Game
## Spawn
setr at_core:spawn:coords {"x": -3058.714, "y": 3329.19, "z": 12.5844, "w": 0.0}
setr at_core:spawn:ped "mp_m_freemode_01" 

# Discord
## Presence
setr at_core:presence:appId "YOUR_APP_ID" # Create an application at https://discord.com/developers/applications
setr at_core:presence:updateInterval 5 # in seconds
setr at_core:presence:asset "YOUR_ASSET_NAME" 
setr at_core:presence:assetText "At Core by atoshi" 
setr at_core:presence:buttons ["Repository", "Join Server"]
setr at_core:presence:buttonsUrl ["https://github.com/atoshit/at_core", "fivem://connect/cfx.re/join/8dekqv"]
```
5. Configure the settings as needed.
6. Start your server and enjoy :).