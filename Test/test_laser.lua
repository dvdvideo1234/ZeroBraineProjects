local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)
local com = require("common")

require("gmodlib")
require("laserlib")

local prop  = ents.Create("prop_physics")
local entity = ents.Create("gmod_laser")
local trace = util.TraceLine()

local t = LaserLib.GetSequence(LaserLib.DataRefract("*"))

com.logTable(t)