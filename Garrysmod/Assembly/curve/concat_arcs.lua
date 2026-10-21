local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki").addBase("D:/Programs/LuaIDE").setBase(1)

require("gmodlib")
require("trackasmlib")
local com = require("common")
local cpx = require("complex")
local asmlib = trackasmlib

if(not asmlib.InitBase("track","assembly")) then return end

asmlib.SetIndexes("V","x","y","z")
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("WV",1,2,3)
asmlib.SetIndexes("WA",1,2,3)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.SetOpVar("LOG_DEBUGEN",true)
asmlib.SetLogControl(10000, false)
asmlib.SetOpVar("TRACE_MARGIN", 0.5)
asmlib.SetOpVar("DIRPATH_BAS","E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/Assembly/")
local gtArgsLogs  = {"", false, 0}

local gtC = {
  cpx.getNew(0,0),
  cpx.getNew(3,0),
  cpx.getNew(5,0),
}

local gtR = {3, -5}

function GetTangentArc(tC, tR)

end











