local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(1)
                
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

--local sT = "Multy Type"
local sT = "Shinji85's Rails"

local sP = asmlib.GetTypePrefix(sT)
local sE, tC = sT, {}
local sG = asmlib.GetOpVar("DBEXP_PREFGEN")
local sM = asmlib.GetOpVar("MODE_DATABASE")

require(("Assembly/autorun/z_autorun_[%s]"):format(sP))

local sU, tA, nA = asmlib.ComponentType(sT)
asmlib.Log(asmlib.GetReport(sU, tA, nA))
asmlib.LogTable(tA)

asmlib.ImportDSV("PIECES", true, sP)
asmlib.ImportDSV("ADDITIONS", true, sP)
asmlib.ImportCategory(0, sP, false)


asmlib.IsFlag("file_read_once", false)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end

tC[sU] = asmlib.GetOpVar("TABLE_CATEGORIES")[sU]
for iD = 1, nA do local sA = tA[iD]
  tC[sA] = asmlib.GetOpVar("TABLE_CATEGORIES")[sA]
end

asmlib.ExportCategory(3, tC, "["..sM.."-cat]"..sP, true)
asmlib.ExportTypeRun(sE)
asmlib.ExportTypeDSV(sE)
asmlib.ExportTypeTrn(sE)
asmlib.ExportDSV("PIECES", sG, nil, true)
asmlib.ExportDSV("ADDITIONS", sG, nil, true)
asmlib.ExportDSV("PHYSPROPERTIES", sG, nil, true)
asmlib.ExportSyncDB()


