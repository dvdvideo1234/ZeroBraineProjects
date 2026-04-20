local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local common  = require('common')
local complex  = require('complex')

require('gmodlib')

local ron = nil
local trn = nil

  local ro = ((ron ~= nil) and tobool(ron) or false)
  local ov = ((trn ~= nil) and tostring(trn or "") or nil)

print(ov, ro)