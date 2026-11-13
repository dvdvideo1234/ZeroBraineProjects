-- gmodlib/dtextentry.lua
-- Defines DTextEntry and returns it. Registered by vgui.lua with base DPanel.

require("gmodlib/accessorfunc")

local DTextEntry = {}

-- Class-level defaults (instances shadow them when a setter is called).
-- Mutable tables must NOT be defaults, or every instance would share them.
DTextEntry.m_Text          = ""
DTextEntry.m_Font          = "DermaDefault"
DTextEntry.m_Placeholder   = ""
DTextEntry.m_Numeric       = false
DTextEntry.m_Multiline     = false
DTextEntry.m_Editable      = true
DTextEntry.m_EnterAllowed  = true
DTextEntry.m_UpdateOnType  = false
DTextEntry.m_HistoryOn     = false
DTextEntry.m_Caret         = 0
DTextEntry.m_Focused       = false

-- Accessors
AccessorFunc(DTextEntry, "m_Font",         "Font",            FORCE_STRING)
AccessorFunc(DTextEntry, "m_Placeholder",  "PlaceholderText", FORCE_STRING)
AccessorFunc(DTextEntry, "m_Numeric",      "Numeric",         FORCE_BOOL)
AccessorFunc(DTextEntry, "m_Multiline",    "Multiline",       FORCE_BOOL)
AccessorFunc(DTextEntry, "m_Editable",     "Editable",        FORCE_BOOL)
AccessorFunc(DTextEntry, "m_EnterAllowed", "EnterAllowed",    FORCE_BOOL)
AccessorFunc(DTextEntry, "m_UpdateOnType", "UpdateOnType",    FORCE_BOOL)
AccessorFunc(DTextEntry, "m_HistoryOn",    "HistoryEnabled",  FORCE_BOOL)
AccessorFunc(DTextEntry, "m_TextColor",        "TextColor")
AccessorFunc(DTextEntry, "m_CursorColor",      "CursorColor")
AccessorFunc(DTextEntry, "m_HighlightColor",   "HighlightColor")
AccessorFunc(DTextEntry, "m_PlaceholderColor", "PlaceholderColor")

---------------------------------------------------------------
-- Text
---------------------------------------------------------------
-- SetText is the raw engine setter: it fires no callbacks.
function DTextEntry:SetText(t)
    self.m_Text  = tostring(t)
    self.m_Caret = #self.m_Text
end
function DTextEntry:GetText() return self.m_Text end

-- SetValue is the Derma one: it ignores the call while the user is typing
-- and otherwise fires OnValueChange.
function DTextEntry:SetValue(t)
    if self:IsEditing() then return end
    self:SetText(t)
    self:OnValueChange(self:GetText())
end
function DTextEntry:GetValue() return self.m_Text end

function DTextEntry:GetInt()
    local n = tonumber(self.m_Text)
    if not n then return nil end
    return n >= 0 and math.floor(n) or math.ceil(n)
end
function DTextEntry:GetFloat() return tonumber(self.m_Text) end

function DTextEntry:IsEditing() return self.m_Focused end

-- Caret and selection
function DTextEntry:GetCaretPos() return self.m_Caret end
function DTextEntry:SetCaretPos(n)
    self.m_Caret = math.max(0, math.min(tonumber(n) or 0, #self.m_Text))
end
function DTextEntry:SelectAll() self.m_Caret = #self.m_Text end
function DTextEntry:SelectAllText() self:SelectAll() end

-- History (per-instance table, created lazily)
function DTextEntry:AddHistory(t)
    if not t or t == "" then return end
    self.m_History = self.m_History or {}
    table.insert(self.m_History, t)
end
function DTextEntry:GetHistory() return self.m_History or {} end

---------------------------------------------------------------
-- Focus (these are Panel methods in real GMod)
---------------------------------------------------------------
function DTextEntry:HasFocus() return self.m_Focused end

function DTextEntry:RequestFocus()
    if self.m_Focused then return end
    self.m_Focused   = true
    self.m_FocusText = self.m_Text
    self:OnGetFocus()
end

function DTextEntry:KillFocus()
    if not self.m_Focused then return end
    self.m_Focused = false
    self:OnLoseFocus()
    if self.m_Text ~= self.m_FocusText then
        self:OnValueChange(self.m_Text)
    end
end

function DTextEntry:SetAllowNonAsciiCharacters() end

---------------------------------------------------------------
-- Hooks the addon overrides (empty on purpose)
---------------------------------------------------------------
function DTextEntry:OnEnter(text) end
function DTextEntry:OnChange() end
function DTextEntry:OnValueChange(text) end
function DTextEntry:OnGetFocus() end
function DTextEntry:OnLoseFocus() end
function DTextEntry:OnKeyCode(code) end
function DTextEntry:GetAutoComplete(text) return nil end

-- Return true to block a character from being typed
function DTextEntry:AllowInput(char) return false end

-- Called after the text changed through user input
function DTextEntry:OnTextChanged()
    if self:GetUpdateOnType() then
        self:OnValueChange(self:GetText())
    end
    self:OnChange()
end

---------------------------------------------------------------
-- Test helpers: simulate the user (not part of real GMod)
---------------------------------------------------------------
function DTextEntry:Mock_Focus(b)
    if b == false then self:KillFocus() else self:RequestFocus() end
end

function DTextEntry:Mock_Type(str)
    if not self:GetEditable() then return end
    if not self.m_Focused then self:RequestFocus() end

    for char in tostring(str):gmatch(".") do
        local allowed = true
        if self:GetNumeric() and not char:match("[%d%.%-]") then allowed = false end
        if allowed and self:AllowInput(char) then allowed = false end

        if allowed then
            local t, c = self.m_Text, self.m_Caret
            self.m_Text  = t:sub(1, c) .. char .. t:sub(c + 1)
            self.m_Caret = c + 1
            self:OnTextChanged()
        end
    end
end

function DTextEntry:Mock_Backspace()
    local c = self.m_Caret
    if not self:GetEditable() or c == 0 then return end
    local t = self.m_Text
    self.m_Text  = t:sub(1, c - 1) .. t:sub(c + 1)
    self.m_Caret = c - 1
    self:OnTextChanged()
end

function DTextEntry:Mock_Enter()
    if not self.m_Focused or not self:GetEnterAllowed() then return end
    if self:GetMultiline() then
        self:Mock_Type("\n")
    else
        self:OnEnter(self.m_Text)
    end
end

return DTextEntry
