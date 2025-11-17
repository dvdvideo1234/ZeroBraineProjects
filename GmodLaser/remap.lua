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

LaserLib = {}

DATA = {}
DATA.AMAX = {-360, 360}        -- General angular limits for having min/max
DATA.WVIS = { 750, 380}        -- General wavelength limits for visible light
DATA.WCOL = {  0 , 270}        -- Mapping for wavelength to color hue conversion
DATA.WMAP = {   5,  20}        -- Dispersion wavelength mapping for refractive index
DATA.SODD = 589.29             -- General wavelength for sodium line used for dispersion
DATA.SOMR = 10                 -- General coefficient for wave to refractive index conversion

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
  ["MAGENTA"] = {W = {380, 250}, H = {280, 300}}
}; DATA.WHUEMP.Size = #DATA.WHUEMP

function LaserLib.WaveToHue(nW)
  local g_guemp = DATA.WHUEMP
  for iD = 1, g_guemp.Size do
    local key = g_guemp[iD]
    local map = g_guemp[key]
    local n, w, h = map.N, map.W, map.H
    if(nW <= w[1] and nW > w[2]) then
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
    if(nH >= h[1] and nH < h[2]) then
      return math.Remap(nH, h[1], h[2], w[1], w[2])
    end
  end; return nil
end

local w = 530
print("GenericR", math.Remap(w, DATA.WVIS[1], DATA.WVIS[2], DATA.WCOL[1], DATA.WCOL[2]))
print("CustomHW", LaserLib.WaveToHue(w))
print("CustomHR", LaserLib.HueToWave(LaserLib.WaveToHue(w)))
