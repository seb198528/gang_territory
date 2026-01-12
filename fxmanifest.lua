fx_version 'cerulean'
game 'gta5'

author 'RP Dev Team'
description 'Gang Territory System - QBCore Style'
version '2.0.0'

shared_script 'config.lua'

client_scripts {
    'client/main.lua',
    'client/menu.lua',
    'client/sounds.lua'
}

server_script 'server/main.lua'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/app.js',
    'ui/sounds/ballas_alert.mp3',
    'ui/sounds/vagos_alert.mp3',
    'ui/sounds/families_alert.mp3'
}

dependencies {
    'qb-core'
}