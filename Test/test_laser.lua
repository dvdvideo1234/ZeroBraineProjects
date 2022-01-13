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
local laser = ents.Create("gmod_laser")
local trace = util.TraceLine()

laser.hitReports = {
  Size = 1,
  {
    
    ["DT"]={MxBounce=12}
  }
}

local function getReport(ent, idx, typ, key)
  if(not LaserLib.IsValid(ent)) then return nil end
  local rep = ent.hitReports; if(not rep) then return nil end
  local siz = rep.Size; if(not siz) then return nil end
  if(idx <= 0 or idx > siz) then return nil end
  rep = rep[idx]; if(not rep) then return nil end
  print(111)
  
  rep = rep[typ]; if(not rep) then return nil end
  rep = rep[key]; if(not rep) then return nil end
  
  return rep -- Return indexed value for hit report
end

print(getReport(laser, 1, "DT", "MxBounce"))




