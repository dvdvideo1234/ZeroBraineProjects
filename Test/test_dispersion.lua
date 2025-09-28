local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(1)

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

DATA.AMAX = {-360, 360}        -- General angular limits for having min/max
DATA.WVIS = { 700, 300}        -- General wavelength limits for visible light
DATA.WCOL = {  0 , 300}        -- Mapping for wavelength to color hue conversion
DATA.WMAP = {  20, 5}        -- Dispersion wavelength mapping for refractive index
DATA.SODD = 589.29             -- General wavelength for sodium line used for dispersion
DATA.SOMR = 10                 -- General coefficient for wave to refractive index converion

local nIndx = 1.458

-------------------------------------

local dX, dY = 10, 0.01
local W , H = 1000, 600
local minX, maxX = DATA.WVIS[2], DATA.WVIS[1]
local minY, maxY = 1.4, 1.6
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

function LaserLib.WaveToIndex(wave, nidx)
  local wr, mr, ms = DATA.WVIS, DATA.WMAP, DATA.SOMR
  local s = math.Remap(DATA.SODD, wr[1], wr[2], mr[1], mr[2])
  local x = math.Remap(wave, wr[1], wr[2], mr[1], mr[2])
  local h = -math.log(s) / ms -- Sodium line index
  return (-math.log(x) / ms - h) + nidx
end

local tS, w = {}, DATA.WVIS[1] 

for w = DATA.WVIS[2], DATA.WVIS[1] do
  local c = cpx.getNew(w, LaserLib.WaveToIndex(w, nIndx))
  if(w % 100 == 0) then
    print(c, w)
  end
  --print(c)
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
    updt(); wait(0.01)
  end 
  
  wait()
else
  common.logStatus("Your curve parameters are invalid !")
end