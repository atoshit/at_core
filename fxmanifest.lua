fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'Atoshi'
description 'Core'
version '1.0.0'
repository 'https://github.com/atoshit/at_core'

shared_scripts {
    'shared/_init.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua'
}