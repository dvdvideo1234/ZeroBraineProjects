local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(1)

require("gmodlib")
local common = require("common")

local str = "CURVE"

local tBord = {1}

local vMin = (tBord and tBord[1] or nil) -- Read the minimum and maximum
local vMax = (tBord and tBord[2] or nil)


print(vMin, vMax)