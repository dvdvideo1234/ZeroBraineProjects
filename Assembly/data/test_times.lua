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

rawset(_G, "CLIENT", false)

rawset(_G, "SERVER", (not CLIENT))
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
local sS = "run"
local sT = "SligWolf_s_Suspension_Train"
--local sT = "test_s_track_pack"

local sP = asmlib.GetTypePrefix(sT)
local sE, tC = sP, {}
local sG = asmlib.GetOpVar("DBEXP_PREFGEN")
local sM = asmlib.GetOpVar("MODE_DATABASE")

require(("Assembly/autorun/z_auto"..sS.."_[%s]"):format(sP))
print("------------------------------------------------")
local mT, eT = 0, 1
for iD = 1, eT do
  asmlib.GetBuilderNick("PIECES"):Erase()
  local nT = os.clock()
  asmlib.ImportDSV("PIECES", true, sP)
  mT = mT + ((os.clock() - nT) * 1000)
end
print("------------------------------------------------")
print("Elapsed: "..(mT / eT).."ms")

print(asmlib.NewPOA())