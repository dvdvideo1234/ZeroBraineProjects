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
local mar = 30

print(com.randomGetString(mar))
print(com.randomGetString(mar))
print(com.randomGetString(mar))
print(com.randomGetString(mar))

local a = 7
local b = 1
local c = nil
local d = nil

print(a or b or c or d)









