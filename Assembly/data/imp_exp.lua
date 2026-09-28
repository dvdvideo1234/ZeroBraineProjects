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
local bas, id, tProxy = dir.getBase()
local tRepo = {
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT",
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT"
}

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", (not CLIENT))
require("gmodlib")

game.SinglePlayer(false)

local function CongigureLIB(bEnv)
  -- single source of truth
  dofile(tRepo[id].."/lua/trackassembly/trackasmlib.lua")
  local asmlib = trackasmlib 
  if not asmlib then error("No library") end
  tProxy = common.tableIndexProxy(asmlib, function(i, k, v)
    if(k ~= "DIRPATH_BAS") then return v end
    return bas.."/ZeroBraineProjects/Assembly/trackassembly/"
  end)
  local gnIndependentUsed = bit.bor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
  local NewAsmConvar = asmlib.NewAsmConvar
  CreateConVar("trackassembly_logsmax", 1, gnIndependentUsed, "Maximum logging lines being written before the counter is reset", 0, 100000)
  CreateConVar("trackassembly_logsbrs", 0, gnIndependentUsed, "Maximum logging lines being written in every I/O write flush", 0, 100000)
  asmlib.NewAsmConvar = function(n, ...)
    if (n ~= "logsmax" and n ~= "logsbrs") then
      return NewAsmConvar(n, ...)
    end
  end
  dofile(tRepo[id].."/lua/autorun/trackassembly_init.lua")
  asmlib.SetLogControl(1,0)
  for k, v in pairs(tProxy) do
    if(bEnv or not k:find("^%L")) then 
      asmlib.LogTable(asmlib, "asmlib")
      asmlib.LogTable(tProxy, "proxy")
      break
    end
  end
  return asmlib
end

local asmlib = CongigureLIB()

asmlib.IsFlag("file_read_once", true)
asmlib.MODE_DATABASE = "LUA"
asmlib.IsModel = function(m) return isstring(m) end

-------- CUSTOM TEST --------
local sS = "set"
local sS = "run"
local sS = "xxx"
local vT = "SligWolf_s_Suspension_Train"
local vT = "Shinji85's Rails"
local vT = {"Ron's 2ft track pack", "r2fttp"}

local sT, sF
if(istable(vT)) then
  sT = vT[1]
  sF = vT[2]
else
  sT = vT
  sF = asmlib.GetTypePrefix(sT)
end

local sP = asmlib.GetTypePrefix(sT)
local sE, tC = sP, {}
local sG = asmlib.DBEXP_PREFGEN
local sM = asmlib.MODE_DATABASE

require(("Assembly/autorun/z_autorun_[%s]"):format(sF))
print("PROCESS-DSV-------------------------------")
asmlib.ProcessDSV()
--if(true) then return end
print("WS-UPDATE-------------------------------")
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
if(true) then return end
print("TYPE-DSV-------------------------------")
asmlib.ExportTypeDSV(sE)
print("TRN-------------------------------")
asmlib.ExportTypeTRN(sE)
asmlib.ExportTypeTRN(sE, true)
print("CAT-------------------------------")
asmlib.ExportTypeCAT(sE)
print("DSV-------------------------------")
asmlib.ExportDSV("PIECES", sG, nil, true)
asmlib.ExportDSV("ADDITIONS", sG, nil, true)
asmlib.ExportDSV("PHYSPROPERTIES", sG, nil, true)
asmlib.ExportSyncDB()

print("ER-MAK-------------------------------")
print(file.IsDir("asasadadsa"))
asmlib.RunBuilderCount(
  function()
    local a = 1 + {}
  end)
asmlib.RunBuilderCount(
  function() end)
asmlib.RunBuilderCount(4)
asmlib.RunBuilderCount(function() return true end )
print("ER-CUS-------------------------------")
asmlib.TranslateDSV(asmlib.GetLibraryPath("exp/","test-trackassembly_additions"), nil, nil, true)

print("GL-VAR-------------------------------")
--asmlib.LogTable(asmlib, "asmlib")
--asmlib.LogTable(tProxy, "proxy")