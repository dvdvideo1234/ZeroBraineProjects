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

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)

require("gmodlib")
require("trackasmlib")
local asmlib = trackasmlib
if(not asmlib) then error("No library") end
require("Assembly/autorun/folder")
require("Assembly/autorun/config")

asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end
asmlib.SetLogControl(20000, false)
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

asmlib.RegisterDSV("test_prog.lua", "aaa", "\t", true)
