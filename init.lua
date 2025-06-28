--[[ 
    This file is part of BDSC (BOII Development Server Core) and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ BOII Development

    Support honest development — retain this credit. Don't be that guy...
]]

--- @script init
--- @description This is the initialization point, it defines the `bdsc` global object, and some general settings.

--- @section Object

bdsc = setmetatable({}, { __index = _G })

--- @section Flags & Constants

bdsc.resource_name = GetCurrentResourceName()
bdsc.is_server = IsDuplicityVersion()
bdsc.version = GetResourceMetadata(bdsc.resource_name, "version", 0) or "unknown"
bdsc.debug_mode = GetConvar("bdsc:debug_mode", "false") == "true"

--- @section Locale

bdsc.language = GetConvar("bdsc:language", "en")
bdsc.locale = exports.bdtk:get("locales." .. bdsc.language, true) or {}
