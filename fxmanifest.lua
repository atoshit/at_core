fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'Atoshi'
description 'Core'
version '1.0.0'
repository 'https://github.com/atoshit/at_core'

shared_scripts {
    'shared/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    -- Class
    'server/class/*.lua'
}

client_scripts {
    'client/wrapper/*.lua',

    'client/cache.lua',

    'client/class/*.lua',

    'client/main.lua'
}
