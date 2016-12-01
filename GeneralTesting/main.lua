require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/asmlib")

local pairs                = pairs
local Angle                = Angle
local Vector               = Vector
local IsValid              = IsValid
local tonumber             = tonumber
local tostring             = tostring
local CreateConVar         = CreateConVar
local bitBor               = bit and bit.bor
local mathFloor            = math and math.floor
local vguiCreate           = vgui and vgui.Create
local fileExists           = file and file.Exists
local stringSub            = string and string.sub
local stringFind           = string and string.find
local stringGsub           = string and string.gsub
local stringUpper          = string and string.upper
local stringLower          = string and string.lower
local stringExplode        = string and string.Explode
local surfaceScreenWidth   = surface and surface.ScreenWidth
local surfaceScreenHeight  = surface and surface.ScreenHeight
local duplicatorStoreEntityModifier = duplicator and duplicator.StoreEntityModifier


function encNumber(arNum)
  local sTab = table.concat(arNum, ".")
  return sTab
end


logStatus(nil, encNumber({1,2,3}))

local s = "(4 * (((DBR < DBL) and DBR or DBL) - ((DFR < DFL) and DFR or DFL)))"

  function getDeviation(sSen, ...)
    local id, pack, rez = 1, {...}, sSen; while(pack[id]) do
      rez = rez:gsub(pack[id],"oSens["..pack[id].."].Val"); id = id + 1
    end; return "function(oSens) return "..rez.." end"
  end

local dev = getDeviation(s,"DBR","DBL","DFR","DFL")

logStatus(nil, dev)











