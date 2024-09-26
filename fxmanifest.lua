fx_version 'cerulean'
game 'gta5'
author 'Nokiki'
version '1.0'
description 'NS-Pin by Nokiki'
lua54 'yes'

ui_page 'NS-UI/index.html'

files {
    "NS-UI/**",
}

client_scripts {
    'shared/Config.lua',
    'client/client.lua',
}

server_scripts {
    'server/webhook.lua',
}