local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)
      
local com = require("common")

require("gmodlib")
require("laserlib")

local gtREFRACT = LaserLib.DataRefract("*")
local DATA = LaserLib.GetData()

local e = ents.Create('gmod_laser')

local beam = LaserLib.DoBeam(e, Vector(1,1,1) * 200, Vector(0,0,1), 100, 0, 50, 120)
  
function beam:GetSnapshot()
  
end
  
com.logTable(beam, "beam")

