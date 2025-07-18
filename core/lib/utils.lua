--[[ 
    This file is part of BDSC (BOII Development Server Core) and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ BOII Development

    Support honest development — retain this credit. Don't be that guy...
]]

--- @script lib.utils
--- @description Shared utility functions.

--- Copied from BDTK debugging functions to keep BDUK standalone.
--- Returns the current timestamp as a formatted string.
--- @return string: Formatted time (YYYY-MM-DD HH:MM:SS)
function get_current_time()
    if bdsc.is_server then return os.date("%Y-%m-%d %H:%M:%S") end
    if GetLocalTime then
        local y, m, d, h, min, s = GetLocalTime()
        return string.format("%04d-%02d-%02d %02d:%02d:%02d", y, m, d, h, min, s)
    end
    return "0000-00-00 00:00:00"
end

bdsc.get_current_time = get_current_time

--- Copied from BDTK debugging functions
--- Prints a formatted debug message to the console.
--- @param level string: One of "debug", "info", "success", "warn", "error", "critical", "dev".
--- @param message string: Pre-formatted message to display.
function log(level, message)
    if not bdsc.debug_mode then return end
    local debug_colours = { reset = "^7", debug = "^6", info = "^5", success = "^2", warn = "^3", error = "^8", critical = "^1", dev = "^9" }

    local clr = debug_colours[level] or "^7"
    local time = get_current_time()

    print(("%s[%s] [BDSC] [%s]:^7 %s"):format(clr, time, level:upper(), message))
end

bdsc.log = log

--- Translates a locale key with optional formatting arguments.
--- @param key string: The translation key.
--- @param ... any: Optional format arguments.
--- @return string
function translate(key, ...)
    local str, args = bdsc.locale[key], table.pack(...)
    return type(str) == "string" and (args.n > 0 and select(2, pcall(string.format, str, table.unpack(args, 1, args.n))) or str) or (type(key) == "string" and (args.n > 0 and (key .. " | " .. table.concat(args, ", ")) or key)) or tostring(key)
end

bdsc.translate = translate