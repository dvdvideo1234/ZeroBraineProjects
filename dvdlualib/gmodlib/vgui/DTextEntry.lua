local function vgui_New_DTextEntry(...)
  local self = {__type = "DTextEntry"}
  local m_Text = ""
  local PX, PY = 0, 0
  local SX, SY = 0, 0
  function self:OnValueChange( strValue )
    -- For Override
  end
  function self:GetText()
    return m_Text
  end 
  function self:SetText(sT)
    m_Text = tostring(sT or "")
    self:OnValueChange(m_Text)
  end  
  return self
end

return vgui_New_DTextEntry
