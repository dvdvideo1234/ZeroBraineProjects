local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
                
local common = require("common")

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)

require("gmodlib")
require("trackasmlib")
asmlib = trackasmlib
require("Assembly/autorun/folder")

CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetLogControl(1000, 0, false)

local KT1 = {1,2,3}
local KT2 = {C = 1, D = 2, E = 3}
local KF1 = function() end
local KF2 = function() end

local T = 
{
  A = "asdf",
  B = 2,
  [1] = "qwer",
  [2] = 3,
  [KT1] = "tyui",
  [KT2] = 4,
  [KF1] = "ghjk",
  [KF2] = 5
}
T.S = T

local s = os.clock() * 10000
for i = 1, 1000 do
asmlib.LogCeption(T)
end
local e = os.clock() * 10000 - s

print("Time:", e)




