-- package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require('dvdlualib/common')

local gnR2D = (math.pi / 180)
local lrad  = math.rad

local function f1(R) return R * gnR2D end
local function f2(R) return lrad(R) end
local function f3(R) return math.rad(R) end

local nT = 60000

local stEstim = {
  addEstim(f1, "MUL"),
  addEstim(f2, "LOC"),
  addEstim(f3, "GLB")
}
 -- 2.09439510239
local stCard = {
  {0   ,             0, "Zero" , nT, nT},
  {45  ,     math.pi/4, "45"   , nT, nT},
  {90  ,     math.pi/2, "90"   , nT, nT},
  {135 , (3*math.pi/4), "135"  , nT, nT},
  {180 ,       math.pi, "180"  , nT, nT}
}



testPerformance(stCard,stEstim,nil,0.1)









