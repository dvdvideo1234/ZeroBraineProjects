local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)
      
local com = require("common")
local cmp = require("colormap")
local sbs, ibs = drpath.getBase()
local rps = {
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/LaserSTool",
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/LaserSTool"
}

require("gmodlib")

dofile(rps[ibs].."/lua/autorun/laserlib.lua")

local bm = LaserLib.Beam(Vector(), Vector(0, 0, 1), 100)

print(bm:GetRatioFresnel(1, 1.333, math.sqrt(2) / 2))
--bm:SetPolarize(Vector(1,0,-1), Vector(0, 0, 1), true)
print(bm:GetPolarize())