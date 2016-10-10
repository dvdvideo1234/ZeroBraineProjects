require("turtle")
require("wx")
require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/complex")
require("ZeroBraineProjects/dvdlualib/fractal")
require("ZeroBraineProjects/dvdlualib/colormap")

-- z(0) = z,    z(n+1) = z(n)*z(n) + z,    n=0,1,2, ...    (1)

io.stdout:setvbuf("no")

-- Changable parameters
local maxCl = 255
local W     = 200
local H     = 200
local szRe  = 2
local szIm  = 2
local nStep = 35
local nZoom = 30
local iTer  = 500
local sfrac = "mandelbrot"
local spale = "hsv"
local brdcl = colr(0, 250, 100)
local brdup = true

--- Dinamic parameters and constants
local cexp   = ToComplex(math.exp(1))
local w2, h2 = W/2, H/2
local gr     = 1.681

setColorMap("wikipedia",
{
  { 66,  30,  15}, -- brown 3
  { 25,   7,  26}, -- dark violett
  {  9,   1,  47}, -- darkest blue
  {  4,   4,  73}, -- blue 5
  {  0,   7, 100}, -- blue 4
  { 12,  44, 138}, -- blue 3
  { 24,  82, 177}, -- blue 2
  { 57, 125, 209}, -- blue 1
  {134, 181, 229}, -- blue 0
  {211, 236, 248}, -- lightest blue
  {241, 233, 191}, -- lightest yellow
  {248, 201,  95}, -- light yellow
  {255, 170,   0}, -- dirty yellow
  {204, 128,   0}, -- brown 0
  {153,  87,   0}, -- brown 1
  {106,  52,   3}  -- brown 2
})

open("Fractal plot 2D")
size(W,H)
zero(0, 0)
updt(false) -- disable auto updates

--[[
Zoom: {3375}
Cent: {-0.10109678819444,-0.95628602430556}
Area: {-0.10109910300926,-0.10109447337963,-0.95628833912037,-0.95628370949074}
]]

local S = makeFractal(W,H,-szRe,szRe,-szIm,szIm,brdcl,brdup)
      S:SetControlWX(wx)
      -- S:SetArea(-1.406574048011,-1.406574042524,0.00025352709190672,0.00025353257887517)
      S:Register("DRWEX","mandelbrot",function (Z, C, R) Z:Pow(2); Z:Add(C); R[1] = Z:getAngRad(); end )
      S:Register("DRWEX","mandelbar" ,function (Z, C, R) Z:Pow(2); Z:NegIm(); Z:Add(C) end )
      S:Register("DRWEX","julia1"    ,function (Z, C, R) Z:Pow(2); Z:Add(ToComplex("-0.8+0.156i")) end )
      S:Register("DRWEX","julia2"    ,function (Z, C, R) Z:Set(cexp^(Z^3) - 0.621) end )
      S:Register("DRWEX","julia3"    ,function (Z, C, R) Z:Set(cexp^Z) Z:Sub(0.65) end )
      S:Register("DRWEX","julia4"    ,function (Z, C, R) Z:Pow(3) Z:Add(0.4)  end )
      S:Register("DRWEX","julia5"    ,function (Z, C, R) Z:Set((Z^4) * cexp^Z + 0.41 )  end )
      S:Register("DRWEX","julia6"    ,function (Z, C, R) Z:Set((Z^3) * cexp^Z + 0.33 )  end )
      S:Register("PALET","default"   ,function (Z, C, n) return
        (math.floor((64  * n) % maxCl)), (math.floor((128 * n) % maxCl)), (math.floor((192 * n) % maxCl)) end )
      S:Register("PALET","rediter"   ,function (Z, C, i) return math.floor((1-(i / iTer)) * maxCl), 0, 0 end )
      S:Register("PALET","greenbl"   ,function (Z, C, i, x, y)
        local it = i / iTer; return math.floor(0), math.floor((1 - it) * maxCl), math.floor(     it  * maxCl) end)
      S:Register("PALET","wikipedia"   ,function (Z, C, i, x, y, R) return getColorMap("wikipedia",i) end)
      S:Register("PALET","region"      ,function (Z, C, i, x, y) return getColorRegion(i,iTer,10) end)
      S:Register("PALET","hsl", function (Z, C, i, x, y) local it = i / iTer; return getColorHSL(it*360,it,it) end)
      S:Register("PALET","hsv", function (Z, C, i, x, y) local it = i / iTer; return getColorHSV(it*360,1,1) end)
      S:Register("PALET","wikipedia_r"   ,function (Z, C, i, x, y, R) return getColorMap("wikipedia",i * (R[1] and 1+math.floor(math.abs(R[1])) or 1)) end)


S:Draw(sfrac,spale,iTer)

while true do
  local lx, ly = clck('ld')
  local rx, ry = clck('rd')
  local key = char()
  if(key or (lx and ly) or (rx and ry)) then
    logStatus(nil,"LFT: {"..tostring(lx)..","..tostring(ly).."}")
    logStatus(nil,"RGH: {"..tostring(rx)..","..tostring(ry).."}")
    logStatus(nil,"KEY: {"..tostring(key).."}")
    if    (lx and ly) then
      S:SetCenter(lx,ly)
      S:Zoom( nZoom)
    elseif(rx and ry) then
      S:SetCenter(rx,ry)
      S:Zoom(-nZoom)
    end
    logStatus(nil,S:GetKey("dirU"))
    if    (key == S:GetKey("dirU")) then S:MoveCenter(0,-nStep)
    elseif(key == S:GetKey("dirD")) then S:MoveCenter(0, nStep)
    elseif(key == S:GetKey("dirL")) then S:MoveCenter(-nStep,0)
    elseif(key == S:GetKey("dirR")) then S:MoveCenter( nStep,0) end
    S:Draw(sfrac,spale,iTer)
  end
  updt()
  wait(0.2)
end
