local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(2)

require("dvdlualib/gmodlib")
local testexec = require("testexec")

local function f1(bedraw)
  local bedraw = (bedraw or bedraw == nil) and true or false
  return bedraw
end

local stEstim = {
  testexec.Case(f1, "origin")
}

local stCard = {
  {true , true  , "true", 1000, 10000, .2},
  {false, false , "false", 1000, 10000, .2},
  {nil, true , "nil", 1000, 10000, .2},
  {"",  true, "string", 1000, 10000, .2},
  {0,  true, "number-0", 1000, 10000, .2},
  {5,  true, "number!=0", 1000, 10000, .2},
  {{},  true, "table", 1000, 10000, .2}
}

testexec.Run(stCard,stEstim,0.1)
