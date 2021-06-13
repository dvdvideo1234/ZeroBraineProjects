local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

local common  = require('common')

local v = {Ent = "!"}

if(not v.Ent or not (tonumber(v.Ent) or tostring(v.Ent) ~= "a")) then
  print("aaa")
end

print("finish")