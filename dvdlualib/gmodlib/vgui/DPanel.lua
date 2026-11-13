-- gmodlib/dpanel.lua
-- Defines DPanel and returns it. Doesn't register itself; vgui.lua does that.

NODOCK, FILL, LEFT, RIGHT, TOP, BOTTOM =
    NODOCK or 0, FILL or 1, LEFT or 2, RIGHT or 3, TOP or 4, BOTTOM or 5

if not IsValid then
    function IsValid(obj)
        if type(obj) ~= "table" or type(obj.IsValid) ~= "function" then
            return false
        end
        return obj:IsValid() and true or false
    end
end

local DPanel = {}

-- Engine-level state. Called by vgui.Create before Init, so derived
-- panels work even if they never call the base Init.
function DPanel:Construct(parent, name)
    self._valid    = true
    self._x, self._y = 0, 0
    self._w, self._h = 64, 24
    self._visible  = true
    self._enabled  = true
    self._alpha    = 255
    self._dock     = NODOCK
    self._children = {}
    self._name     = name
    self._paintBG  = true
    if parent then self:SetParent(parent) end
end

-- Hooks the addon overrides (empty on purpose)
function DPanel:Init() end
function DPanel:Paint(w, h) return false end
function DPanel:PerformLayout(w, h) end
function DPanel:Think() end
function DPanel:OnRemove() end
function DPanel:OnCursorEntered() end
function DPanel:OnCursorExited() end
function DPanel:OnMousePressed(code) end
function DPanel:OnMouseReleased(code) end

-- Lifetime
function DPanel:IsValid() return self._valid == true end

function DPanel:Remove()
    if not self._valid then return end
    for i = #self._children, 1, -1 do
        self._children[i]:Remove()
    end
    self:OnRemove()
    self:SetParent(nil)
    self._valid = false
end

-- Hierarchy
function DPanel:SetParent(parent)
    local old = self._parent
    if old then
        for i, c in ipairs(old._children) do
            if c == self then table.remove(old._children, i) break end
        end
    end
    self._parent = parent
    if parent then table.insert(parent._children, self) end
end

function DPanel:GetParent()   return self._parent end
function DPanel:GetChildren() return self._children end
function DPanel:ChildCount()  return #self._children end

function DPanel:Add(class)
    if type(class) == "string" then
        return vgui.Create(class, self)   -- resolved at call time
    end
    class:SetParent(self)
    return class
end

-- Position / size
function DPanel:SetPos(x, y)  self._x, self._y = x, y end
function DPanel:GetPos()      return self._x, self._y end
function DPanel:SetSize(w, h) self._w, self._h = w, h end
function DPanel:GetSize()     return self._w, self._h end
function DPanel:SetWide(w)    self._w = w end
function DPanel:GetWide()     return self._w end
function DPanel:SetTall(h)    self._h = h end
function DPanel:GetTall()     return self._h end
function DPanel:Center() end
function DPanel:InvalidateLayout(now) end

-- State
function DPanel:SetVisible(b) self._visible = b and true or false end
function DPanel:IsVisible()   return self._visible end
function DPanel:SetEnabled(b) self._enabled = b and true or false end
function DPanel:IsEnabled()   return self._enabled end
function DPanel:SetAlpha(a)   self._alpha = a end
function DPanel:GetAlpha()    return self._alpha end
function DPanel:SetName(n)    self._name = n end
function DPanel:GetName()     return self._name end
function DPanel:GetTable()    return self end

-- Docking
function DPanel:Dock(d)       self._dock = d end
function DPanel:GetDock()     return self._dock end
function DPanel:DockMargin(l, t, r, b) end
function DPanel:DockPadding(l, t, r, b) end

-- DPanel specifics
function DPanel:SetPaintBackground(b) self._paintBG = b and true or false end
function DPanel:GetPaintBackground()  return self._paintBG end
function DPanel:SetBackgroundColor(c) self._bgColor = c end
function DPanel:GetBackgroundColor()  return self._bgColor end

-- Input / misc no-ops
function DPanel:MakePopup() end
function DPanel:SetMouseInputEnabled(b) end
function DPanel:SetKeyboardInputEnabled(b) end
function DPanel:MoveToFront() end
function DPanel:MoveToBack() end
function DPanel:SetCursor(c) end
function DPanel:SetTooltip(t) end

return DPanel