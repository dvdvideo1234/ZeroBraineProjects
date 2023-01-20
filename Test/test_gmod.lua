local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE").setBase(1)

function SetNumSlider(cPanel, sVar, vDig, vMin, vMax, vDev)
  local nMin, nMax, nDev = tonumber(vMin), tonumber(vMax), tonumber(vDev)
  local sTool, tConv = GetOpVar("TOOLNAME_NL"), GetOpVar("STORE_CONVARS")
  local sKey, sNam, bExa, nDum = GetNameExp(sVar)
  local sBase = (bExa and sNam or ("tool."..sTool.."."..sNam))
  local iDig = mathFloor(mathMax(tonumber(vDig) or 0, 0))
  -- Read default value form the first available
  if(not IsHere(nDev)) then nDev = tConv[sKey]
    if(not IsHere(nDev)) then nDev = GetAsmConvar(sVar, "DEF")
      if(not IsHere(nDev)) then nDev = 0 -- Default
        LogInstance("(D) Miss "..GetReport1(sKey))
      else LogInstance("(D) Cvar "..GetReport2(sKey, nDev)) end
    else LogInstance("(D) List "..GetReport2(sKey, nDev)) end
  else LogInstance("(D) Args "..GetReport2(sKey, nDev)) end
  -- Read minimum value form the first available
  if(not IsHere(nMin)) then nMin, nDum = GetBorder(sKey)
    if(not IsHere(nMin)) then nMin = GetAsmConvar(sVar, "MIN")
      if(not IsHere(nMin)) then -- Mininum bound is not located
        nMin = -mathAbs(2 * mathFloor(GetAsmConvar(sVar, "FLT")))
        LogInstance("(L) Miss "..GetReport1(sKey))
      else LogInstance("(L) Cvar "..GetReport2(sKey, nMin)) end
    else LogInstance("(L) List "..GetReport2(sKey, nMin)) end
  else LogInstance("(L) Args "..GetReport2(sKey, nMin)) end
  -- Read maximum value form the first available
  if(not IsHere(nMax)) then nDum, nMax = GetBorder(sKey)
    if(not IsHere(nMax)) then nMax = GetAsmConvar(sVar, "MAX")
      if(not IsHere(nMax)) then -- Maximum bound is not located
        nMax = mathAbs(2 * mathCeil(GetAsmConvar(sVar, "FLT")))
        LogInstance("(H) Miss "..GetReport1(sKey))
      else LogInstance("(H) Cvar "..GetReport2(sKey, nMax)) end
    else LogInstance("(H) List "..GetReport2(sKey, nMax)) end
  else LogInstance("(H) Args "..GetReport2(sKey, nMax)) end
  -- Create the slider control using the min, max and default
  local sMenu, sTtip = languageGetPhrase(sBase.."_con"), languageGetPhrase(sBase)
  local pItem = cPanel:NumSlider(sMenu, sKey, nMin, nMax, iDig)
  pItem:SetTooltip(sTtip); pItem:SetDefaultValue(nDev); return pItem
end