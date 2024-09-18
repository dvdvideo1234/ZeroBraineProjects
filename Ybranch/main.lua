local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("turtle")

local fractal = require("fractal")

local D, W, H = 4, 600,600
local oTree = fractal.New("ytree", D, colr(100, 50, 255))

if(oTree) then
  open("Binary tree branching")
  size(W,H)
  zero(0, 0)
  updt(true) -- disable auto updates
  oTree:Allocate() 
  oTree:Draw(W/2,0,W/4,H/4,wait,0.1)
end
