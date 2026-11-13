-- gmodlib/accessorfunc.lua
-- AccessorFunc(tab, key, name, force)
-- Creates tab["Get" .. name] and tab["Set" .. name] that read/write self[key].

FORCE_STRING = FORCE_STRING or 1
FORCE_NUMBER = FORCE_NUMBER or 2
FORCE_BOOL   = FORCE_BOOL   or 3
FORCE_ANGLE  = FORCE_ANGLE  or 4
FORCE_COLOR  = FORCE_COLOR  or 5
FORCE_VECTOR = FORCE_VECTOR or 6

function AccessorFunc(tab, key, name, force)
    assert(type(tab) == "table", "AccessorFunc: first argument must be a table")
    assert(key  ~= nil, "AccessorFunc: missing variable key")
    assert(name ~= nil, "AccessorFunc: missing accessor name")

    tab["Get" .. name] = function(self)
        return self[key]
    end

    if force == FORCE_STRING then
        tab["Set" .. name] = function(self, v) self[key] = tostring(v) end
    elseif force == FORCE_NUMBER then
        tab["Set" .. name] = function(self, v) self[key] = tonumber(v) end
    elseif force == FORCE_BOOL then
        tab["Set" .. name] = function(self, v) self[key] = tobool(v) end
    else
        -- no coercion (also the case for FORCE_ANGLE/COLOR/VECTOR, as in GMod)
        tab["Set" .. name] = function(self, v) self[key] = v end
    end
end

return AccessorFunc