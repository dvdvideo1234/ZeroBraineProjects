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

asmlib.IsFlag("file_read_once", false)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end
asmlib.SetLogControl(20000, false)

asmlib.ExportTypeTrn("SligWolf_s_Suspension_Train")
asmlib.ExportTypeRun("SligWolf_s_Suspension_Train")
asmlib.ExportTypeDSV("SligWolf_s_Suspension_Train")
asmlib.ExportDSV("PIECES", "generic_")
asmlib.ExportSyncDB()
