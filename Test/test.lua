local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")
local tableRemove = table and table.remove
local gsSentHash = "test"
local SERVER, LaserLib = true, {}
local WireLib = true
local prop1 = ents.Create("prop1")
local prop2 = ents.Create("prop2")

local iN    = 5
local iName = 5

local bNow = false

local bS = (bNow and (iN == iName) or false)

print(bS)

