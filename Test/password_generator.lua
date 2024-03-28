local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local com = require("common")
local mar = 16

print(com.randomGetString(mar))
print(com.randomGetString(mar))
print(com.randomGetString(mar))
print(com.randomGetString(mar))

local p = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl"



com.logTable(drpath.conDir("TrackAssemblyTool_GIT", p, true))