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

local enr, set = 20, {Size = 0, Sump = 0}
local cor = Color(255, 0, 200, 255)
-- local cor = Color(255, 255, 255, 255)

LaserLib.GetData("WDHUESTP"):SetData("30")
LaserLib.GetData("WDRGBMAR"):SetData("10")

local tW = LaserLib.GetWaveArray(cor)
-- com.logTable(tW, "GET")
for iW = tW.IS, tW.IE do
  local recw = tW[iW] -- Current component
  local rCo, rPw, rEn = recw.C, recw.P, (recw.P / tW.PT)
  sr, sg, sb = (rCo.r * rPw), (rCo.g * rPw), (rCo.b * rPw)
  table.insert(set, rEn)
  set.Size = set.Size + 1
  set.Sump = set.Sump + rEn
end

com.logTable(set, "POWER")
