local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(1)

local node = require("NodeCalculator/node")

local r = node.New("+")
r:newLeft():setValue(6)
r:newRight():setValue(14):Validate()

print(r:Eval():getValue())