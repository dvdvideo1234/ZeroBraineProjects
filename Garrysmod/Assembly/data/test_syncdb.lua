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

---------------------------------------------------------------------------------------

local myPrefix = "aaa"
local myType = "TEST"
local myName = "TEST-NAME"
local myScript = "zzzzzzz"

asmlib.LogInstance(">>> "..myScript)

local myTable = {
  ["models/props_phx/construct/metal_plate1x2.mdl"] = { -- Here goes the model of your pack
    {myType ,myName, 1, "","0,-47.455105,1.482965","0,-90,0",""}, -- The first point parameter
    {myType ,myName, 2, "","0, 47.455105,1.482965","0, 90,0",""}  -- The second point parameter
  },
  ["models/props_phx/construct/windows/window1x2.mdl"] = {
    {myType ,"TEST2", "#", "","0, 11.17773,1.482965","0, 90,0",""},
    {myType ,"TEST3", "2", "","0, 22.17773,1.482965","0, 90,0",""},
    {myType ,"TEST1", "#test", "","0, 33.73248,1.482965","0,-90,0",""}
  }
}

if(not asmlib.SynchronizeDSV("PIECES", myTable, true, myPrefix)) then
  error("Failed to synchronize track pieces")
else
  if(not asmlib.TranslateDSV("PIECES", myPrefix)) then
    error("Failed to translate DSV into Lua") end
end -- Now we have Lua inserts and DSV

trackasmlib.LogInstance("<<< "..myScript)

asmlib.RegisterDSV(nil, "aaa")
asmlib.RegisterDSV("some_stuff.lua", "aaa")
