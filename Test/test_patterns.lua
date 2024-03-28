local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("gmodlib")
local common = require("common")

local str = "Volume in drive C is OS"
local ptr = "drive.*$"
local exp = str:match("drive.*$"):gsub("drive%s", "")

print("E:", exp)

for w in exp:gmatch("([^/]+)") do
  print("P:", w)
end


