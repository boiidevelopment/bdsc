--[[ 
    This file is part of BDSC (BOII Development Server Core) and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ BOII Development

    Support honest development — retain this credit. Don't be that guy...
]]

--- @script example
--- @description BDSC Example Integration File
--- This file demonstrates how to:
--- - Create a player instance
--- - Add custom data and methods
--- - Access and modify data
--- - Trigger lifecycle and sync logic

--- Importing the bdsc namespace
--- It does not matter what you name this "bdsc", "core", "banana".. up to you *(may sound dumb to point that out but ive been asked a few times)*.
local core <const> = exports.coretest:import()

--- Create and setup a new player instance
RegisterCommand("make", function(src)
    local player = core.create_player(src)
    if not player then print("Failed to create player") return end

    -- Attach initial data
    player:add_data("stats", { health = 100, stamina = 50 }, true) -- if true will replicate to client

    -- Add a method to get player health
    player:add_method("stats", "get_health", function(self)
        local stats = self:get_data("stats")
        return stats and stats.health or 0
    end)

    -- Lifecycle method triggered on save
    player:add_method("stats", "on_save", function()
        print("saving player stats")
    end)

    -- Lifecycle method triggered on destroy
    player:add_method("stats", "on_destroy", function()
        print("destroying player, do something with stats?")
    end)

    print("Player created and method added.")
end, false)

--- Print the players current health
RegisterCommand("hp", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    print("Health:", player:run_method("stats", "get_health"))
end, false)

--- Deal damage to the player by reducing health
--- Run /hp command again after to check if damaged
RegisterCommand("damage", function(src, args)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    local amount = tonumber(args[1]) or 10
    local stats = player:get_data("stats")
    stats.health = stats.health - amount
    player:set_data("stats", stats, true)

    print("Damaged player for", amount)
end, false)

--- Add a method to uppercase the job name
RegisterCommand("add_upper", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    player:add_method("get_upper_job", function(self)
        local job = self:get_data("job")
        return job and string.upper(job) or "NONE"
    end)

    print("Method get_upper_job added.")
end, false)

--- Call the uppercased job method
RegisterCommand("call_upper", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    print("Upper Job:", player:run_method("get_upper_job"))
end, false)

--- Assign a job to the player
RegisterCommand("job", function(src, args)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    local job = args[1] or "thief"
    player:add_data("job", job, true)
    print("Job set to:", job)
end, false)

--- Remove the players job
RegisterCommand("clearjob", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    player:remove_data("job")
    print("Job removed.")
end, false)

--- Dump all stored data for the player
RegisterCommand("dump", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    local data = player:get_data()
    print("Data dump:")
    for k, v in pairs(data) do
        print(k .. ": " .. json.encode(v))
    end
end, false)

--- Force a manual sync of all replicated data
RegisterCommand("sync", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    player:sync_data()
end, false)

--- Attempt to call a method that doesn't exist
RegisterCommand("badcall", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    print("Calling missing method:")
    local result = player:run_method("nonexistent")
    print("Result:", result or "nil")
end, false)

--- Attempt to write directly to the _data table (should be blocked)
RegisterCommand("overwrite", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    print("Trying to write to _data (should error)...")
    player._data["hack"] = true
end, false)

--- Attempt to read directly from the _data table (should error)
RegisterCommand("read", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    print("Trying to read _data directly (should error)...")
    local value = player._data["stats"]
end, false)

--- Attempt to save player
--- Should print "saving player stats" from the `on_save` method we added in `/make`
RegisterCommand("save", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    print("Trying to save player")
    player:save()
end)

--- Attempt to destroy player
--- Should print "destroying player, do something with stats?" from the `on_destroy` method we added in `/make`
RegisterCommand("save", function(src)
    local player = core.get_player(src)
    if not player then print("No player found.") return end

    print("Trying to destroy player")
    player:destroy()
end)