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

local str = "multy_type"
local ptr = "[^%w]"
local exp = str:match(ptr, 1, true)
local ssb = str:gsub(ptr, "_")
print("S:", str)
print("R:", ssb)
print("E:", "<"..exp..">")

