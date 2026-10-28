local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")

local a = {ab = 1, cd = 2, ef = 3, gh = "4", ij = 5,1,2,3,4}

local function test(...)
  bNex, bSam, nCos = ...
  print(bNex, bSam, nCos)
end

test(1, 12, 123)

SERVER = false
CLIENT = false


local sP = SERVER and "sv_" or (CLIENT and "cl_" or "na_")
