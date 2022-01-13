local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

local testexec = require("testexec")
local mt = getmetatable("")
local ts = "string"

local function f1(a)
  return getmetatable(a) == mt
end

local function f2(a)
  return type(a) == ts
end

local function f3(a)
  return type(a) == "string"
end

local stEstim = {
  testexec.Case(f1, "mt"),
  testexec.Case(f2, "ty")
}

local stCard = {
  {1, false , "number", 10000, 100000, .2},
  {nil, false , "nul", 10000, 100000, .2},
  {true, false , "bool", 10000, 100000, .2},
  {function() end, false , "func", 10000, 100000, .2},
  {{}, false , "table", 10000, 100000, .2},
  {"", true , "string", 10000, 10000, .2}
}

 testexec.Run(stCard,stEstim,0.1)
