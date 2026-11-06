local vgui_New_DPanel    = require("gmodlib/vgui/DPanel")
local vgui_New_DTree     = require("gmodlib/vgui/DTree")
local vgui_New_DImage    = require("gmodlib/vgui/DImage")
local vgui_New_DExpander = require("gmodlib/vgui/DExpander")
local common             = require("common")

local mtVGUI = {}
      mtVGUI.__type = "VGUI"
      mtVGUI.__index = mtVGUI

local function setMeta(pA)
  if(not pA) then return end
  setmetatable(pA, mtVGUI)
  pA.__type = mtVGUI.__type..":"..pA.__type
end

function mtVGUI:Dock(nD)
  common.logStatus("["..self.__type.."]:Dock("..tostring(nD)..")")
end
function mtVGUI:SetTall(nS)
  self.SY = tonumber(nS) or 0
end
function mtVGUI:SetWide(nS)
  self.SX = tonumber(nS) or 0
end
function mtVGUI:SetTooltip(sT)
  common.logStatus("["..self.__type.."]:SetTooltip("..tostring(sT)..")")
end
function mtVGUI:SetIndentSize(nS)
  common.logStatus("["..self.__type.."]:SetIndentSize("..tostring(nS)..")")
end
function mtVGUI:UpdateColours(tS)
  if(tS == nil) then
    common.logStatus("["..self.__type.."]:UpdateColours(nil)"); return end
  self.Skin = tS
end  
function mtVGUI:SetToolTip(sT)
  self:SetTooltip(sT)
end
function mtVGUI:AddItem(vI)
  if(vI == nil) then
    common.logStatus("["..self.__type.."]:AddItem(nil)"); return end
  table.insert(self.Item, vI); self.Item.Size = self.Item.Size + 1
  common.logStatus("["..self.__type.."]:AddItem(["..(vI.__type or type(vI)).."]"..tostring(vI)..")")
  vI.Root = self
end
function mtVGUI:AddNode(sN)
  if(sN == nil) then
    common.logStatus("["..self.__type.."]:AddNode(nil)"); return end
  local pN = vgui.Create("DTree"); self.Node[sN] = pN; return pN
end
function mtVGUI:IsRootNode()
  return (self.Root == nil)
end
function mtVGUI:GetSkin()
  return self.Skin
end

function vgui.Create(sTyp, pPar)
  if(sTyp == "DTree") then
    local pT = vgui_New_DTree()
          pT.Icon = vgui_New_DImage()
          pT.Expander = vgui_New_DExpander()
    setMeta(pT)
    setMeta(pT.Icon)
    setMeta(pT.Expander)
    print(pT, pT.SetToolTip)
    return pT
  elseif(sTyp == "DPanel") then
    local pT = vgui_New_DPanel()
    setMeta(pT)
    return pT
  end
end

