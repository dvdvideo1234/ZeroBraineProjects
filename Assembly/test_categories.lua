local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki").addBase("D:/Programs/LuaIDE").setBase(1)
                
local com = require("common")
local asmlib = require("trackasmlib")
local cpx = require("complex")
local tableRemove = table and table.remove

local new = function(m)
  local r = m:gsub("models/sewerpack/sewertunnel",""):gsub("%.mdl$","")
  return r
end
    
local a, b, c

    
local m = "models/sewerpack/sewertunnela.mdl"
--local m = "models/bobsters_trains/rails/2ft/curves/curve_bank_90_left_2048.mdl"
-- print("ggg", new(m))
local to, nn = new(m)

print "dsfsdfs"

print("Name", nn)
com.logTable(to, "NEW")


