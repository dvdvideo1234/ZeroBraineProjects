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

local function CongigureLIB(sRev)
  -- single source of truth
  dofile(sRev.."trackassembly/trackasmlib.lua")
  local asmlib = trackasmlib 
  if not asmlib then error("No library") end
  common.tableIndexProxy(asmlib,
  function(i, k, v)
    return ((k == "DIRPATH_BAS") and (bas.."Assembly/trackassembly/") or v)
  end)
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

asmlib.IsFlag("file_read_once", true)
asmlib.MODE_DATABASE = "LUA"
asmlib.IsModel = function(m) return isstring(m) end

--------------- CUSTOM ---------------

local t = {1, 2, nil, 4}

local a, b, c, d = unpack(t)

print(a, b, c, d)