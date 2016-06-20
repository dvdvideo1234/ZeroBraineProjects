local type         = type
local math         = math
local string       = string
local tonumber     = tonumber
local tostring     = tostring
local setmetatable = setmetatable

local metaUnion = {}

function makeUnion(w,h,minw,maxw,minh,maxh)
  local self, uniNames, conKeys, uZoom = {}, {}, {}, 1
  local imgW, imgH = w, h
  local imgCx, imgCy = (w / 2), (h / 2)
  local minRe, maxRe = minw, maxw
  local minIm, maxIm = minh, maxh
  local reFac = (maxRe-minRe)/(imgW) -- Re units per pixel
  local imFac = (maxIm-minIm)/(imgH) -- Im units per pixel
  local uniCr, uniCi = minRe + ((maxRe - minRe) / 2), minIm + ((maxIm - minIm) / 2)
  function self:SetControlWX(wx)
    conKeys.dirU, conKeys.dirD = (wx["WXK_UP"]   or -1), (wx["WXK_DOWN"]  or -1)
    conKeys.dirL, conKeys.dirR = (wx["WXK_LEFT"] or -1), (wx["WXK_RIGHT"] or -1)
    conKeys.zooP, conKeys.zooM = (wx["wxEVT_LEFT_DOWN"] or -1), (wx["wxEVT_LEFT_DOWN"] or -1)
  end
  function self:GetKey(sKey) return conKeys[tostring(sKey)] end
  function self:SetArea(vminRe, vmaxRe, vminIm, vmaxIm)
    minRe, maxRe = (tonumber(vminRe) or 0), (tonumber(vmaxRe) or 0)
    minIm, maxIm = (tonumber(vminIm) or 0), (tonumber(vmaxIm) or 0)
    uniCr, uniCi = (minRe + (maxRe - minRe) / 2), (minIm + (maxIm - minIm) / 2)
    reFac = (maxRe - minRe) / (imgW) -- Re units per pixel
    imFac = (maxIm - minIm) / (imgH) -- Im units per pixel
  end
  function self:SetCenter(xCen,yCen,sMode)
    local xCen = tonumber(xCen)
    local yCen = tonumber(yCen)
    if(not xCen) then LogLine("Union.SetCenter: X nan"); return end
    if(not yCen) then LogLine("Union.SetCenter: Y nan"); return end
    local sMode = tostring(sMode or "IMG")
    LogLine("Center("..sMode.."): {"..xCen..","..yCen.."}")
    if(sMode == "IMG") then -- Use the win center in pixels
      if(xCen < 0 or xCen > imgW) then LogLine("Union.SetCenter: X outbound"); return end
      if(yCen < 0 or yCen > imgH) then LogLine("Union.SetCenter: Y outbound"); return end
      local dxP, dyP = (xCen - imgCx), (yCen - imgCy)
      local dxU, dyU = (reFac  * dxP), (imFac *  dyP)
      -- LogLine("Center: DX = "..dxP.." >> "..dxU)
      -- LogLine("Center: DY = "..dyP.." >> "..dyU)
      self:SetArea((minRe + dxU), (maxRe + dxU), (minIm + dyU), (maxIm + dyU))
    elseif(sMode == "POS") then -- Use the union cneter
      local disRe = (maxRe - minRe) / 2
      local disIm = (maxIm - minIm) / 2
      self:SetArea((xCen - disRe), (xCen + disRe), (yCen - disIm), (yCen + disIm))
    else LogLine("Union.SetCenter: Mode "..sMode.." missing")
    end
  end
  function self:MoveCenter(dX, dY)
    LogLine("MoveCenter: {"..dX..","..dY.."}")
    self:SetCenter(imgCx + (tonumber(dX) or 0), imgCy + (tonumber(dY) or 0))
  end
  function self:Zoom(nZoom)
    local nZoom = tonumber(nZoom) or 0
    if(nZoom <= 1 and nZoom >= -1) then LogLine("Union.Zoom("..tostring(nZoom).."): Skipped") return end
    local disRe = (maxRe - minRe) / 2
    local disIm = (maxIm - minIm) / 2
    local midRe = minRe + disRe
    local midIm = minIm + disIm
    if(nZoom > 0) then
      uZoom = uZoom * math.abs(nZoom)
      self:SetArea(midRe - disRe / nZoom, midRe + disRe / nZoom,
                   midIm - disIm / nZoom, midIm + disIm / nZoom)
    elseif(nZoom < 0) then
      self:SetArea(midRe + disRe * nZoom, midRe - disRe * nZoom,
                   midIm + disIm * nZoom, midIm - disIm * nZoom)
      uZoom = uZoom / math.abs(nZoom)
    end
  end
  
  function self:Register(sMeth, fFractal)
    if(type(fFractal) ~= "function") then
      LogLine("Unoin.Register: Unable to register non-function"); return end
    local sMeth = tostring(sMeth or "")
    uniNames[sMeth] = fFractal
  end
  
  function self:Draw(sMeth,maxItr,tArgs)
    local maxItr = tonumber(maxItr) or 0
    if(maxItr < 1) then
      LogLine("Union.Draw: Iteretion depth #"..tostring(maxItr).." invalid"); return end
    local nrmZ
    local sMeth = tostring(sMeth)
    local tArgs = tArgs or {}
    local C = Complex()
    local Z = Complex()
    local maxColor = 255
    local isInside = true
    local r, g, b = 0, 0, 0
    LogLine("Zoom: {"..uZoom.."}")
    LogLine("Cent: {"..uniCr..","..uniCi.."}")
    LogLine("Area: {"..minRe..","..maxRe..","..minIm..","..maxIm.."}")
    for y = 0, imgH do -- Row
      pncl(colr(255, 20, 110))
      line(0,y,imgW,y)
      updt()
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
          if(not uniNames[sMeth]) then
            LogLine("Union.Draw: Invalid method <"..sMeth.."> given"); return end
          uniNames[sMeth](Z, C, tArgs)
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
  
  setmetatable(self,metaUnion)
  
  return self
end