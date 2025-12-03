local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")
local col = require("colormap")
local crm = require("chartmap")
local kym = require("keymap")
function HSVToColor(h,s,v)
  local r, g, b = col.getColorHSV(h,s,v)
  return {r = r, g = g, b = b, a = 255}
end
require("laserlib")

-- https://en.wikipedia.org/wiki/List_of_refractive_indices
-- http://hyperphysics.phy-astr.gsu.edu/hbase/geoopt/dispersion.html#c1
local nIndx = 1.333

local WHUEMP = LaserLib.GetData("WHUEMP")
local SODD = WHUEMP.CONF.SODD

local function drawGraph(scOpe, intX)
  wipe()
  scOpe:Draw(false, false, true)
  scOpe:setSizeVtx(5)
  local moiX, moiY = scOpe:getInterval()
  local pxX, pxY  = scOpe:getDelta()
  local o = cpx.getNew(0, 0.05)
  local r, g, b, a = LaserLib.WaveToColor(SODD)
  local idx = LaserLib.WaveToIndex(SODD, nIndx)
  local c, tS = cpx.getNew(SODD, idx), {}
  local xL, xH = moiX:getBorderIn()
  for w = 0, 1000, 5 do
    local c = cpx.getNew(w, LaserLib.WaveToIndex(w, nIndx))
    table.insert(tS, {c = c, w = w})
  end
  local vcs, vce = tS[1].c, tS[#tS].c
  for iC = 1, WHUEMP.Size do
    local k = WHUEMP[iC]
    local v = WHUEMP[k]
    local w = v.W[1]
    local r, g, b, a = LaserLib.WaveToColor(w)
    local idx = LaserLib.WaveToIndex(w, nIndx)
    local c = cpx.getNew(w, idx)
    scOpe:drawComplexPoint(c, colr(r, g, b))
    scOpe:drawComplexText(c, tostring(c:getRound(0.01)).." : "..k, 90)
  end
  scOpe:setSizeVtx(2)
  local oX = cpx.getNew(1)
  for iD = 1, (#tS-1) do
    local v1, v2 = tS[iD], tS[iD+1]
    local r, g, b, a = LaserLib.WaveToColor(v1.w)
    local btx = ((v1.w % 50) == 0)
    local can = v2.c:getNew():Sub(v1.c)
          can:Div(pxX, pxY, true)
    local ang = oX:getAngDegVec(can)-45
    v1.c:Action("ab", v2.c, colr(r, g, b))
    scOpe:drawComplexPoint(v1.c, colr(r, g, b), btx, ang)
  end 

  text((" WXS = %6.2f : %6.2f"):format(xL, xH), 0, 0, 0)
  text((" VIS = %6.2f : %6.2f"):format(WHUEMP.CONF.WAVE[1], WHUEMP.CONF.WAVE[2]), 0, 0, 15)
  text((" IDX = %6.2f : %6.2f"):format(WHUEMP.CONF.INDW[1], WHUEMP.CONF.INDW[2]), 0, 0, 30)

  updt()
end

function getKey(t, k, u, d, l, r)
  local step = 1
  if(kym.isKey(k, u)) then
    t[1] = t[1] + step
  elseif(kym.isKey(k, d)) then
    t[1] = t[1] - step
  elseif(kym.isKey(k, l)) then
    t[2] = t[2] - step
  elseif(kym.isKey(k, r)) then
    t[2] = t[2] + step
  end
end

-------------------------------------

local greyLevel = 200
local dX, dY = 10, 0.01
local W , H = 1600, 900
local minX = 0
local maxX = 1000
local minY, maxY = 1.25, 1.8
local clB = colr(col.getColorBlueRGB())
local clR = colr(col.getColorRedRGB())
local clBlk = colr(col.getColorBlackRGB())
local clGry = colr(greyLevel,greyLevel,greyLevel)

local intX  = crm.New("interval","WinX", minX, maxX, 0, W)
local intY  = crm.New("interval","WinY", minY, maxY, H, 0)
local scOpe = crm.New("scope"):setInterval(intX, intY):setBorder(minX, maxX, minY, maxY)
      scOpe:setSize(W, H):setColor(clBlk, clGry):setDelta(dX, dY)

local function drawComplexLine(S, E, Cl)
  local x1 = intX:Convert(S:getReal()):getValue()
  local y1 = intY:Convert(S:getImag()):getValue()
  local x2 = intX:Convert(E:getReal()):getValue()
  local y2 = intY:Convert(E:getImag()):getValue()
  pncl(Cl); line(x1, y1, x2, y2)
end; cpx.setAction("ab", drawComplexLine)

com.logStatus("The distance between every grey line on X is: "..tostring(dX))
com.logStatus("The distance between every grey line on Y is: "..tostring(dY))

open("Refractive index wave color ("..W.."x"..H..")")

size(W,H); zero(0, 0); updt(false) -- disable auto updates

drawGraph(scOpe)

while true do
  local key = char(); wait(0.1)
  if(key) then
    getKey(WHUEMP.CONF.INDW, key, "K_UP", "K_DOWN", "K_LEFT", "K_RIGHT")
    drawGraph(scOpe)
  end
end

wait()
