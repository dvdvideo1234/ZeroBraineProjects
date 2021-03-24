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
require("dvdlualib/trackasmlib")
local asmlib = trackasmlib
asmlib.InitBase("track","assembly")
asmlib.SetLogControl(1000, false)

local e = ents.Create("test")
 e:SetModel("lol.mdl")

asmlib.GetEntityHitID(e, Vector(0,0,0))