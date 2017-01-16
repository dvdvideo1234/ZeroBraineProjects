require("ZeroBraineProjects/dvdlualib/common")
-- require("ZeroBraineProjects/dvdlualib/gmodlib")

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

local a = CompileString("function (oSens) return oSens[1] end")

z = {77}

logStatus(a(Z))

