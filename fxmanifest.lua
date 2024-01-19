author "Brody"
description "Job Hud for knight-duty"
fx_version "cerulean"
game "gta5"

client_scripts {
    'client.lua',
    'jobhud.lua',
    'taghud.lua'
}

exports {
    "setPlayerHeadTagGui",
    "setGangHeadTagGui",
}

server_script "server.lua"

shared_script "config.lua"
