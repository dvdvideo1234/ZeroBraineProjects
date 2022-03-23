local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(2)

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
local istable = com.isTable


local vals = {}
vals[ "Table" ] = {}
vals[ "Function" ] = function() end
vals[ "String" ] = "Hello world"

local ics = {}
ics[ "Table" ] = "icon16/cross.png"

local vars = {values = vals, icons = ics}

local hasIcons, icon = istable( vars.icons )
for id, thing in pairs( vars.values or {} ) do
  if(hasIcons) then
    icon = vars.icons[id]
  else
    icon = vars.icons
  end
  
  
  print("combo:AddChoice(", id, thing, id == vars.select, icon, ")")
end
