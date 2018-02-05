local wx       = require("wx")
local turtle   = require("turtle")
local colormap = require("colormap")
local complex  = require("complex")
local keys     = require("blockBraker/keys")
local common   = require("common")
local level    = require("blockBraker/level")

local W, H     = level.getScreenSize()

local clBlu = colr(colormap.getColorBlueRGB())
local clBlk = colr(colormap.getColorBlackRGB())
local clGrn = colr(colormap.getColorGreenRGB())
local clGry180 = colr(colormap.getColorPadRGB(180))
local clRed = colr(colormap.getColorRedRGB())
local vlMgn = colr(colormap.getColorMagenRGB())

local __mode  = {
  ID = 1,
  ST = {"board", "ball", "brick"},
  CM = {
    "Board player controlled",
    "Balls which break blocks",
    "Ordinary breakable blocks"
  }
}
local __items = {}

local function saveFile(tStu)
  local fNam, key = "", char()
  while(not (keys.getPress(key, "enter") or keys.getPress(key, "nument"))) do wipe()
    if(key) then
      fNam = fNam..tostring(keys.getChar(key) or ""):sub(1,1)
      if(keys.getPress(key, "backsp")) then fNam = fNam:sub(1,-2) end
    end
    text("Save: "..tostring(fNam):lower(),0,0,0)
    key = char(); updt()
  end; fNam = "blockBraker/levels/"..fNam:lower()..".txt"
  local iO = io.open(fNam, "wb")
  if(not iO) then
    return common.logStatus("saveLevel: File invalid <"..fNam..">", false) end
  iO:write("# Blocks general parameters\n")
  iO:write("# table/position/velocity/vertexes(clockwise)/angle/static/hard/life/colorRGB\n\n")
  for ID = 1, #__items do
    local tInfo, sType = __items[ID], __mode.ST[ID]
    if(tInfo) then local tDat = tInfo.__data
      if(sType == "brick") then
        iO:write("# "..__mode.CM[ID].."\n")
        local sS, sV = "{Type=\"brick\"}/", "/0,0/"
        local sE = "/0/true/false/3/0,0,255/0"
        for k, v in pairs(tDat) do v.cmp = true
          local sT, cen, vtx = "", v.cen, v.vtx
          sT = sT..sS..tostring(cen):sub(2,-2)..sV
          for ID = 1, #vtx do
            sT = sT..tostring(vtx[ID]):sub(2,-2)
            if(vtx[ID+1]) then sT = sT..";" end
          end; sT = sT..sE; iO:write(sT.."\n")
        end; iO:write("\n")
      elseif(sType == "ball") then
        iO:write("# "..__mode.CM[ID].."\n")
        local sS = "{Type=\"ball\",Size=5,Dmg=1}/"
        local sE = "//0/false/true/1/0,255,0/15"
        for k, v in pairs(tDat) do v.cmp = true
          local sC = tostring(v.cen):sub(2,-2)
          local sV = tostring(v.vel):sub(2,-2)
          iO:write(sS..sC.."/"..sV..sE.."\n")
        end; iO:write("\n")
      elseif(sType == "board") then
        iO:write("# "..__mode.CM[ID].."\n")
        local sS, sV = "{Type=\"board\",Vel=10}/", "/0,0/"
        local sE = "/0/false/true/1/255,0,0/3"
        for k, v in pairs(tDat) do v.cmp = true
          local sT, cen, vtx = "", v.cen, v.vtx
          sT = sT..sS..tostring(cen):sub(2,-2)..sV
          for ID = 1, #vtx do
            sT = sT..tostring(vtx[ID]):sub(2,-2)
            if(vtx[ID+1]) then sT = sT..";" end
          end; sT = sT..sE; iO:write(sT.."\n")
        end; iO:write("\n")
      end
    end
  end
  iO:flush()
  iO:close()
  return true
end

local function drawComplexOrigin(oC, nS, oO, tX)
  local ss = (tonumber(nS) or 2)
  local xx, yy = oC:getParts()
  if(oO) then
    local ox, ox = oO:getParts()
    pncl(clGry180); line(ox, ox, xx, yy)
  end
  if(tX) then
    pncl(clBlk); text(tostring(tX),0,xx,yy)
  end
  pncl(vlMgn); rect(xx-ss, yy-ss, 2*ss+1, 2*ss+1)
end

complex.setAction("xy", drawComplexOrigin)

local function drawBricks(tLst)
  for k, v  in pairs(tLst) do
    local cen, vtx = v.cen, v.vtx; cen:Act("xy")
    local len, ftx = #vtx, vtx[1]
    for i = 1, len do
      local s = cen + (vtx[i]   or ftx)
      local e = cen + (vtx[i+1] or ftx)
      local sx, sy = s:getParts()
      local ex, ey = e:getParts()
      if(not vtx[i+1]) then pncl(vlMgn) else pncl(clBlu) end
      line(sx, sy, ex, ey)
    end
  end
end

local function drawBalls(tLst)
  for k, v  in pairs(tLst) do
    local cen, vel = v.cen, v.vel; cen:Act("xy")
    local px, py = cen:getParts()
    pncl(clBlk); oval(px, py, 5, 5, clGrn)
    if(vel) then
      local vx, vy = vel:getParts()
      pncl(clBlk); line(px, py, px+vx, py+vy)
    end
  end
end

local function mainStart()
  local key = keys.getKey()
  while(not keys.getPress(key, "escape")) do wipe()
    local tInfo = __items[__mode.ID]
    local sType = __mode.ST[__mode.ID]
    if(not tInfo) then
      __items[__mode.ID] = {__top = 0, __data = {}}
      tInfo = __items[__mode.ID]
    end
    if    (keys.getPress(key, "f1")) then __mode.ID = 1
    elseif(keys.getPress(key, "f2")) then __mode.ID = 2
    elseif(keys.getPress(key, "f3")) then __mode.ID = 3
    elseif(keys.getPress(key, "S")) then saveFile(__items) end
    text("Adding: "..tostring(__mode.ST[__mode.ID]),0,0,0)
    if(sType == "brick") then
      local rx, ry = keys.getMouseRD()      
      if(rx and ry) then local tTop = tInfo.__data[tInfo.__top]
        if(tTop and tTop.vtx and #tTop.vtx <= 2) then
          tInfo.__data[tInfo.__top] = nil
          common.logStatus("brick["..sType.."]: Deleted missing vertex #"..#tTop.vtx)
        end
        if(tTop) then tTop.cmp = true end
        tInfo.__top = tInfo.__top + 1
        tInfo.__data[tInfo.__top] = {cen = complex.getNew(rx, ry), vtx = {}, cmp = false}
      end
      local lx, ly = keys.getMouseLD()
      if(lx and ly) then local tDat = tInfo.__data[tInfo.__top]
        if(tDat) then
          local v = (complex.getNew(lx, ly) - tDat.cen)
          tDat.vtx[#tDat.vtx + 1] = v 
        end
      end
      drawBricks(tInfo.__data)
    elseif(sType == "ball") then
      local rx, ry = keys.getMouseRD()      
      if(rx and ry) then
        local tTop = tInfo.__data[tInfo.__top]
        if(tTop) then tTop.cmp = true end
        if(tTop and ((tTop.vel and tTop.vel:getNorm() == 0) or not tTop.vel)) then 
          tInfo.__data[tInfo.__top] = nil
          common.logStatus("ball["..sType.."]: Deleted invalid velocity "..tostring(tTop.vel))
        end
        tInfo.__top = tInfo.__top + 1
        tInfo.__data[tInfo.__top] = {cen = complex.getNew(rx, ry), cmp = false}
      end
      local lx, ly = keys.getMouseLD()
      if(lx and ly) then local tDat = tInfo.__data[tInfo.__top]
        if(tDat) then
          tDat.vel = (complex.getNew(lx, ly) - tDat.cen)
        end
      end
      drawBalls(tInfo.__data)
    elseif(sType == "board") then
      local rx, ry = keys.getMouseRD()      
      if(rx and ry) then local tTop = tInfo.__data[tInfo.__top]
        if(tTop and tTop.vtx and #tTop.vtx <= 2) then
          tInfo.__data[tInfo.__top] = nil
          common.logStatus("brick["..sType.."]: Deleted missing vertex #"..#tTop.vtx)
        end
        if(tTop) then tTop.cmp = true end
        tInfo.__top = tInfo.__top + 1
        tInfo.__data[tInfo.__top] = {cen = complex.getNew(rx, ry), vtx = {}, cmp = false}
      end
      local lx, ly = keys.getMouseLD()
      if(lx and ly) then local tDat = tInfo.__data[tInfo.__top]
        if(tDat) then
          local v = (complex.getNew(lx, ly) - tDat.cen)
          tDat.vtx[#tDat.vtx + 1] = v 
        end
      end
      drawBricks(tInfo.__data)
    end
    key = keys.getKey(); updt()
  end
  return true
end

open("Block braker level maker")
size(W, H); zero(0, 0); updt(false) 

mainStart()