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
local rev = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT/lua/"

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)

require("gmodlib")
dofile(rev.."trackassembly/trackasmlib.lua")
local asmlib = trackasmlib
if(not asmlib) then error("No library") end
require("Assembly/autorun/folder")
dofile(rev.."autorun/trackassembly_init.lua")

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
asmlib.ExportTypeRUN(sE)
asmlib.ExportTypeDSV(sE)
asmlib.ExportTypeTRN(sE)
asmlib.ExportDSV("PIECES", sG, nil, true)
asmlib.ExportDSV("ADDITIONS", sG, nil, true)
asmlib.ExportDSV("PHYSPROPERTIES", sG, nil, true)
asmlib.ExportSyncDB()


