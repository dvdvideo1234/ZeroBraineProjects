require("turtle")
require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/fractal")

local D, W, H = 10, 1000,1000
local oTree = makeTreeY(D, colr(100, 50, 255))
if(oTree) then
  open("Binary tree branching")
  size(W,H)
  zero(0, 0)
  updt(true) -- disable auto updates
  oTree:Allocate(oTree) 
  oTree:Draw(oTree,W/2,0,W/4,H/4,waitSeconds,0.01)
end




