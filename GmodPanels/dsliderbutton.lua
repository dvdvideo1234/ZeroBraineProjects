local PANEL = {}

function PANEL:Init()
  self.PDX, self.PDY = 10, 10
  self.SPX, self.SPY = 260, 0
  self.EDX, self.EDY = 2, 2
  -- Slider position and size
  self.PSX, self.PSY = 0, 0
  self.SSX, self.SSY = 0, 22
  -- Button position and size
  self.PBX, self.PBY = 0, 0
  self.SBX, self.SBY = 0, 22
end

function PANEL:SetDelta(nX, nY)
  local eX = (tonumber(nX) or 2)
  if(eX >= 0) then self.EDX = eX end
  local eY = (tonumber(nN) or 2)
  if(eY >= 0) then self.EDY = eY end
  return self
end

function PANEL:GetDelta()
  return self.EDX, self.EDY
end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumslider.lua
function PANEL:SetSlider(sVar, sNam, sTyp)
  self.Slider = vgui.Create("DNumSlider", self)
  self.Slider:SetParent(self)
  self.Slider:SetTall(self.SSY)
  self.Slider:SetText(sNam)
  self.Slider:SetConVar(sVar)
  self.Slider:SizeToContents()
  if(sTyp ~= nil) then self.Slider:SetTooltip() end
  return self
end

function PANEL:GetSlider()
  return self.Slider
end

function PANEL:Configure(nMin, nMax, nDef, iDig)
  self.Slider:SetMin(tonumber(nMin) or -10)
  self.Slider:SetMax(tonumber(nMax) or  10)
  if(iDig ~= nil) then self.Slider:SetDecimals(iDig) end
  if(nDef ~= nil) then self.Slider:SetDefaultValue(nDef) end
  self.Slider:UpdateNotches(); return self
end

function PANEL:SetTall(nP, nS, nB)
  if(nP) then self.SPY = math.floor(nP) end
  if(nS) then self.SSY = math.floor(nS) end
  if(nB) then self.SBY = math.floor(nB) end
  return self
end

function PANEL:GetTall()
  return self.SPY, self.SSY, self.SBY
end

function PANEL:SetWide(vW)
  local nW = tonumber(vW)
  if(nW and nW >= 0) then self.SPX = math.floor(nW) end
  print("SPX", self.SPX)
  self.SPY = math.floor(self.SSY + 2 * self.PDY)
  self.SSX = math.floor(self.SPX - 2 * self.PDX)
  self.PSX = self.PDX -- Slider position X
  self.PSY = self.PDY -- Slider position Y
  self.Slider:SetPos(self.PSX, self.PSY)
  self.Slider:SetSize(self.SSX, self.SSY)
  print("SLD", self.SSX, self.SSY)
  local tBut = self.Array
  if(tBut and tBut.Size and tBut.Size > 0) then
    self.PBX = self.PSX -- Store the current X for button position
    self.PBY = math.ceil(self.PSY + self.SSY + 0.5 * self.PDY) -- Button position Y
    self.SPY = math.ceil(self.SSY + self.SBY + 2.5 * self.PDY)
    self.SBX = math.ceil((self.SPX - (tBut.Size - 1) - 2 * self.PDX) / tBut.Size)
    for iD = 1, tBut.Size do
      tBut[iD]:SetPos(self.PBX, self.PBY)
      tBut[iD]:SetSize(self.SBX, self.SBY)
      self.PBX = self.PBX + self.SBX + self.EDX
    end
  end; return self
end

function PANEL:GetWide()
  return self.SPX, self.SSX, self.SBX
end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dbutton.lua
function PANEL:SetButton(fAct, sNam, sTyp)
  local pBut = vgui.Create("DButton", self)
  local tBut = self.Array
  if(not tBut) then -- No button table. Create one
    tBut = {Size = 0} -- Create button array
    self.Array = tBut -- Write down the array
  else -- Attempt to fix arror in the sequence
    if(not tBut.Size) then tBut.Size = 0 end
    if(tBut.Size < 0) then table.Empty(tBut); tBut.Size = 0 end
  end -- Retrieve the buttons array
  print("SPOS", self.Slider:GetPos())
  print("SSIZ", self.Slider:GetSize())

  local iSiz = (tBut.Size + 1); table.insert(tBut, pBut)
  pBut:SetParent(self); pBut:SetText(sNam)
  if(sTyp ~= nil) then pBut:SetTooltip(tostring(sTyp)) end
  pBut.DoClick = function()
    local pS, sE = pcall(fAct, pBut, self.Slider, self.Slider:GetValue())
    if(not pS) then error("["..pBut:GetText().."]: "..sE) end
  end
  pBut.DoRightClick = function()
    SetClipboardText(pBut:GetText())
  end
  self.Array.Size = iSiz
  return self
end

function PANEL:GetButton(vD)
  local iD = math.floor(tonumber(vD) or 0)
  if(iD <= 0) then return nil end
  local tBut = self.Array
  if(not tBut) then return nil end
  return tBut[iD]
end

function PANEL:RemoveButton(vD)
  local iD = math.floor(tonumber(vD) or 0)
  if(iD < 0) then return self end
  local tBut = self.Array
  if(not tBut) then return self end
  local iB = ((iD > 0) and iD or nil)
  local pBut = table.remove(tBut, iB)
  if(pBut) then
    pBut:Remove()
    tBut.Size = tBut.Size + 1
  end; return self
end

function PANEL:UpdateColours(tSkin)
  if(self.Slider.UpdateColours) then
    self.Slider:UpdateColours(tSkin)
  end
  if(self.Array.Size > 0) then
    for iD = 1, self.Array.Size do pBut = self.Array[iD]
      if(pBut.UpdateColours) then pBut:UpdateColours(tSkin) end
    end
  end
end

function PANEL:ApplySchemeSettings()
  self.Slider:ApplySchemeSettings()
  local tBut = self.Array
  if(not tBut) then return self end
  if(not tBut.Size) then return self end
  if(tBut.Size <= 0) then return self end
  for iD = 1, tBut.Size do
    local vBut = tBut[iD]
    if(vBut.ApplySchemeSettings) then
      vBut:ApplySchemeSettings() end
  end; return self
end

derma.DefineControl("DSliderButton", "Button-interactive slider", PANEL, "DSizeToContents")
