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
local W     = 160
local H     = 160
local szRe  = 2
local szIm  = 2
local nStep = 35
local nZoom = 30
local iTer  = 200
local sfrac = "mandelbar"
local spale = "hsl"
local brdcl = colr(255, 30, 100)

--- Dinamic parameters and constants
local cexp   = ToComplex(math.exp(1))
local w2, h2 = W/2, H/2
local gr     = 1.681

open("Union 2D Plot")
size(W,H)
zero(0, 0) 
updt(false) -- disable auto updates

--[[
Zoom: {3375}
Cent: {-0.10109678819444,-0.95628602430556}
Area: {-0.10109910300926,-0.10109447337963,-0.95628833912037,-0.95628370949074}
]]

local S = makeUnion(W,H,-szRe,szRe,-szIm,szIm,brdcl)
      S:SetControlWX(wx)
      S:SetArea(-1.406574048011,-1.406574042524,0.00025352709190672,0.00025353257887517)
      S:Register("UDRAW","mandelbrot",function (Z, C, A) Z:Pow(2); Z:Add(C) end )
      S:Register("UDRAW","mandelbar" ,function (Z, C, A) Z:Pow(2); Z:NegIm(); Z:Add(C) end )
      S:Register("UDRAW","julia1"    ,function (Z, C, A) Z:Pow(2); Z:Add(ToComplex("-0.8+0.156i")) end )
      S:Register("UDRAW","julia2"    ,function (Z, C, A) Z:Set(cexp^(Z^3) - 0.621) end )
      S:Register("UDRAW","julia3"    ,function (Z, C, A) Z:Set(cexp^Z) Z:Sub(0.65) end )
      S:Register("UDRAW","julia4"    ,function (Z, C, A) Z:Pow(3) Z:Add(0.4)  end )
      S:Register("UDRAW","julia5"    ,function (Z, C, A) Z:Set((Z^4) * cexp^Z + 0.41 )  end )
      S:Register("UDRAW","julia6"    ,function (Z, C, A) Z:Set((Z^3) * cexp^Z + 0.33 )  end )
      S:Register("PALET","default"   ,function (Z, C, n) return
        (math.floor((64  * n) % maxCl)), (math.floor((128 * n) % maxCl)), (math.floor((192 * n) % maxCl)) end )
      S:Register("PALET","rediter"   ,function (Z, C, i) return math.floor((1-(i / iTer)) * maxCl), 0, 0 end )
      S:Register("PALET","greenbl"   ,function (Z, C, i, x, y)
        local it = i / iTer; return math.floor(0), math.floor((1 - it) * maxCl), math.floor(     it  * maxCl) end)
      S:Register("PALET","wikipedia"   ,function (Z, C, i, x, y) return getColorMap("wikipedia",i) end)
      S:Register("PALET","region"      ,function (Z, C, i, x, y) return getColorRegion(i,iTer,10) end)
      S:Register("PALET","hsl", function (Z, C, i, x, y) local it = i / iTer; return getColorHSL(it*360,it,it) end)
      S:Register("PALET","hsv", function (Z, C, i, x, y) local it = i / iTer; return getColorHSV(it*360,1,1) end)
            

S:Draw(sfrac,spale,iTer)

while true do
  local lx, ly = clck('ld')
  local rx, ry = clck('rd')
  local key = char()
  if(key or (lx and ly) or (rx and ry)) then
    LogLine("LFT: {"..tostring(lx)..","..tostring(ly).."}")
    LogLine("RGH: {"..tostring(rx)..","..tostring(ry).."}")
    LogLine("KEY: {"..tostring(key).."}")
    if    (lx and ly) then
      S:SetCenter(lx,ly)
      S:Zoom( nZoom)
    elseif(rx and ry) then
      S:SetCenter(rx,ry)
      S:Zoom(-nZoom)
    end
    LogLine(S:GetKey("dirU"))
    if    (key == S:GetKey("dirU")) then S:MoveCenter(0,-nStep)
    elseif(key == S:GetKey("dirD")) then S:MoveCenter(0, nStep)
    elseif(key == S:GetKey("dirL")) then S:MoveCenter(-nStep,0)
    elseif(key == S:GetKey("dirR")) then S:MoveCenter( nStep,0) end
    S:Draw(sfrac,spale,iTer)
  end
  updt()
  wait(0.2) 
end
