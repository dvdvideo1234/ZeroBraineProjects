local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/LuaIDE").setBase(1)

local com = require("common")
local cpx = require("complex")
require("dvdlualib/asmlib")
local asmlib = trackasmlib
asmlib.InitBase("track","assembly")
asmlib.SetLogControl(1000, false)

n = 66.752

print(">"..("%5.2f%%"):format(n).."<")

