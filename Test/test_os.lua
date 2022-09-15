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

drpath.ersDir("New Folder", bas)

