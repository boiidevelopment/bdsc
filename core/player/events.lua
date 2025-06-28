--[[ 
    This file is part of BDSC (BOII Development Server Core) and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ BOII Development

    Support honest development — retain this credit. Don't be that guy...
]]

--- @script player.events
--- @description Player events split by duplicity.

if bdsc.is_server then

    --- Called automatically when a player disconnects.
    --- Saves and unloads the player, then removes them from the registry.
    --- @param reason string: Reason for disconnect.
    AddEventHandler("playerDropped", function(reason)
        local _src = source
        local player = bdsc.get_player(_src)
        if player then
            player:save()
            player:destroy()
            log("info", translate("player_disconnected", _src))
        end
    end)

    --- Fired at end of player creation cycle, hook into this externally.
    --- Receives the entire public player object.
    AddEventHandler("bdsc:sv:player_loaded", function(player)
        if not player then log("error", "player_missing") return end
        log("info", translate("player_loaded", tonumber(player.meta.source)))

        TriggerClientEvent("bdsc:cl:player_loaded", player.meta.source, player.meta)
    end)

else

    --- Receives replicated player data from the server.
    --- Updates local data and triggers a forward-facing sync event.
    --- @param data table: Keyed data table of categories to sync.
    RegisterNetEvent("bdsc:cl:sync_data", function(data)
        if type(data) ~= "table" then return end

        for namespace, values in pairs(data) do
            bdsc.player_data[namespace] = values
            log("info", translate("synced_data", namespace))
            TriggerEvent("bdsc:cl:on_data_sync", namespace, values)
        end
    end)

    --- Fired at end of player creation cycle, hook into this externally.
    RegisterNetEvent("bdsc:cl:player_loaded")
    AddEventHandler("bdsc:cl:player_loaded", function(meta)
        if not meta then log("error", "player_data_missing") return end

        log("info", translate("player_loaded_client", meta.username, tonumber(meta.source)))
    end)

end