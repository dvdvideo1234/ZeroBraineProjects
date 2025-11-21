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

DATA.KEYD = "#"
DATA.ZEPS = 1e-10              -- General use epsilon near zero value
DATA.CLMX = 255                -- Maximum value for valid coloring
DATA.SODD = 589.29             -- General wavelength for sodium line used for dispersion
DATA.SOMR = 10                 -- General coefficient for wave to refractive index conversion
DATA.WFADE = 70                -- The wavelength magrin where color starts to fade away on conversion
local nIndx = 1.333            -- Water

DATA.WHUEMP = {
  [DATA.KEYD] = "RED",
  [1] = "RED"    ,
  [2] = "ORANGE" ,
  [3] = "YELLOW" ,
  [4] = "GREEN"  ,
  [5] = "CYAN"   ,
  [6] = "BLUE"   ,
  [7] = "VIOLET" ,
  [8] = "MAGENTA",
  ["RED"    ] = {W = {750, 620}, H = {  0,  20}},
  ["ORANGE" ] = {W = {620, 590}, H = { 20,  45}},
  ["YELLOW" ] = {W = {590, 565}, H = { 45,  80}},
  ["GREEN"  ] = {W = {565, 510}, H = { 80, 140}},
  ["CYAN"   ] = {W = {510, 485}, H = {140, 220}},
  ["BLUE"   ] = {W = {485, 440}, H = {220, 260}},
  ["VIOLET" ] = {W = {440, 380}, H = {260, 280}},
  ["MAGENTA"] = {W = {380, 320}, H = {280, 300}}
}; DATA.WHUEMP.Size = #DATA.WHUEMP

DATA.WHUEMP.Lims = {
  F = 100, -- The wavelength margin where color starts to fade away on conversion
  I = {15,  5}, -- Dispersion wavelength mapping for refractive index
  W = {   -- General wavelength limits for visible light
    DATA.WHUEMP[DATA.WHUEMP[1]].W[1],
    DATA.WHUEMP[DATA.WHUEMP[DATA.WHUEMP.Size]].W[2]
  },
  H = { -- Mapping for wavelength to color hue conversion
    DATA.WHUEMP[DATA.WHUEMP[1]].H[1],
    DATA.WHUEMP[DATA.WHUEMP[DATA.WHUEMP.Size]].H[2]
  }
}

function LaserLib.WaveToHue(nW)
  local g_guemp = DATA.WHUEMP
  local g_limsw = g_guemp.Lims.W
  local g_limsh = g_guemp.Lims.H
  local g_wfade = g_guemp.Lims.F
  local W1, W2 = g_limsw[1], g_limsw[2]
  local nW = math.max((tonumber(nW) or 0), 0)
  if(nW > W1) then return g_limsh[1], math.max(math.Remap(nW, W1, W1+g_wfade, 1, 0), 0) end
  if(nW < W2) then return g_limsh[2], math.max(math.Remap(nW, W2, W2-g_wfade, 1, 0), 0) end
  for iD = 1, g_guemp.Size do
    local key = g_guemp[iD]
    local map = g_guemp[key]
    local w, h = map.W, map.H
    if(nW <= w[1] and nW >= w[2]) then
      return math.Remap(nW, w[1], w[2], h[1], h[2]), 1
    end
  end
end

function LaserLib.HueToWave(nH)
  local g_guemp = DATA.WHUEMP
  local g_limsw = g_guemp.Lims.W
  local g_limsh = g_guemp.Lims.H
  local nH = math.max((tonumber(nH) or 0), 0)
  if(nH < g_limsh[1]) then return g_limsw[1] end
  if(nH > g_limsh[2]) then return g_limsw[2] end
  for iD = 1, g_guemp.Size do
    local key = g_guemp[iD]
    local map = g_guemp[key]
    local w, h = map.W, map.H
    if(nH >= h[1] and nH <= h[2]) then
      return math.Remap(nH, h[1], h[2], w[1], w[2])
    end
  end; return nil
end

local function HSVToColor(h,s,v)
  local r, g, b = col.getColorHSV(h,s,v)
  return {r = r, g = g, b = b, a = 255}
end

function LaserLib.WaveToIndex(wave, nidx)
  local wim, eps = DATA.WHUEMP.Lims, DATA.ZEPS
  local mr, ms, fw = wim.I, DATA.SOMR, wim.F
  local wm1, wm2 = wim.W[1]+fw, wim.W[2]-fw
  local s = math.max(math.Remap(DATA.SODD, wm1, wm2, mr[1], mr[2]), eps)
  local x = math.max(math.Remap(wave, wm1, wm2, mr[1], mr[2]), eps)
  local so = (-math.log(s) / ms) -- Sodium line index  
  return (-math.log(x) / ms - so) + nidx
end

function LaserLib.WaveToColor(wave, bobc)
  local cmx, hue, mrg = DATA.CLMX, LaserLib.WaveToHue(wave)
  local hsv = HSVToColor(hue, mrg, 1); hsv.a = (mrg * cmx)
  if(bobc) then local ctmp = DATA.COTMP
    ctmp.r, ctmp.g = hsv.r, hsv.g
    ctmp.b, ctmp.a = hsv.b, hsv.a; return ctmp
  end; return hsv.r, hsv.g, hsv.b, hsv.a
end

function LaserLib.ColorToWave(...)
  local ctmp = DATA.COTMP
  local r, g, b, a = LaserLib.GetColorRGBA(...)
        ctmp.r, ctmp.g = r, g
        ctmp.b, ctmp.a = b, a
  local mh, ms, mv = ColorToHSV(ctmp)
  return LaserLib.HueToWave(mh)
end

local function drawGraph(scOpe, intX)
  wipe()
  scOpe:Draw(false, false, true)
  scOpe:setSizeVtx(5)
  local moiX, moiY = scOpe:getInterval()
  local pxX, pxY  = scOpe:getDelta()
  local o = cpx.getNew(0, 0.05)
  local r, g, b = LaserLib.WaveToColor(DATA.SODD)
  local idx = LaserLib.WaveToIndex(DATA.SODD, nIndx)
  local c, tS = cpx.getNew(DATA.SODD, idx), {}
  local xL, xH = moiX:getBorderIn()
  for w = 0, 1000, 5 do
    local c = cpx.getNew(w, LaserLib.WaveToIndex(w, nIndx))
    table.insert(tS, {c = c, w = w})
  end
  --scOpe:drawComplexPoint(c, colr(r, g, b))
 -- scOpe:drawComplexText(c, tostring(c:getRound(0.01)).." : Sodium Line", -90)
  local vcs, vce = tS[1].c, tS[#tS].c
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
  local oX = cpx.getNew(1)
  for iD = 1, (#tS-1) do
    local v1, v2 = tS[iD], tS[iD+1]
    local r, g, b = LaserLib.WaveToColor(v1.w)
    local btx = ((v1.w % 50) == 0)
    local can = v2.c:getNew():Sub(v1.c)
          can:Div(pxX, pxY, true)
    local ang = oX:getAngDegVec(can)-45
    v1.c:Action("ab", v2.c, colr(r, g, b))
    scOpe:drawComplexPoint(v1.c, colr(r, g, b), btx, ang)
   -- wait(0.01)
   -- updt()
  end 

  text(("WXS = %6.2f : %6.2f"):format(xL, xH), 0, 0, 0)
  text(("VIS = %6.2f : %6.2f"):format(DATA.WHUEMP.Lims.W[1], DATA.WHUEMP.Lims.W[2]), 0, 0, 15)
  text(("IDX = %6.2f : %6.2f"):format(DATA.WHUEMP.Lims.I[1], DATA.WHUEMP.Lims.I[2]), 0, 0, 30)

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
local minY, maxY = 1.25, 1.6
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
    getKey(DATA.WHUEMP.Lims.I, key, "K_UP", "K_DOWN", "K_LEFT", "K_RIGHT")
    drawGraph(scOpe)
  end
end

wait()
