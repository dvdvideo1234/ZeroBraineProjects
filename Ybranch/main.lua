require("turtle")
require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/fractal")

local D, W, H = 8, 1000,1000
local oTree = makeTreeY(D, colr(100, 50, 255))
if(oTree) then
  oTree:Allocate(oTree) 
  open("Binary tree branching")
  size(W,H)
  zero(0, 0)
  updt(false) -- disable auto updates
  oTree:Draw(oTree,W/2,0,W/4,H/4)
end




