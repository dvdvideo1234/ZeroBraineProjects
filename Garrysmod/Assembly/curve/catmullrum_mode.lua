local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
                
local com = require("common")

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)

require("gmodlib")
require("trackasmlib")
local asmlib = trackasmlib
if(not asmlib) then error("No library") end
require("Assembly/autorun/folder")
require("Assembly/autorun/config")

asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end
asmlib.SetLogControl(20000, false)
---------------------------------------------------------------------------------------

local v1 = Vector(1,2,3)
local v2 = Vector(3,2,1)
local v3 = Vector(3,2,1)
local v4 = Vector(4,5,6)

--GetCatmullRomCurve
--GetCatmullRomCurveDupe
--GetBezierCurve

for i = 0, 10 do
  local c = asmlib.GetCatmullRomCurve({v1,v2,v3,v4}, i)
  print("------------------", i)
  common.logTable(c,i.."-CRV",{},{["Vector"]=tostring})
end
