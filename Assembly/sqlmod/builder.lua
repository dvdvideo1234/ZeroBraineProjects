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
local sbs, ibs = dir.getBase()
local rev = {
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT/lua/",
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT/lua/"
}
local bas = rev[ibs].."/ZeroBraineProjects/"

rawset(_G, "CLIENT", false)

rawset(_G, "SERVER", (not CLIENT))
require("gmodlib")

game.SinglePlayer(false)

local function CongigureLIB(sRev)
  -- single source of truth
  local sRev = tostring(rev[ibs])
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

local asmlib = CongigureLIB()

asmlib.IsFlag("file_read_once", true)
asmlib.SetOpVar("MODE_DATABASE", "SQL")
asmlib.IsModel = function(m) return isstring(m) end

local PIECES = asmlib.GetBuilderNick("PIECES")

local M = PIECES:Match("model", 1, true)
local I = PIECES:Match('asdf', 4, true)
local Q = PIECES:Delete():Get()

asmlib.LogInstance(PIECES:Begin():Get(), "QUERY")
asmlib.LogInstance(PIECES:Commit():Get(), "QUERY")

asmlib.LogInstance(Q, "QUERY")

local IDX = PIECES:Index():Get()
asmlib.LogTable(IDX, "IDX")

local CMD = PIECES:GetCommand()
asmlib.LogTable(CMD, "CMD")
print("-----------------")
PIECES:Erase("model")



