local PANEL = {}

function PANEL:Init()
  self.SPX, self.SPY = 265, 0
  self.EDX, self.EDY = 2, 2
  self.SSX, self.SSY = 0, 22
  self.PBX, self.PBY = 0, 0
  self.SBX, self.SBY = 0, 22
  self.Slider = vgui.Create("DNumSlider", self)
  self.Slider:Dock(TOP)
  self.Slider:SetDark(true)
  self.Slider:SetHeight(self.SY)
end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumslider.lua
function PANEL:Slider(sVar, sNam, sTyp)
  self.Slider:SetText(sNam)
  self.Slider:SetConVar(sVar)
  self.Slider:SizeToContents()
  if(sTyp ~= nil) then self.Slider:SetTooltip() end
  self:AddItem(self.Slider)
end

function PANEL:Limits(nMin, nMax, nDef, iDig)
  self.Slider:SetMinMax(nMin, nMax)  
  if(iDig != nil) then self.Slider:SetDecimals(iDig) end
  if(nDef != nil) then self.Slider:SetDefaultValue(nDef) end
  self.Slider:UpdateNotches()
end

function PANEL:SetTall(nS, nB)
  if(nS) then self.SSY = math.floor(nS) end
  if(nB) then self.SBY = math.floor(nB) end
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
  end
end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dbutton.lua
function PANEL:Button(fAct, sNam, sTyp)
  local pBut = vgui.Create("DButton", self)
  local tBut = self.Button
  if(not tBut) then tBut = {Size = 0} else
    if(not tBut.Size) then tBut.Size = 0 end
    if(tBut.Size < 0) then table.Clear(tBut); tBut.Size = 0 end
  end
  local iSiz = (self.Button.Size + 1); tBut[iSiz] = pBut
  pBut:SetText(sNam); if(sTyp ~= nil) then pBut:SetTooltip(sTyp) end
  pBut.DoClick = function()
    local pS, sE = pcall(fAct, pBut, self.Slider)
    if(not pS) then error("Button("..pBut:GetText().."): "..sE)
  end
  pBut.DoRightClick = function()
    SetClipboardText(pBut:GetText())
  end
  self.Button = tBut
  self.Button.Size = iSiz
  return pBut
end

function PANEL:GetButtonID(vD)
  local iD = math.floor(tonumber(vD) or 0)
  if(iD <= 0) then return nil end
  if(not self.Button) then return nil end
  return self.Button[iD]
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

derma.DefineControl("DButtonSlider", "Button interactive slider", PANEL, "DCollapsibleCategory")
