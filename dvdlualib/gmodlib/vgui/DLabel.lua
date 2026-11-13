-- gmodlib/dlabel.lua
-- Defines DLabel and returns it. Registered by vgui.lua with base DPanel.

require("gmodlib/accessorfunc")

local DLabel = {}

-- Defaults live on the class. Instances read them through __index and
-- shadow them as soon as a setter is called, so nothing needs Init/Construct
-- and DPanel:Construct is never overridden.
DLabel.m_Text      = ""
DLabel.m_Font      = "DermaDefault"
DLabel.m_Wrap      = false
DLabel.m_Dark      = false
DLabel.m_Disabled  = false
DLabel.m_Alignment = 4          -- numpad layout: 4 = left, 5 = center, 6 = right
DLabel.m_StretchV  = false
DLabel.m_InsetX    = 0
DLabel.m_InsetY    = 0

-- Text
function DLabel:SetText(t)  self.m_Text = tostring(t) end
function DLabel:GetText()   return self.m_Text end
DLabel.SetValue = DLabel.SetText   -- DLabel aliases
DLabel.GetValue = DLabel.GetText

-- Accessors
AccessorFunc(DLabel, "m_Font",      "Font",                FORCE_STRING)
AccessorFunc(DLabel, "m_Wrap",      "Wrap",                FORCE_BOOL)
AccessorFunc(DLabel, "m_Dark",      "Dark",                FORCE_BOOL)
AccessorFunc(DLabel, "m_Disabled",  "Disabled",            FORCE_BOOL)
AccessorFunc(DLabel, "m_Alignment", "ContentAlignment",    FORCE_NUMBER)
AccessorFunc(DLabel, "m_StretchV",  "AutoStretchVertical", FORCE_BOOL)

-- Text color. Plain table with r/g/b/a; no dependency on Color().
function DLabel:SetTextColor(c) self.m_TextColor = c end
function DLabel:GetTextColor()
    return self.m_TextColor or { r = 255, g = 255, b = 255, a = 255 }
end

-- Inset
function DLabel:SetTextInset(x, y) self.m_InsetX, self.m_InsetY = x, y end
function DLabel:GetTextInset()     return self.m_InsetX, self.m_InsetY end

-- Click hooks the addon overrides (empty on purpose)
function DLabel:DoClick() end
function DLabel:DoRightClick() end
function DLabel:DoDoubleClick() end
function DLabel:DoMiddleClick() end

-- Needs real font metrics, which don't exist outside the game
function DLabel:SizeToContents() end
function DLabel:SizeToContentsX() end
function DLabel:SizeToContentsY() end

return DLabel