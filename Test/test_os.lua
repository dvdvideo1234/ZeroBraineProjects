local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(2)

local com = require("common")

local bas = "C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/Test"

drpath.newDir("New Folder", bas)
com.timeDelay(2)
drpath.renDir("New Folder", 'x', bas)
com.timeDelay(2)
drpath.ersDir("x", bas)
