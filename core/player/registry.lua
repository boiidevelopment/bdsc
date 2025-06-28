--[[ 
    This file is part of BDSC (BOII Development Server Core) and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ BOII Development

    Support honest development — retain this credit. Don't be that guy...
]]


--- @section Player Registry
--- @description Handles server-side player creation, storage, and lifecycle, as well as client-side data caching.

if bdsc.is_server then

    local players = {}

    --- Creates and registers a new player object from a source ID.
    --- @param source number The player’s server ID.
    --- @return boolean True if the player was created and added successfully, false otherwise.
    function bdsc.create_player(source)
        local player = create_player(source)
        if not player then return false end
        return true
    end

    --- Adds a player object to the internal registry.
    --- @param player table The player object to add.
    --- @return boolean True if added successfully, false otherwise.
    function bdsc.add_player(player)
        if not player or not player.meta.source then return false end
        players[player.meta.source] = player
        return true
    end

    --- Removes a player from the internal registry.
    --- @param source number The player’s server ID.
    --- @return boolean True if removed, false if player was not found.
    function bdsc.remove_player(source)
        if not players[source] then return false end
        players[source] = nil
        return true
    end

    --- Retrieves all registered players.
    --- @return table A table of all active players indexed by their source ID.
    function bdsc.get_players()
        return players
    end

    --- Retrieves a specific player object.
    --- @param source number The player’s server ID.
    --- @return table|nil The player object if found, or nil.
    function bdsc.get_player(source)
        return players[source] or nil
    end

    --- Calls `:save()` on all registered player objects.
    function bdsc.save_players()
        for _, player in pairs(players) do
            player:save()
        end
    end

else

    bdsc.player_data = {}

    --- Retrieves client-side player data.
    --- @return table A table of cached client data.
    function bdsc.get_player_data()
        return bdsc.player_data
    end

end