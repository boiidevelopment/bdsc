--[[ 
    This file is part of BDSC (BOII Development Server Core) and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ BOII Development

    Support honest development — retain this credit. Don't be that guy...
]]

--- @script player.factory
--- @description Factory responsible for constructing and initializing new player objects.

--- Creates a new player object from a server ID.
--- This initializes a BDSC player instance using account data from BDTK.
--- The player is split into two layers: a private backend and a public interface.
--- Extensions for data and methods are attached during creation.
--- Automatically registers the player with the core registry only methods have been added
--- @param source number The players server ID.
--- @return table|nil The public player object, or nil if creation failed.
local function create_player(source)
    if not source then log("error", translate("source_missing")) return end

    local user = exports.bdtk:get_user(source)
    if not user then log("error", translate("user_missing", tonumber(source))) return end

    local _data_store = {}

    local priv = {
        source = source,
        user = user,
        _extensions = {
            _data = {},
            _methods = {},
            _replicated = {}
        }
    }

    local pub = {
        meta = {
            source = source,
            unique_id = user.unique_id,
            rank = user.rank,
            vip = user.vip,
            priority = user.priority,
            characters = user.characters,
            username = user.username or ("default_" .. user.unique_id)
        }
    }

    _attach_private_data(priv)
    attach_data_api(pub, priv)

    _attach_private_methods(priv)
    attach_method_api(pub, priv)

    attach_lifecycle_api(pub, priv)

    pub:add_data("meta", pub.meta, true)

    local player_added = bdsc.add_player(pub)
    if not player_added then log("error", translate("player_add_failed", source)) return nil end

    TriggerEvent("bdsc:sv:player_loaded", pub)
    return pub
end

bdsc.create_player = create_player