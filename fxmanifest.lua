fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'Atoshi (discord: atoshic17)'
description 'At Core is a modular and user-friendly framework designed for creating FiveM servers. With its simple configuration and advanced features, At Core allows server developers to easily set up and manage their servers while offering the flexibility to customize and expand as needed. Perfect for both beginners and experienced users.'
version '0.1.1'
repository 'https://github.com/atoshit/at_core'

files {
    --'configs/**/*.lua',
    'locales/*.lua',
    'modules/**/*.lua'
}

shared_script 'init.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sources/server/*.lua',
    'sources/server/managers/*.lua',
    'sources/server/handlers/*.lua',
    'sources/server/commands/*.lua'
}

client_scripts {
    'sources/client/managers/*.lua',
    'sources/client/*.lua',
    'sources/client/commands/*.lua'
}

dependency 'oxmysql'