local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(1)
      
local com = require("common")

require("gmodlib")
require("laserlib")
local corm = require("colormap")
HSVToColor = corm.getColorHSV
local cor = Color(128, 255, 50)

LaserLib.GetData("WDHUESTP"):SetData("10")
LaserLib.GetData("WDRGBMAR"):SetData("10")



print(table.concat(LaserLib.GetData("HARUNTM"),"|"))

local function co_tostring(co)
  local f = ("%3d")
  r = f:format(co.r)
  g = f:format(co.g)
  b = f:format(co.b)
  return "("..r.." "..g.." "..b..")"
end

local tW = LaserLib.SetWaveArray(cor)
for i = 1, tW.Size do
  print("WAVE", ("%3d"):format(i), ("%.5f"):format(tW[i].P),
    co_tostring(tW[i].C), ("%.3f"):format(tW[i].W), tW[i].B and "V" or "X")
end

print("PW", tW.PW)
print("PC", tW.PC)
print("PS", tW.PS)
