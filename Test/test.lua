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
local ENT = {foo = nil}

local function foo()
  for i = 1, 5 do
    ENT[i] = "test"
  end
end

local function moo(foo)
  local s, e = pcall(foo)
  if(not s) then error(e) end
end






