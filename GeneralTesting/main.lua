require("ZeroBraineProjects/dvdlualib/common")

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


local s = "models/ron/2ft/curves/curve_45_right_4.mdl"

local a = function(m)
  local r = stringGsub(m,"models/ron/2ft/","")
        r = stringSub(r,1,stringFind(r,"/")-1)
        r = stringUpper(stringSub(r,1,1))..stringLower(stringSub(r,2,-1))
  return r
end


LogLine(a(s))