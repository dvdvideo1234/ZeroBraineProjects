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

local t = {prop1, prop2}

for k, v in pairs(t) do
  v:Remove()
  t[k] = nil
end

com.logTable(t)



