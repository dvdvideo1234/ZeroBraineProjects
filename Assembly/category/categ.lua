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
rawset(_G, "SERVER", (not CLIENT))
require("gmodlib")

game.SinglePlayer(false)

local function CongigureLIB(sRev, bEnv)
  -- single source of truth
  dofile(sRev.."trackassembly/trackasmlib.lua")
  local asmlib = trackasmlib 
  if not asmlib then error("No library") end
  local tP = common.tableIndexProxy(asmlib, function(i, k, v)
    return ((k == "DIRPATH_BAS") and (bas.."Assembly/trackassembly/") or v)
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
  dofile(sRev.."autorun/trackassembly_init.lua")
  asmlib.SetLogControl(1,0)
  for k, v in pairs(tP) do
    if(bEnv or not k:find("^%L")) then 
      asmlib.LogTable(asmlib, "asmlib")
      asmlib.LogTable(tP, "proxy")
      break
    end
  end
  return asmlib
end

local asmlib = CongigureLIB(rev)

asmlib.IsFlag("file_read_once", true)
asmlib.MODE_DATABASE = "LUA"
asmlib.IsModel = function(m) return isstring(m) end

local sT, sC, fC = asmlib.Categorize("TEST", 2, "models")

asmlib.LogInstance(sT)
asmlib.LogInstance(sC)
asmlib.LogTable(fC("models/track s/high/25a.mdl"), "CAT")

--asmlib.LogTable(asmlib.TABLE_CATEGORIES, "TABLE_CATEGORIES")


