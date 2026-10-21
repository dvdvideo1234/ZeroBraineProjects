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

local function CongigureLIB(sRev)
  print("----------------LIBS----------------")
  -- single source of truth
  dofile(sRev.."trackassembly/trackasmlib.lua")
  local asmlib = trackasmlib 
  if not asmlib then error("No library") end
  local oservr = asmlib.SetOpVar
  asmlib.SetOpVar = function(n, v)
    if n ~= "DIRPATH_BAS" then
      return oservr(n, v)
    else
      print("CUSTOM-VAR", n)
      return oservr(n, "Assembly/trackassembly/")
    end
  end
  -- _G.SetOpVar = asmlib.SetOpVar
  print("SetOpVar 0 identity:", SetOpVar)
  print("SetOpVar 1 identity:", _G.SetOpVar)
  print("SetOpVar 2 identity:", asmlib.SetOpVar)
  print("SetOpVar 3 identity:", trackasmlib.SetOpVar)
  print("----------------INIT----------------")
  -- init must operate on the SAME instance
  dofile(sRev.."autorun/trackassembly_init.lua")
  return asmlib
end

local asmlib = CongigureLIB(rev)
asmlib.SetLogControl(20000, false)

asmlib.IsFlag("file_read_once", false)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end

-------- CUSTOM TEST --------

require("Assembly/autorun/z_autorun_[shinji85_s_rails]")

asmlib.ImportDSV("PIECES", true, "shinji85_s_rails")

local oM = "models/shinji85/train/rail_l_switch.mdl"
local tS = {"BEFORE", "AFTER"}

local function logPrint(SD, TY, ...)
  asmlib.LogInstance(asmlib.GetReport(SD, TY, ...))
end

local oR = asmlib.CacheQueryPiece(oM)
if(oR) then 
  local iD, iO = 3, "P"
  local oP = oR.Offs[iD]
  if(oP and oP[iO]) then
    asmlib.LogTable(oR, tS[1])
    asmlib.LocatePOA(oR, 1)
    asmlib.LogTable(oR, tS[2])
  end
else
  asmlib.LogIstance("Model missing: "..oM)
end
