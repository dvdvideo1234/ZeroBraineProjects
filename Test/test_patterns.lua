local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(1)

require("gmodlib")
local common = require("common")

local str = "[\"en\"] = \"Dedizierter Spawnpunkt für Feinde\","
local ptr = "%[\"en\"%]"
local exp = str:match(ptr, 1, true)

print("S:", str)
print("E:", "<"..exp..">")

