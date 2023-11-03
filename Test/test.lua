local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")

local t = {["test"] = false}

local function toNumber(src)
  return (tonumber(src) or 0)
end

local r = t["test"]
local e = r and r.ID or 0

print(toNumber(e))