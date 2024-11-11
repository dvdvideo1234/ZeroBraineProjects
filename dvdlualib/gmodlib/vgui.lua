require("gmodlib/vgui/DPanel")
require("gmodlib/vgui/DTree")
require("gmodlib/vgui/DImage")
require("gmodlib/vgui/DExpander")

local mtVGUI = {__type = "VGUI"}
      mtVGUI.__index = mtVGUI

function mtVGUI:Dock(nD)
  common.logStatus("VGUI["..mtVGUI.__type.."]:Dock("..tostring(nD)..")")
end
function mtVGUI:SetTall(nS)
  self.SY = tonumber(nS) or 0
end
function mtVGUI:SetWide(nS)
  self.SX = tonumber(nS) or 0
end
function mtVGUI:SetTooltip(sT)
  common.logStatus("VGUI["..mtVGUI.__type.."]:SetTooltip("..tostring(sT)..")")
end
function mtVGUI:SetIndentSize(nS)
  common.logStatus("VGUI["..mtVGUI.__type.."]:SetIndentSize("..tostring(nS)..")")
end
function mtVGUI:UpdateColours(tS)
  if(tS == nil) then
    common.logStatus("VGUI["..mtVGUI.__type.."]:UpdateColours(nil)"); return end
  self.Skin = tS
end  
function mtVGUI:SetToolTip(sT)
  mtVGUI:SetTooltip(sT)
end
function mtVGUI:AddItem(vI)
  if(vI == nil) then
    common.logStatus("VGUI["..mtVGUI.__type.."]:AddItem(nil)"); return end
  table.insert(self.Item, vI); self.Item.Size = self.Item.Size + 1
  common.logStatus("VGUI["..mtVGUI.__type.."]:AddItem(["..(vI.__type or type(vI)).."]"..tostring(vI)..")")
  vI.Root = mtVGUI
end
function mtVGUI:AddNode(sN)
  if(sN == nil) then
    common.logStatus("VGUI["..mtVGUI.__type.."]:AddNode(nil)"); return end
  local pN = vgui.Create("DTree"); self.Node[sN] = pN; return pN
end
function mtVGUI:IsRootNode()
  return (mtVGUI.Root == nil)
end
function mtVGUI:GetSkin()
  return self.Skin
end

function vgui.Create(sTyp, pPar)
  if(sTyp == "DTree") then
    local pT = vgui_New_DTree()
          pT.Icon = vgui_New_DImage()
          pT.Expander = vgui_New_DExpander()
    setmetatable(pT, mtVGUI)
    setmetatable(pT.Icon, mtVGUI)
    setmetatable(pT.Expander, mtVGUI)
    return pT
  elseif(sTyp == "DPanel") then
    local pT = vgui_New_DPanel()
    setmetatable(pT, mtVGUI)
    return pT
  end
end

