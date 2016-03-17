require("turtle")
require("wx")
require("dvdlualib/complex")

local Log = function(anyArg) io.write(tostring(anyArg).."\n") end
-- z(0) = z,    z(n+1) = z(n)*z(n) + z,    n=0,1,2, ...    (1) 

io.stdout:setvbuf("no")


function Print(tT,sS)
  if(not tT) then
    Log("Print: {nil, name="..tostring(sS or "\"Data\"").."}")
    return nil end
  local S = type(sS)
  local T = type(tT)
  local Key = ""
  if    (S == "string") then S = sS
  elseif(S == "number") then S = tostring(sS)
  else                       S = "Data" end
  if(T ~= "table") then
    Log("{"..T.."}["..tostring(sS or "N/A").."] = "..tostring(tT))
    return
  end
  T = tT
  if(next(T) == nil) then
    Log(S.." = {}")
    return
  end
  Log(S)
  for k,v in pairs(T) do
    if(type(k) == "string") then
      Key = S.."[\""..k.."\"]"
    else
      Key = S.."["..tostring(k).."]"
    end
    if(type(v) ~= "table") then
      if(type(v) == "string") then
        Log(Key.." = \""..v.."\"")
      else
        Log(Key.." = "..tostring(v))
      end
    else
      Print(v,Key)
    end
  end
end


-- get the current screen size
function makeUnion(w,h,minw,maxw,minh,maxh)
  local imgW = w
  local imgH = h
  local imgCx = w / 2
  local imgCy = h / 2
  local minRe = minw
  local maxRe = maxw
  local minIm = minh
  local maxIm = maxh
  local reFac = (maxRe-minRe)/(imgW) -- Re units per pixel
  local imFac = (maxIm-minIm)/(imgH) -- Im units per pixel
  local conKeys = {}
  self = {}
  function self:SetControlWX(wx)
    conKeys.dirU, conKeys.dirD = (wx["WXK_UP"]   or -1), (wx["WXK_DOWN"]  or -1)
    conKeys.dirL, conKeys.dirR = (wx["WXK_LEFT"] or -1), (wx["WXK_RIGHT"] or -1)
    conKeys.zooP, conKeys.zooM = (wx["wxEVT_LEFT_DOWN"] or -1), (wx["wxEVT_LEFT_DOWN"] or -1)
  end
  function self:GetKey(sKey) return conKeys[tostring(sKey)] end
  function self:SetCenter(xCen,yCen)
    local xCen = tonumber(xCen)
    local yCen = tonumber(yCen)
    if(not xCen) then return end
    if(not yCen) then return end
    if(xCen < 0 or xCen > imgW) then return end
    if(yCen < 0 or yCen > imgH) then return end
    Log("Center: {"..xCen..","..yCen.."}")
    local dxP, dyP = (xCen - imgCx), (yCen - imgCy)
    local dxU, dyU = (reFac  * dxP), (imFac *  dyP)
    Log("Center: DX = "..dxP.." >> "..dxU)
    Log("Center: DY = "..dyP.." >> "..dyU)
    minRe = minRe + dxU
    maxRe = maxRe + dxU
    minIm = minIm + dyU
    maxIm = maxIm + dyU
  end
  function self:MoveCenter(dX, dY)
    Log("MoveCenter: {"..dX..","..dY.."}")
    self:SetCenter(imgCx + (tonumber(dX) or 0), imgCy + (tonumber(dY) or 0))
  end
  function self:Zoom(nZoom)
    local nZoom = tonumber(nZoom)
    if(not (nZoom and nZoom ~= 1)) then return end
    local disRe = (maxRe-minRe) / 2
    local disIm = (maxIm-minIm) / 2
    local midRe = minRe + disRe
    local midIm = minIm + disIm
    if(nZoom > 0) then
      Log("(+)Zoom: "..tostring(nZoom))
      minRe = midRe - disRe / nZoom
      maxRe = midRe + disRe / nZoom
      minIm = midIm - disIm / nZoom
      maxIm = midIm + disIm / nZoom
    elseif(nZoom < 0) then
      Log("(-)Zoom: "..tostring(nZoom))
      minRe = midRe + disRe * nZoom
      maxRe = midRe - disRe * nZoom
      minIm = midIm + disIm * nZoom
      maxIm = midIm - disIm * nZoom
    end
    reFac = (maxRe-minRe)/(imgW) -- Re units per pixel
    imFac = (maxIm-minIm)/(imgH) -- Im units per pixel
  end
  
  function self:Mandelbrot(maxItr,nPow)
    local maxItr = tonumber(maxItr)
    if(not (maxItr and maxItr >= 1)) then return end
    local nrmZ
    local P = ToComplex(nPow)
    local C = Complex()
    local Z = Complex()
    local maxColor = 255
    local isInside = true
    local r, g, b = 0, 0, 0
    Log("Plot: "..reFac.." # "..imFac)
    for y = 0, imgH do -- Row
      C:setImag(minIm + y*imFac)
      for x = 0, imgW do -- Col
        C:setReal(minRe + x*reFac)
        Z:Set(C)
        isInside = true
        for n = 1, maxItr do
          nrmZ = Z:getNorm2()
          if(nrmZ > 4) then
            isInside = false
            break
          end
          Z:Pow(P)
          Z:Add(C)
        end
        r, g, b = 0, 0, 0
        if(not isInside) then
          local n = Z:getNorm()
          r = math.floor((64  * n) % maxColor)
          g = math.floor((128 * n) % maxColor)
          b = math.floor((192 * n) % maxColor)
        end
        pncl(colr(r, g, b))
        pixl(x,y) 
      end
      updt()
    end
  end
  return self
end

local W     = 100
local H     = 80
local szRe  = 3
local szIm  = 3
local iTer  = 100
local nPow  = 2
local nStep = 40
local nZoom = 6

open("Union 2D Plot")
size(W,H)
zero(0, 0) 
updt(false) -- disable auto updates

local S = makeUnion(W,H,-szRe,szRe,-szIm,szIm)
      S:SetControlWX(wx)
      S:Mandelbrot(iTer,nPow)

while true do
  local lx, ly = clck('ld')
  local rx, ry = clck('rd')
  local key = char()
  if(key or (lx and ly) or (rx and ry)) then
    Log("LFT: {"..tostring(lx)..","..tostring(ly).."}")
    Log("RGH: {"..tostring(rx)..","..tostring(ry).."}")
    Log("KEY: {"..tostring(key).."}")
    if    (lx and ly) then
      S:SetCenter(lx,ly)
      S:Zoom( nZoom)
    elseif(rx and ry) then
      S:SetCenter(rx,ry)
      S:Zoom(-nZoom)
    end
    Log(S:GetKey("dirU"))
    if    (key == S:GetKey("dirU")) then S:MoveCenter(0,-nStep)
    elseif(key == S:GetKey("dirD")) then S:MoveCenter(0, nStep)
    elseif(key == S:GetKey("dirL")) then S:MoveCenter(-nStep,0)
    elseif(key == S:GetKey("dirR")) then S:MoveCenter( nStep,0) end
    S:Mandelbrot(iTer,nPow)
  end
  updt()
  wait(0.2) 
end





