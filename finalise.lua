--[[ 
    This file is part of BDSC (BOII Development Server Core) and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ BOII Development

    Support honest development — retain this credit. Don't be that guy...
]]

--- @script finalize
--- @description Runs once BDSC has loaded all files.

--- @section Export Namespace

--- Import the main bdsc namespace into external projects.
--- @usage local bdsc = exports.bdsc:import()
exports("import", function()
    return bdsc
end)

--- @section Namespace Protection

--- Applies namespace protection to prevent accidental overrides.
setmetatable(bdsc, {
    __newindex = function(_, key)
        error(("Attempted to assign to bdsc.%s after initialization"):format(key), 2)
    end
})