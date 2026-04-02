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

require("gmodlib")
require("laserlib")

HSVToColor = function(H, S, V)
  local r, g, b = cmp.getColorHSV(H, S, V)
  return Color(r, g, b, 255)
end

LaserLib.GetData("WDHUECNT"):SetData(25)

local d, p = {r=0,g=0,b=0}
local cor = Color(255, 0, 200, 255)
--local cor = Color(255, 255, 255, 255)

function l(c)
  return ("[%5.3f|%5.3f|%5.3f]"):format(c.r, c.g, c.b)
end
local tW = LaserLib.GetWaveArray(cor)


for i = 1, tW.Size do
  local w = tW[i]
  print(("[%3d]"):format(i), "  ", l(w.C), "  ", w.P, tostring(w.B))
end

--com.logTable(tW)
