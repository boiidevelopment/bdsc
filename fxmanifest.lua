--[[
################################
#    ____   ____ _____ _____   #
#   |  _ \ / __ \_   _|_   _|  #    
#   | |_) | |  | || |   | |    #
#   |  _ <| |  | || |   | |    #
#   | |_) | |__| || |_ _| |_   #
#   |____/ \____/_____|_____|  #
#                              #                       
################################                                             
# BOII Development Server Core #
#           V0.1.0             # 
################################
]]

fx_version "cerulean"
games { "gta5", "rdr3" }

name "bdsc"
version "0.1.0"
description "A lightweight server core designed for developers who want control and not bloat."
author "boiidevelopment"
repository "https://github.com/boiidevelopment/bdsc"
lua54 "yes"

shared_scripts {
    "init.lua",
    "core/lib/*.lua"
}

server_scripts {
    "core/player/methods.lua",
    "core/player/factory.lua",
}

shared_scripts {
    "core/player/events.lua",
    "core/player/registry.lua",
}

shared_script "finalise.lua"

dependency "bdtk"
provide "bdsc"