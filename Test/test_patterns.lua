local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("gmodlib")
local common = require("common")

local str = "surface.CreateFont.New(\"LuapadEditor_Bold\", ( {font = \"Courier New\",) size = 16, weight = 800})"

print(str:match("[%a_][%w_%.]*%s*%("))
