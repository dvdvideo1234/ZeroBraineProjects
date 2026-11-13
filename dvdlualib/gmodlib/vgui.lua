local vgui = {}
local baseclass = {}
local controls = {}   -- class name -> control table
local aliases  = { Panel = "DPanel", Label = "DLabel" }

local function canon(name) return aliases[name] or name end

---------------------------------------------------------------
-- Class resolution
---------------------------------------------------------------
local function resolve(cls, depth)
    depth = depth or 0
    assert(depth < 64, "vgui: circular base class on " .. tostring(cls.ClassName))

    if cls.Base then
        local base = controls[cls.Base]
        if not base then
            error(("vgui: base class '%s' of '%s' is not registered")
                :format(cls.Base, tostring(cls.ClassName)), 3)
        end
        resolve(base, depth + 1)
        cls.BaseClass = base
        setmetatable(cls, { __index = base })
    end
    return cls
end

local function instantiate(cls, parent, name)
    resolve(cls)
    local pnl = setmetatable({}, {
        __index    = cls,
        __tostring = function(self)
            local ok = self.IsValid and self:IsValid()
            return ("Panel: %s [%s]"):format(tostring(cls.ClassName), ok and "valid" or "removed")
        end,
    })
    if pnl.Construct then pnl:Construct(parent, name) end
    if pnl.Init then pnl:Init() end
    return pnl
end

---------------------------------------------------------------
-- Public API
---------------------------------------------------------------
-- base == nil     -> "DPanel"
-- base == "Panel" -> "DPanel" (there is no engine Panel here)
-- base == false   -> no base (only for the root class)
function vgui.Register(name, tbl, base)
    if base == nil then
        base = "DPanel"
    elseif base then
        base = canon(base)
    end
    -- a class defined on top of its own alias (DLabel on "Label", DPanel on "Panel")
    if base == name then
        base = (name ~= "DPanel") and "DPanel" or false
    end

    tbl.ClassName = name
    tbl.Base      = base
    controls[name] = tbl
    return tbl
end

function vgui.RegisterTable(tbl, base)
    if base == nil then base = "DPanel" else base = canon(base) end
    tbl.Base = base
    return tbl
end

function vgui.Create(classname, parent, name)
    local cls = controls[canon(classname)]
    if not cls then return nil end
    return instantiate(cls, parent, name)
end

function vgui.GetControlTable(name)
    return controls[canon(name)]
end

function baseclass.Get(name) return controls[canon(name)] end

_G.vgui = vgui

---------------------------------------------------------------
-- Built-in controls: DPanel is the root
---------------------------------------------------------------
local DPanel = require("gmodlib/vgui/dpanel")
vgui.Register("DPanel", DPanel, false)

local DLabel = require("gmodlib/vgui/dlabel")
vgui.Register("DLabel", DLabel, "DPanel")

local DTextEntry = require("gmodlib/vgui/dtextentry")
vgui.Register("DTextEntry", DTextEntry, "DLabel")


require("gmodlib/accessorfunc")

require("gmodlib/vgui/dbutton")
require("gmodlib/vgui/dvscrollbar")

return vgui