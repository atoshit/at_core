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
ensure at_core
add_ace resource.at_core command allow
```
3. Create a new file in your server's root directory called `at_core_settings.cfg`
4. Copy this content into the file:
```
setr at_core:debug false
```
5. Configure the settings as needed.
6. Start your server and enjoy :).