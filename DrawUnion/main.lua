require("turtle")
require("wx")
require("ZeroBraineProjects/dvdlualib/complex")
require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/fractal")

-- z(0) = z,    z(n+1) = z(n)*z(n) + z,    n=0,1,2, ...    (1) 

io.stdout:setvbuf("no")

-- get the current screen size

local W     = 500
local H     = 500
local szRe  = 2
local szIm  = 2
local nStep = 35
local nZoom = 4
local iTer  = 250
local sfrac = "julia4"

local cexp = ToComplex(math.exp(1))

open("Union 2D Plot")
size(W,H)
zero(0, 0) 
updt(false) -- disable auto updates

local S = makeUnion(W,H,-szRe,szRe,-szIm,szIm)
      S:SetControlWX(wx)
      S:Register("mandelbrot",function (Z, C, A) Z:Pow(2); Z:Add(C) end )
      S:Register("mandelbar" ,function (Z, C, A) Z:Pow(2); Z:NegIm(); Z:Add(C) end )
      S:Register("julia1"    ,function (Z, C, A) Z:Pow(2); Z:Add(ToComplex("-0.8+0.156i")) end )
      S:Register("julia2"    ,function (Z, C, A) Z:Set(cexp^(Z^3) - 0.621) end )
      S:Register("julia3"    ,function (Z, C, A) Z:Set(cexp^Z) Z:Sub(0.65) end )
      S:Register("julia4"    ,function (Z, C, A) Z:Pow(3) Z:Add(0.4)  end )
      S:Register("julia5"    ,function (Z, C, A) Z:Set((Z^4) * cexp^Z + 0.41 )  end )
      S:Register("julia6"    ,function (Z, C, A) Z:Set((Z^3) * cexp^Z + 0.33 )  end )
    
S:Draw(sfrac,iTer)

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
    S:Draw(sfrac,iTer)
  end
  updt()
  wait(0.2) 
end



