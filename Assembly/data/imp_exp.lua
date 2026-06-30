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
local bas = dir.getBase().."/ZeroBraineProjects/"

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)
require("gmodlib")

game.SinglePlayer(false)

local function CongigureLIB(sRev)
  -- single source of truth
  dofile(sRev.."trackassembly/trackasmlib.lua")
  local asmlib = trackasmlib 
  if not asmlib then error("No library") end
  local SetOpVar = asmlib.SetOpVar
  asmlib.SetOpVar = function(n, ...)
    if (n ~= "DIRPATH_BAS") then
      return SetOpVar(n, ...)
    else  
      return SetOpVar(n, bas.."Assembly/trackassembly/")
    end
  end
  local gnIndependentUsed = bit.bor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
  local NewAsmConvar = asmlib.NewAsmConvar
  CreateConVar("trackassembly_logsmax", 0, gnIndependentUsed, "Maximum logging lines being written before the counter is reset", 0, 100000)
  CreateConVar("trackassembly_logsbrs", 0, gnIndependentUsed, "Maximum logging lines being written in every I/O write flush", 0, 100000)
  asmlib.NewAsmConvar = function(n, ...)
    if (n ~= "logsmax" and n ~= "logsbrs") then
      return NewAsmConvar(n, ...)
    end
  end
  dofile(sRev.."autorun/trackassembly_init.lua")
  asmlib.SetLogControl(1,0)
  return asmlib
end

local asmlib = CongigureLIB(rev)

asmlib.IsFlag("file_read_once", false)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end

-------- CUSTOM TEST --------
local sS = "set"
--local sS = "run"
local sT = "Multy Type"
--local sT = "test_s_track_pack"

local sP = asmlib.GetTypePrefix(sT)
local sE, tC = sP, {}
local sG = asmlib.GetOpVar("DBEXP_PREFGEN")
local sM = asmlib.GetOpVar("MODE_DATABASE")

require(("Assembly/autorun/z_auto"..sS.."_[%s]"):format(sP))

if(sS == "run") then
  asmlib.ImportDSV("PIECES", true, sP)
  asmlib.ImportDSV("ADDITIONS", true, sP)
  asmlib.ImportCategory(0, sP, false)
end

asmlib.WorkshopID(sP, tostring(0):rep(3))
asmlib.WorkshopID(sT, tostring(0):rep(3))
local sU, tA, nA = asmlib.ComponentType(sT, "Test", "Iron tracks", "Aaaaa")
for iD = 1, nA do asmlib.WorkshopID(tA[iD], tostring(iD):rep(3)) end
asmlib.Log(asmlib.GetReport(sU, tA, nA))
asmlib.LogTable(tA, "["..sT.."]:COMPONENTS")


asmlib.WorkshopID("Iron tracks", "33334444")

print("TYPE-RUN-------------------------------")
asmlib.ExportTypeRUN(sE)
asmlib.ExportTypeRUN(sE, true)
print("TYPE-DSV-------------------------------")
asmlib.ExportTypeDSV(sE)
print("TRN-------------------------------")
asmlib.ExportTypeTRN(sE)
print("CAT-------------------------------")
asmlib.ExportTypeCAT(sE)
print("DSV-------------------------------")
asmlib.ExportDSV("PIECES", sG, nil, true)
asmlib.ExportDSV("ADDITIONS", sG, nil, true)
asmlib.ExportDSV("PHYSPROPERTIES", sG, nil, true)
asmlib.ExportSyncDB()

print("MAK-------------------------------", file.IsDir("asasadadsa"))
asmlib.RunBuilderCount(
  function()
    local a = 1 + {}
  end)
asmlib.RunBuilderCount(
  function() end)
asmlib.RunBuilderCount(4)
asmlib.RunBuilderCount(function() return true end )