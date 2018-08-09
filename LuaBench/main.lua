package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

local common = require("common")
require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
require("../dvdlualib/common")

local nT = 600

local function f1(tA) return asmlib.DisableString1(unpack(tA)) end
local function f2(tA) return asmlib.DisableString2(unpack(tA)) end

local stEstim = {
  addEstim(f1, "old"),
  addEstim(f2, "new")
}


local stCard = {
  {{1 , nil      , "DEF" }, nil  , "Number1", nT, nT, .2},
  {{1 , "DIS"    , "DEF" }, "DEF" , "Number2", nT, nT, .2},
  {{"" , nil     , "DEF" }, nil , "ES1", nT, nT, .2},
  {{"" , "DIS"   , "DEF" }, "DEF" , "ES2", nT, nT, .2},
  {{nil , ""     , "DEF" }, "DEF" , "XX1", nT, nT, .2},
  {{"BBB" , ""   , "DEF" }, "BBB" , "XX2", nT, nT, .2},
  {{"AAA" , "DIS", "DEF" }, "AAA" , "AAA1", nT, nT, .2}
}

 testPerformance(stCard,stEstim,nil,0.1)

--[[
Passed [single]: 100.000 Time: 100.000 (1474.423[s])       16955.785[c/s] Failed: 0
Passed [morecy]: 100.000 Time: 106.971 (1577.200[s])       15850.875[c/s] Failed: 0
]]

