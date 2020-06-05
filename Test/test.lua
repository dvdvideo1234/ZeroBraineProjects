local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  "ZeroBraineProjects/dvdlualib",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/ExtractWireWiki").addBase("D:/LuaIDE").setBase()
local com = require("common")

com.logTable(dir.retBase(), "BASE")
com.logTable(dir.retPath(), "PATH")
com.logTable(dir.getList(), "LIST")


local cpx = require("complex")

local a = cpx.getNew(4,5)
local b = cpx.getNew(7,5)
local c = cpx.getNew(1,9)

print(a:getHarmMean(b,c))

print(a,b,c)