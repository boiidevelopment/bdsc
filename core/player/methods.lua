--[[ 
    This file is part of BDSC (BOII Development Server Core) and is licensed under the MIT License.
    See the LICENSE file in the root directory for full terms.

    © 2025 Case @ BOII Development

    Support honest development — retain this credit. Don't be that guy...
]]

--- BDSC separates private and public method layers to maintain strict control over what external code can access or mutate.
--- Private methods handle core logic, state management, and internal mutations.
--- Public methods serve as the exposed API — these are safe, read-only, or filtered entrypoints that forward to private logic.
--- This pattern ensures all mutation and method calls go through validation and logging layers while still supporting external extensions.

--- @section Private Methods
--- @description Core methods attached to players, these are triggered by public api, not directly.

--- Attaches internal data methods to the players private object.
--- @param priv table The private player object.
function _attach_private_data(priv)
    log("info", translate("attaching_priv_data"))

    local data = priv._extensions._data
    local replicated = priv._extensions._replicated

    priv._has_data = function(namespace)
        return data[namespace] ~= nil
    end

    priv._get_data = function(namespace)
        return namespace and data[namespace] or data
    end

    priv._add_data = function(namespace, value, replicate)
        if type(namespace) ~= "string" or namespace == "" then return end
        rawset(data, namespace, value)
        if replicate then
            replicated[namespace] = true
            priv._sync_data(namespace) 
        end
    end

    priv._remove_data = function(namespace)
        data[namespace] = nil
        priv._sync_data(namespace)
    end

    priv._set_data = function(namespace, updates, sync)
        local target = data[namespace]
        if type(target) ~= "table" or type(updates) ~= "table" then return false end
        for k, v in pairs(updates) do target[k] = v end
        if sync then priv._sync_data(namespace) end
        return true
    end

    priv._sync_data = function(namespace)
        local source = priv.source
        if not source then log("error", translate("missing_source")) return end

        if namespace then
            if not replicated[namespace] or type(data[namespace]) ~= "table" then return end
            TriggerClientEvent("bdsc:cl:sync_data", source, { [namespace] = data[namespace] })
        else
            local payload = {}
            for k in pairs(replicated) do payload[k] = data[k] end
            TriggerClientEvent("bdsc:cl:sync_data", source, payload)
        end
    end

    priv._update_user_data = function(key, value)
        if not key then return end
        priv.user[key] = value
        if pub[key] ~= nil then pub[key] = value end
        exports.bdtk:update_user_data(priv.source, { [key] = value })
    end

    log("info", translate("attaching_priv_data_end"))
end

--- Attaches internal method system to the players private object.
--- @param priv table The private player object.
function _attach_private_methods(priv)
    log("info", translate("attaching_priv_methods"))

    local methods = priv._extensions._methods

    priv._add_method = function(namespace, name, fn)
        if type(namespace) ~= "string" or type(name) ~= "string" then return false end
        methods[namespace] = methods[namespace] or {}
        rawset(methods[namespace], name, fn)
        return true
    end

    priv._remove_method = function(namespace, name)
        if not methods[namespace] or not methods[namespace][name] then return false end
        methods[namespace][name] = nil
        return true
    end


    priv._get_method = function(namespace, name)
        return methods[namespace] and methods[namespace][name] or nil
    end

    priv._has_method = function(namespace, name)
        return methods[namespace] and methods[namespace][name] ~= nil
    end

    log("info", translate("attaching_priv_methods_end"))
end

--- @section Public Methods
--- @description Public API methods to players, these trigger the core api methods safely.

--- Attaches public data access methods to the players public object.
--- @param pub table The public player object.
--- @param priv table The private player object.
function attach_data_api(pub, priv)
    log("info", translate("attaching_data_api"))

    pub.has_data = function(_, namespace)
        return priv._has_data(namespace)
    end

    pub.get_data = function(_, namespace)
        return priv._get_data(namespace)
    end

    pub.add_data = function(_, namespace, value, replicated)
        return priv._add_data(namespace, value, replicated)
    end

    pub.remove_data = function(_, namespace)
        return priv._remove_data(namespace)
    end

    pub.set_data = function(_, namespace, updates, sync)
        return priv._set_data(namespace, updates, sync)
    end

    pub.sync_data = function(_, namespace)
        return priv._sync_data(namespace)
    end

    pub.update_user_data = function(_, key, value)
        priv._update_user_data(key, value)
    end

    log("info", translate("attaching_data_api_end"))
end

--- Attaches public method management functions to the players public object.
--- @param pub table The public player object.
--- @param priv table The private player object.
function attach_method_api(pub, priv)
    log("info", translate("attaching_methods_api"))

    pub.add_method = function(_, namespace, name, fn)
        if priv._add_method(namespace, name, fn) then
            log("success", translate("method_added", namespace, name))
        end
    end

    pub.remove_method = function(_, namespace, name)
        local ok = priv._remove_method(namespace, name)
        if not ok then
            log("info", translate("method_removed", namespace, name))
            return false
        end
        return true
    end

    pub.has_method = function(_, namespace, name)
        return priv._has_method(namespace, name)
    end

    pub.run_method = function(_, namespace, name, ...)
        local method = priv._get_method(namespace, name)
        if not method then
            log("error", translate("missing_method", namespace, name, pub.meta.source))
            return nil
        end
        return method(pub, ...)
    end

    log("info", translate("attaching_methods_api_end"))
end

--- Attaches lifecycle functions (save/destroy) to the players public object.
--- @param pub table The public player object.
--- @param priv table The private player object.
function attach_lifecycle_api(pub, priv)
    log("info", translate("attaching_lifecycle_api"))

    pub.save = function()
        log("info", translate("saving_player", pub.meta.source))

        for namespace in pairs(priv._extensions._methods) do
            if pub:has_method(namespace, "on_save") then
                log("info", translate("calling_on_save", namespace, pub.meta.source))
                pub:run_method(namespace, "on_save")
            end
        end
    end

    pub.destroy = function()
        log("info", translate("destroying_player", pub.meta.source))

        pub.save()

        for namespace in pairs(priv._extensions._methods) do
            if pub:has_method(namespace, "on_destroy") then

                log("info", translate("calling_on_destroy", namespace, pub.meta.source))

                pub:run_method(namespace, "on_destroy")
            end
        end
        bdsc.remove_player(pub.meta.source)
    end

    log("info", translate("attaching_lifecycle_api_end"))
end