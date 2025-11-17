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

-------------------------------------
-- https://en.wikipedia.org/wiki/List_of_refractive_indices
-- http://hyperphysics.phy-astr.gsu.edu/hbase/geoopt/dispersion.html#c1
local LaserLib, DATA = {}, {}

DATA.WVIS = { 780, 310}        -- General wavelength limits for visible light
DATA.WCOL = {  0 , 300}        -- Mapping for wavelength to color hue conversion
DATA.WMAP = {  20,   5}        -- Dispersion wavelength mapping for refractive index
DATA.SODD = 589.29             -- General wavelength for sodium line used for dispersion
DATA.SOMR = 10                 -- General coefficient for wave to refractive index conversion
local nIndx = 1.333            -- Water

local function HSVToColor(h,s,v)
  local r, g, b = col.getColorHSV(h,s,v)
  return {r = r, g = g, b = b, a = 255}
end

-------------------------------------

local greyLevel  = 200
local dX, dY = 10, 0.01
local W , H = 1000, 600
local minX, maxX = DATA.WVIS[2], DATA.WVIS[1]
local minY, maxY = nIndx-0.1, nIndx+0.15
local clB = colr(col.getColorBlueRGB())
local clR = colr(col.getColorRedRGB())
local clBlk = colr(col.getColorBlackRGB())
local clGry = colr(greyLevel,greyLevel,greyLevel)

local intX  = crm.New("interval","WinX", minX, maxX, 0, W)
local intY  = crm.New("interval","WinY", minY, maxY, H, 0)
local scOpe = crm.New("scope"):setInterval(intX, intY):setBorder(minX, maxX, minY, maxY)
      scOpe:setSize(W, H):setColor(clBlk, clGry):setDelta(dX, dY)
local tMatch = 
{
  {Name = "Violet", S = 380, E = 450},
  {Name = "Blue"  , S = 450, E = 485},
  {Name = "Cyan"  , S = 485, E = 500},
  {Name = "Green" , S = 500, E = 565},
  {Name = "Yellow", S = 565, E = 590},
  {Name = "Orange", S = 590, E = 625},
  {Name = "Red"   , S = 625, E = 750}
}

-------------------------------------------------------

function LaserLib.WaveToIndex(wave, nidx)
  local wr, mr, ms = DATA.WVIS, DATA.WMAP, DATA.SOMR
  local s = math.Remap(DATA.SODD, wr[1], wr[2], mr[1], mr[2])
  local x = math.Remap(wave, wr[1], wr[2], mr[1], mr[2])
  local h = -math.log(s) / ms -- Sodium line index
  return (-math.log(x) / ms - h) + nidx
end

function LaserLib.WaveToColor(wave, bobc)
  local wvis, wcol = DATA.WVIS, DATA.WCOL
  local hue = math.Remap(wave, wvis[1], wvis[2], wcol[1], wcol[2])
  local tab = HSVToColor(hue, 1, 1) -- Returns table not color
  if(bobc) then local wtcol = DATA.WTCOL
    wtcol.r, wtcol.g = tab.r, tab.g
    wtcol.b, wtcol.a = tab.b, tab.a; return wtcol
  end; return tab.r, tab.g, tab.b, tab.a
end

-------------------------------------------------------

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

local function drawGraph()
  wipe()
  scOpe:Draw(false, false, true, true)
  scOpe:setSizeVtx(5)
  local o = cpx.getNew(0, 0.05)
  local r, g, b = LaserLib.WaveToColor(DATA.SODD)
  local idx = LaserLib.WaveToIndex(DATA.SODD, nIndx)
  local c, tS = cpx.getNew(DATA.SODD, idx), {}
  for w = DATA.WVIS[2], DATA.WVIS[1], 5 do
    local c = cpx.getNew(w, LaserLib.WaveToIndex(w, nIndx))
    table.insert(tS, {c = c, w = w})
  end
  scOpe:drawComplexPoint(c, colr(r, g, b))
  scOpe:drawComplexText(c, tostring(c:getRound(0.01)).." : Sodium line", -90)
  for iC = 1, #tMatch do
    local v = tMatch[iC]
    local r, g, b = LaserLib.WaveToColor(v.S)
    local idx = LaserLib.WaveToIndex(v.S, nIndx)
    local c = cpx.getNew(v.S, idx)
    scOpe:drawComplexPoint(c, colr(r, g, b))
    scOpe:drawComplexText(c, tostring(c:getRound(0.01)).." : "..v.Name, 90)
  end
  scOpe:setSizeVtx(2)

  for iD = 1, (#tS-1) do
    local v1, v2 = tS[iD], tS[iD+1]
    local r, g, b = LaserLib.WaveToColor(v1.w)
    local ang, btx = -45, ((v1.w % 50) == 0)
    v1.c:Action("ab", v2.c, colr(r, g, b))
    scOpe:drawComplexPoint(v1.c, colr(r, g, b), btx, ang)
  end 
  
  text(("DATA.WVIS = %6.2f : %6.2f"):format(DATA.WVIS[1], DATA.WVIS[2]), 0, 0, 0)
  text(("DATA.WMAP = %6.2f : %6.2f"):format(DATA.WMAP[1], DATA.WMAP[2]), 0, 0, 15)
  
  updt()
end

function getKey(t, k, u, d, l, r)
  local step = 5
  if(kym.isKey(k, u)) then
    t[1] = t[1] + step
    drawGraph()
  elseif(kym.isKey(k, d)) then
    t[1] = t[1] - step
    drawGraph()
  elseif(kym.isKey(k, l)) then
    t[2] = t[2] - step
    drawGraph()
  elseif(kym.isKey(k, r)) then
    t[2] = t[2] + step
    drawGraph()
  end
end

size(W,H); zero(0, 0); updt(false) -- disable auto updates

drawGraph()

shift = 1

while true do
  local key = char(); wait(0.1)
  getKey(DATA.WVIS, key, "K_UP", "K_DOWN", "K_LEFT", "K_RIGHT")
  getKey(DATA.WMAP, key, "K_NUMPAD8", "K_NUMPAD5", "K_NUMPAD4", "K_NUMPAD6")
end

wait()
