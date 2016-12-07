require("ZeroBraineProjects/dvdlualib/common")

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
--local stringExplode        = string and string.Explode
local surfaceScreenWidth   = surface and surface.ScreenWidth
local surfaceScreenHeight  = surface and surface.ScreenHeight
local duplicatorStoreEntityModifier = duplicator and duplicator.StoreEntityModifier

local a = {29,2,3}

logStatus(nil, "encNumber: "..encNumber(a))

local b = decNumber(encNumber(a))

for i = 1, #a do
  if(tonumber(b[i]) == tonumber(a[i])) then
    logStatus(nil, "Compate OK: "..i.." {"..tostring(b[i])..", "..a[i].."}") end
end






