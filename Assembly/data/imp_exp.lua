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
asmlib = trackasmlib
if(not asmlib) then error("No library") end
require("Assembly/autorun/config")

asmlib.IsModel = function(m) return isstring(m) end
asmlib.SetLogControl(20000, false)

local tC = asmlib.GetOpVar("TABLE_CATEGORIES")

asmlib.ImportDSV("PIECES", true, "tst_", nil, true)
asmlib.ExportDSV("PIECES", "new_", nil, true)


  