local PANEL = {}

function PANEL:Init()
  self.SPX, self.SPY = 265, 0
  self.EDX, self.EDY = 2, 2
  self.SSX, self.SSY = 0, 22
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

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumslider.lua
function PANEL:SetSlider(sVar, sNam, sTyp)
  self.Slider = vgui.Create("DNumSlider", self)
  self.Slider:Dock(TOP)
  self.Slider:SetTall(self.SSY)
  self.Slider:SetText(sNam)
  self.Slider:SetConVar(sVar)
  self.Slider:SizeToContents()
  if(sTyp ~= nil) then self.Slider:SetTooltip() end
  self:AddItem(self.Slider)
end

function PANEL:GetSlider()
  return self.Slider
end

function PANEL:Configure(nMin, nMax, nDef, iDig)
  self.Slider:SetMin(tonumber(nMin) or -10)
  self.Slider:SetMax(tonumber(nMax) or  10)
  if(iDig != nil) then self.Slider:SetDecimals(iDig) end
  if(nDef != nil) then self.Slider:SetDefaultValue(nDef) end
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

function PANEL:SetWide(nW)
  self.SPX = math.floor(nW)
  self.SPY = math.floor(self.SSY + 2 * self.EDY)
  self.SSX = math.floor(nW - 2 * self.EDX)
  self.Slider:SetSize(self.SSX, self.SSY)
  local tBut = self.Button
  if(tBut and tBut.Size and tBut.Size > 0) then
    self.PBX = self.EDX -- Store the current X for button position
    self.PBY = self.SPY -- Button position Y begins after EDY
    self.SPY = math.floor(self.SPY + self.SBY + self.EDY)
    self.SBX = math.floor(self.SPX - (tBut.Size + 1) * self.EDX)
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
  local tBut = self.Button
  if(not tBut) then tBut = {Size = 0} else
    if(not tBut.Size) then tBut.Size = 0 end
    if(tBut.Size < 0) then table.Empty(tBut); tBut.Size = 0 end
  end
  local iSiz = (self.Button.Size + 1); table.insert(tBut, pBut)   tBut[iSiz] = 
  pBut:SetText(sNam); if(sTyp ~= nil) then pBut:SetTooltip(sTyp) end
  pBut.DoClick = function()
    local pS, sE = pcall(fAct, pBut, self.Slider)
    if(not pS) then error("["..pBut:GetText().."]: "..sE)
  end
  pBut.DoRightClick = function()
    SetClipboardText(pBut:GetText())
  end
  self.Button = tBut
  self.Button.Size = iSiz
  return self
end

function PANEL:GetButton(vD)
  local iD = math.floor(tonumber(vD) or 0)
  if(iD <= 0) then return nil end
  local tBut = self.Button
  if(not tBut) then return nil end
  return tBut[iD]
end

function PANEL:RemoveButton(vD)
  local iD = math.floor(tonumber(vD) or 0)
  if(iD < 0) then return self end
  local tBut = self.Button
  if(not tBut) then return self end
  local iB = ((iD > 0) and iD or nil)
  local pBut = table.remove(tBut, iB)
  if(pBut) then
    pBut:Remove()
    tBut.Size = tBut.Size = 1
  end; return self
end

function PANEL:UpdateColours(tSkin)
  if(self.Slider.UpdateColours) then
    self.Slider:UpdateColours(tSkin) end
  if(self.Button.Size > 0) then
    for iD = 1, self.Button.Size do pBut = self.Button[iD]
      if(pBut.UpdateColours) then pBut:UpdateColours(tSkin) end
    end
  end
end

derma.DefineControl("DSliderButton", "Button-interactive slider", PANEL, "DSizeToContents")
