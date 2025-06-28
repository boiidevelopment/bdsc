--[[ 
    This file is part of BDSC (BOII Development Server Core) and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ BOII Development

    Support honest development — retain this credit. Don't be that guy...
]]

--- @module locales.en
--- @description Stores english language translations for core debugs.

return {
    --- @section Errors

    player_missing = "Player object is missing.",
    source_missing = "Player source is missing",
    user_missing = "BDTK user account is missing for %d",
    player_add_failed = "Failed to add player on creation for %d",
    missing_method = "Missing method: %s:%s for player %d",

    --- @section Info

    attaching_priv_data = "Attaching private data methods to the player object.",
    attaching_priv_data_end = "Finished attaching private data methods.",
    attaching_priv_methods = "Attaching private extension methods to the player object.",
    attaching_priv_methods_end = "Finished attaching private extension methods.",
    attaching_data_api = "Attaching data api to the player object.",
    attaching_data_api_end = "Finished attaching api.",
    attaching_methods_api = "Attaching methods api to the player object.",
    attaching_methods_api_end = "Finished attaching methods api.",
    attaching_lifecycle_api = "Attaching lifecycle api to the player object.",
    attaching_lifecycle_api_end = "Finished attaching lifecycle api.",
    saving_player = "Saving player %d",
    calling_on_save = "on_save function called for namespace: %s on player: %d",
    destroying_player = "Destroying player %d",
    calling_on_destroy = "on_destroy function called for namespace: %s on player: %d",
    player_disconnected = "Player disconnected: %s",

    --- @section Success

    player_loaded = "Player was loaded successfully: %d",
    player_loaded_client = "Client player was loaded successfully: %s {%d}",
    synced_data = "Synced data for namespace: %s",
    method_added = "Method added: %s:%s",
    method_removed = "Method removed: %s:%s"
}