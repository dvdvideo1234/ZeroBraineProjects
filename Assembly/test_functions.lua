local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE").setBase(1)

local com = require("common")
local cpx = require("complex")
require("dvdlualib/gmodlib")
require("dvdlualib/trackasmlib")
local asmlib = trackasmlib
asmlib.InitBase("track","assembly")
asmlib.SetLogControl(1000, false)
local mathMax = math.max
local mathMin = math.min
local mathCeil = math.ceil
local mathFloor = math.floor
local function IsHere(a) return a~= nil end
local function GetBorder(a) return a~= nil end
local function GetReport1(a) return "X1" end
local function GetReport2(a) return "X2" end
local function LogInstance(...) print(...) end
local function languageGetPhrase(...) print(...) end

function SetNumSlider(cPanel, sVar, vDig, vMin, vMax, vDev)
  local nMin, nMax, nDev = tonumber(vMin), tonumber(vMax), tonumber(vDev)
  local sTool, tConv = asmlib.GetOpVar("TOOLNAME_NL"), asmlib.GetOpVar("STORE_CONVARS") or {}
  local sKey, sNam, bExa, nDum = asmlib.GetNameExp(sVar)
  local sBase = (bExa and sNam or ("tool."..sTool.."."..sNam))
  local iDig = mathFloor(mathMax(tonumber(vDig) or 0, 0))
  -- Read minimum value form the first available
  if(not IsHere(nMin)) then nMin, nDum = GetBorder(sKey)
    if(not IsHere(nMin)) then nMin = asmlib.GetAsmConvar(sVar, "MIN")
      if(not IsHere(nMin)) then -- Mininum bound is not located
        nMin = -mathAbs(2 * mathFloor(asmlib.GetAsmConvar(sVar, "FLT")))
        LogInstance("(L) Miss "..GetReport1(sKey))
      else LogInstance("(L) Cvar "..GetReport2(sKey, nMin)) end
    else LogInstance("(L) List "..GetReport2(sKey, nMin)) end
  else LogInstance("(L) Args "..GetReport2(sKey, nMin)) end
  -- Read maximum value form the first available
  if(not IsHere(nMax)) then nDum, nMax = GetBorder(sKey)
    if(not IsHere(nMax)) then nMax = asmlib.GetAsmConvar(sVar, "MAX")
      if(not IsHere(nMax)) then -- Maximum bound is not located
        nMax = mathAbs(2 * mathCeil(asmlib.GetAsmConvar(sVar, "FLT")))
        LogInstance("(H) Miss "..GetReport1(sKey))
      else LogInstance("(H) Cvar "..GetReport2(sKey, nMax)) end
    else LogInstance("(H) List "..GetReport2(sKey, nMax)) end
  else LogInstance("(H) Args "..GetReport2(sKey, nMax)) end
  -- Read default value form the first available
  if(not IsHere(nDev)) then nDev = tConv[sKey]
    if(not IsHere(nDev)) then nDev = asmlib.GetAsmConvar(sVar, "DEF")
      if(not IsHere(nDev)) then nDev = nMin + ((nMax - nMin) / 2)
        LogInstance("(D) Miss "..GetReport1(sKey))
      else LogInstance("(D) Cvar "..GetReport2(sKey, nDev)) end
    else LogInstance("(D) List "..GetReport2(sKey, nDev)) end
  else LogInstance("(D) Args "..GetReport2(sKey, nDev)) end
  -- Create the slider control using the min, max and default
  print(sMenu, sKey, nMin, nMax, iDig, nDev)
  
  
  local sMenu, sTtip = languageGetPhrase(sBase.."_con"), languageGetPhrase(sBase)
  local pItem = cPanel:NumSlider(sMenu, sKey, nMin, nMax, iDig)
  pItem:SetTooltip(sTtip); pItem:SetDefaultValue(nDev); return pItem
end

SetNumSlider(nil, "test", 3, -5, 5)