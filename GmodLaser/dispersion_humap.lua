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
DATA.WMAP = {  15,   5}        -- Dispersion wavelength mapping for refractive index
DATA.SODD = 589.29             -- General wavelength for sodium line used for dispersion
DATA.SOMR = 10                 -- General coefficient for wave to refractive index conversion
local nIndx = 1.333            -- Water

DATA.WHUEMP = {
  [1] = "RED"    ,
  [2] = "ORANGE" ,
  [3] = "YELLOW" ,
  [4] = "GREEN"  ,
  [5] = "CYAN"   ,
  [6] = "BLUE"   ,
  [7] = "VIOLET" ,
  [8] = "MAGENTA",
  ["RED"    ] = {W = {750, 625}, H = {  0,  20}},
  ["ORANGE" ] = {W = {625, 590}, H = { 20,  40}},
  ["YELLOW" ] = {W = {590, 565}, H = { 40,  90}},
  ["GREEN"  ] = {W = {565, 500}, H = { 90, 150}},
  ["CYAN"   ] = {W = {500, 485}, H = {150, 200}},
  ["BLUE"   ] = {W = {485, 450}, H = {200, 260}},
  ["VIOLET" ] = {W = {450, 380}, H = {260, 280}},
  ["MAGENTA"] = {W = {380, 300}, H = {280, 300}}
}; DATA.WHUEMP.Size = #DATA.WHUEMP

DATA.WVIS[1] = DATA.WHUEMP[DATA.WHUEMP[1]].W[1]
DATA.WVIS[2] = DATA.WHUEMP[DATA.WHUEMP[DATA.WHUEMP.Size]].W[2]

function LaserLib.WaveToHue(nW)
  local g_guemp = DATA.WHUEMP
  for iD = 1, g_guemp.Size do
    local key = g_guemp[iD]
    local map = g_guemp[key]
    local n, w, h = map.N, map.W, map.H
    if(nW <= w[1] and nW >= w[2]) then
      return math.Remap(nW, w[1], w[2], h[1], h[2])
    end
  end; return nil
end

function LaserLib.HueToWave(nH)
  local g_guemp = DATA.WHUEMP
  for iD = 1, g_guemp.Size do
    local key = g_guemp[iD]
    local map = g_guemp[key]
    local n, w, h = map.N, map.W, map.H
    if(nH >= h[1] and nH <= h[2]) then
      return math.Remap(nH, h[1], h[2], w[1], w[2])
    end
  end; return nil
end

local function HSVToColor(h,s,v)
  local r, g, b = col.getColorHSV(h,s,v)
  return {r = r, g = g, b = b, a = 255}
end

-------------------------------------

local greyLevel  = 200
local dX, dY = 10, 0.01
local W , H = 1000, 600
local minX = DATA.WVIS[2]-20
local maxX = DATA.WVIS[1]+20
local minY, maxY = nIndx-0.1, nIndx+0.15
local clB = colr(col.getColorBlueRGB())
local clR = colr(col.getColorRedRGB())
local clBlk = colr(col.getColorBlackRGB())
local clGry = colr(greyLevel,greyLevel,greyLevel)

local intX  = crm.New("interval","WinX", minX, maxX, 0, W)
local intY  = crm.New("interval","WinY", minY, maxY, H, 0)
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

function LaserLib.WaveToColor(wave, bobc)
  local wvis, wcol = DATA.WVIS, DATA.WCOL
  local hue = LaserLib.WaveToHue(wave)
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
  local tMap = DATA.WHUEMP
  for iC = 1, tMap.Size do
    local k = tMap[iC]
    local v = tMap[k]
    local w = v.W[1]
    local r, g, b = LaserLib.WaveToColor(w)
    local idx = LaserLib.WaveToIndex(w, nIndx)
    local c = cpx.getNew(w, idx)
    scOpe:drawComplexPoint(c, colr(r, g, b))
    scOpe:drawComplexText(c, tostring(c:getRound(0.01)).." : "..k, 90)
  end
  scOpe:setSizeVtx(2)

  for iD = 1, (#tS-1) do
    local v1, v2 = tS[iD], tS[iD+1]
    local r, g, b = LaserLib.WaveToColor(v1.w)
    local ang, btx = -45, ((v1.w % 50) == 0)
    v1.c:Action("ab", v2.c, colr(r, g, b))
    scOpe:drawComplexPoint(v1.c, colr(r, g, b), btx, ang)
    print(v1.w, r, g, b)
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
  getKey(DATA.WMAP, key, "K_NUMPAD8", "K_NUMPAD5", "K_NUMPAD4", "K_NUMPAD6")
end

wait()
