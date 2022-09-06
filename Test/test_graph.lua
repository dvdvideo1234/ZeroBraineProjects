local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(1)

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")
local col = require("colormap")
local crm = require("chartmap")

-------------------------------------
-- https://en.wikipedia.org/wiki/List_of_refractive_indices
-- http://hyperphysics.phy-astr.gsu.edu/hbase/geoopt/dispersion.html#c1
local step = 10 -- Fused qartz
local LaserLib, DATA = {}, {}

DATA.WVIS = { 380, 750}      -- General wavelength limists for visible light
DATA.WMAP = { 0.8, 3}        -- Dispersion wavelenght mapping for refractive index
DATA.SODD = 589.29           -- General wavelength for sodium line used for dispersion
DATA.SOMR = 100

local nIndx = 1.458

-------------------------------------

local dX, dY = 1, 0.005
local W , H = 1000, 600
local minX, maxX = DATA.WMAP[1], DATA.WMAP[2]
local minY, maxY = 1.445, 1.475
local greyLevel  = 200
local intX  = crm.New("interval","WinX", minX, maxX, 0, W)
local intY  = crm.New("interval","WinY", minY, maxY, H, 0)
local clGry = colr(greyLevel,greyLevel,greyLevel)
local clB = colr(col.getColorBlueRGB())
local clR = colr(col.getColorRedRGB())
local clBlk = colr(col.getColorBlackRGB())
local scOpe = crm.New("scope"):setInterval(intX, intY):setBorder(minX, maxX, minY, maxY)
      scOpe:setSize(W, H):setColor(clBlk, clGry):setDelta(dX, dY)

-------------------------------------------------------

function LaserLib.GetIndex(wave, nidx)
  local wr, mr, ms = DATA.WVIS, DATA.WMAP, DATA.SOMR
  local s = math.Remap(DATA.SODD, wr[1], wr[2], mr[1], mr[2])
  local x = math.Remap(wave, wr[1], wr[2], mr[1], mr[2])
  local h = -math.log(s) / ms -- Index `nidx` for sodium line
  return (-math.log(x) / ms - h) + nidx
end

local tS, w = {}, DATA.WVIS[1] 

while(w <= DATA.WVIS[2]) do
  local wr, mr = DATA.WVIS, DATA.WMAP
  local x = math.Remap(w, wr[1], wr[2], mr[1], mr[2])
  local c = cpx.getNew(x, LaserLib.GetIndex(w, nIndx))
  if(w == 700 or w == 590 or w == 400) then
    print(c, w)
  end
  w = w + step
  table.insert(tS, c)
end

-------------------------------------------------------

if(tS) then
  com.logStatus("The distance between every grey line on X is: "..tostring(dX))
  com.logStatus("The distance between every grey line on Y is: "..tostring(dY))
  
  local function drawComplexLine(S, E, Cl)
    local x1 = intX:Convert(S:getReal()):getValue()
    local y1 = intY:Convert(S:getImag()):getValue()
    local x2 = intX:Convert(E:getReal()):getValue()
    local y2 = intY:Convert(E:getImag()):getValue()
    pncl(Cl); line(x1, y1, x2, y2)
  end; cpx.setAction("ab", drawComplexLine)

  open("Complex Bezier curve")
  size(W,H); zero(0, 0); updt(false) -- disable auto updates

  scOpe:Draw(false, false, true, true)

  for iD = 1, (#tS-1) do
    tS[iD]:Action("ab", tS[iD+1], clR)
    scOpe:drawComplexPoint(tS[iD])
    updt(); wait(0.05)
  end 
  
  wait()
else
  common.logStatus("Your curve parameters are invalid !")
end