local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

local com = require("common")
local cpx = require("complex")
local tableRemove = table and table.remove

local t = {1, 2, 3}

table.insert(t, 1 , 33)
com.logTable(t, "T1")
table.remove(t, 1)
com.logTable(t, "T2")