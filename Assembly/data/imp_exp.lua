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
asmlib.SetLogControl(20000, false)

local sG = asmlib.GetOpVar("DBEXP_PREFGEN")
local sM = asmlib.GetOpVar("MODE_DATABASE")
local sT = "Shinji85's Rails"
local sP = asmlib.GetTypePrefix(sT)
local sE = sT
require(("Assembly/autorun/z_autorun_[%s]"):format(sP))

asmlib.ImportDSV("PIECES", true, sP)
asmlib.ImportDSV("ADDITIONS", true, sP)
asmlib.ImportCategory(0, sP, false)


asmlib.IsFlag("file_read_once", false)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end
local tC = {[sT] = asmlib.GetOpVar("TABLE_CATEGORIES")[sT]}

asmlib.ExportCategory(3, tC, "["..sM.."-cat]"..sP, true)
asmlib.ExportTypeRun(sE)
asmlib.ExportTypeDSV(sE)
asmlib.ExportTypeTrn(sE)
asmlib.ExportDSV("PIECES", sG, nil, true)
asmlib.ExportDSV("ADDITIONS", sG, nil, true)
asmlib.ExportDSV("PHYSPROPERTIES", sG, nil, true)
asmlib.ExportSyncDB()
