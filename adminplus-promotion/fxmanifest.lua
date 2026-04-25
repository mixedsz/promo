fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'AdminPlus#0001 | AdminPlus'
description 'AdminPlus Promotion QB/ESX'
version '1.0.5'

client_scripts {
    'client/*.lua',
}

shared_scripts {
    '@es_extended/imports.lua', -- comment out this line if using QB-Core
    '@ox_lib/init.lua',
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

escrow_ignore {
    'config.lua',
    'fxmanifest.lua',
    'client/editable.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql',
}
