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

LaserLib.GetData("WDHUECNT"):SetData(10)

local d, p = {r=0,g=0,b=0}
local cor = Color(255, 255, 0, 255)
--local cor = Color(255, 255, 255, 255)

function x(a)
  return ("[%5.3f|%5.3f|%5.3f]"):format(a.r, a.g, a.b)
end

function y(a)
  return ("%5.3f"):format(a)
end

function z(a)
  return ("%3d"):format(a)
end


function p(w)
  local s = 0
  local tW = LaserLib.GetWaveArray(w)
  print("Input:", x(w))
  for i = 1, tW.Size do
    local w = tW[i]
    print(z(i), "  ", x(w.C), "  ", y(w.P), tostring(w.B), w.P)
    s = s + w.P
  end
  print("Idx", tW.IS, tW.IE)
  print("Sum", s)
end



p(Color(255, 0  , 0  ))
p(Color(0  , 255, 0  ))
p(Color(0  , 0  , 255))
p(Color(255, 255, 0  ))
p(Color(0  , 255, 255))
p(Color(255, 0  , 255))
p(Color(255, 255, 255))

--com.logTable(tW)
