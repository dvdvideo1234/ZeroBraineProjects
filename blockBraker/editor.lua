local wx       = require("wx")
local turtle   = require("turtle")
local colormap = require("colormap")
local complex  = require("complex")
local keys     = require("blockBraker/keys")
local common   = require("common")
local level    = require("blockBraker/level")
local export   = require("export") 

local logStatus = common.logStatus

local W, H     = level.getScreenSize()

local clBlu = colr(colormap.getColorBlueRGB())
local clBlk = colr(colormap.getColorBlackRGB())
local clGrn = colr(colormap.getColorGreenRGB())
local clGry180 = colr(colormap.getColorPadRGB(180))
local clRed = colr(colormap.getColorRedRGB())
local vlMgn = colr(colormap.getColorMagenRGB())

local __items = {} -- Items stack
local __setup = {}
local __mode  = {
  ID = 1,
  ST = {"board", "ball", "brick"},
  CM = {
    "Board player controlled",
    "Balls which break blocks",
    "Ordinary breakable blocks"
  },
  DT = {
    { ID = 1, 
      {"Velocity" , 10, 0.1 , {0.1}, true},
      {"Angle"    , 0 , -1  , {-360, 360}},
      {"Static"   , false}  ,
      {"Hard"     , true}   ,
      {"Life"     , 1  , 0.1, {0.1}},
      {"Color R"  , 255, 1  , {0, 255}},
      {"Color G"  , 0  , 1  , {0, 255}},
      {"Color B"  , 0  , 1  , {0, 255}},
      {"Trail"    , 0  , 1  , {0}}
    },
    {ID = 1,
      {"Size"  , 5 , 0.1, {0.1}, true},
      {"Damage", 1 , 0.1,  nil , true},
      {"Angle" , 0 , -1, {-360, 360}},
      {"Static", false},
      {"Hard"  , true},
      {"Life"  , 1 , 0.1, {0.1}},      
      {"Color R"     , 0  , 1, {0, 255}},
      {"Color G"     , 255, 1, {0, 255}},
      {"Color B"     , 0  , 1, {0, 255}},
      {"Trail" , 0, 1, {0}}
    },
    {ID = 1,
      {"Angle"  , 0    , -1, {-360, 360}},
      {"Static" , true },
      {"Hard"   , false},
      {"Life"   , 3    , 0.1, {0.1}},
      {"Color R", 0    , 1, {0, 255}},
      {"Color G", 0    , 1, {0, 255}},
      {"Color B", 255  , 1, {0, 255}},
      {"Trail"  , 0    , 1, {0}}
    }
  },
  SL = {0, 0, 0}
  -- table/position/velocity/vertexes(clockwise)/angle/static/hard/life/colorRGB/trail
  EX = { Base = "{Type=\"%s\"%s}/%s/%s/%s/%f/%s/%s/%f/%d,%d,%d/%d", ",Velocity=%f", ",Size=%f,Damage=%f", ""}
}

local function getVertex(tBlk)
  local vT, vtx = "", tBlk.vtx
  for ID = 1, #vtx do
    vT = vT..tostring(vtx[ID]):sub(2,-2)
    if(vtx[ID+1]) then vT = vT..";" end
  end; return vT
end

local function getValueSet(sNam, tSet, iD, vF)
  local exp = tostring(__mode.ST[iD])
  if(not (sNam and tSet)) then
    return logStatus("getValueSet("..exp.."): <"..tostring(sNam).."/"..tostring(tSet)..">", vF) end
  local ID = __setup[iD][sNam]; if(not ID) then 
    return logStatus("getValueSet("..exp.."): Cannot retrieve ID for <"..tostring(sNam)..">", vF) end   
  local tDat = tSet[ID]; if(not tDat) then 
    return logStatus("getValueSet("..exp.."): No table provided <"..tostring(ID)..">", vF) end   
  local out = tDat[2]; return common.getPick(out~=nil, out, vF)
end

local function getStringTableSet(tSet, iD)
  local tPar, tOut, I = __mode.DT[iD], {}, 1
  while(tPar[I][4]) do
    tOut[I] = getValueSet(tPar[I][1], tSet, iD); I = I + 1
  end; return __mode.EX[iD]:format(unpack(tOut))
end

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
  iO:write("# table/position/velocity/vertexes(clockwise)/angle/static/hard/life/colorRGB/trail\n\n")
  for ID = 1, #__items do
    local tInfo, sType = __items[ID], __mode.ST[ID]
    if(tInfo) then
      iO:write("# "..__mode.CM[ID].."\n")
      local tDat = tInfo.__data
      for I = 1, #tDat do
        local v = tDat[I] if(v) then local set = v.set
          local vtx = getVertex(v)
          local pos = tostring(v.pos):sub(2,-2)
          local vel = tostring(v.vel):sub(2,-2)
          local parE = __mode.EX.Base:format(sType, "%s", pos, vel, vtx,
                     getValueSet("Angle"  , set, ID),
            tostring(getValueSet("Static" , set, ID)),
            tostring(getValueSet("Hard"   , set, ID)),
                     getValueSet("Life"   , set, ID),
                     getValueSet("Color R", set, ID),
                     getValueSet("Color G", set, ID),
                     getValueSet("Color B", set, ID),
                     getValueSet("Trail"  , set, ID))
          -- Generate table and format it inside the string second stage          
          iO:write(parE:format(getStringTableSet(set, ID))); iO:write("\n")
        end
      end; iO:write("\n") 
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

local function drawBricks(tInfo)
  for k, v  in pairs(tInfo.__data) do
    local ang = getValueSet("Angle", v.set, __mode.ID)
    local pos, vtx = v.pos, v.vtx; pos:Action("xy")
    local len, ftx = #vtx, vtx[1]
    for i = 1, len do
      local s = (vtx[i]   or ftx):getRotDeg(ang):Add(pos)
      local e = (vtx[i+1] or ftx):getRotDeg(ang):Add(pos)
      local sx, sy = s:getParts()
      local ex, ey = e:getParts()
      if(not vtx[i+1]) then pncl(vlMgn) else pncl(clBlu) end
      line(sx, sy, ex, ey)
    end
  end
end

local function drawBalls(tInfo)
  for k, v  in pairs(tInfo.__data) do
    local pos, vel = v.pos, v.vel; pos:Action("xy")
    local px, py = pos:getParts()
    pncl(clBlk); oval(px, py, 5, 5, clGrn)
    if(vel) then
      local vx, vy = vel:getParts()
      pncl(clBlk); line(px, py, px+vx, py+vy)
    end
  end
end

local function modPoly(tInfo, bUndo)
  local tTop = tInfo.__data[tInfo.__top]
  if(not bUndo) then
    local rx, ry = keys.getMouseRD()      
    if(rx and ry) then
      if(tTop and tTop.vtx and #tTop.vtx <= 2) then
        local sType = __mode.ST[__mode.ID]
        tInfo.__data[tInfo.__top] = nil
        common.logStatus("Add ["..sType.."]: Deleted missing vertex #"..#tTop.vtx)
      end; if(tTop) then tTop.cmp = true end
      tInfo.__top = tInfo.__top + 1
      tInfo.__data[tInfo.__top] = {
        vtx = {},
        cmp = false,
        vel = complex.getNew(0,0),
        pos = complex.getNew(rx, ry),
        set = export.copyItem(__mode.DT[__mode.ID])
      }; tTop = tInfo.__data[tInfo.__top]
    end
    local lx, ly = keys.getMouseLD()
    if(lx and ly) then
      if(tTop) then
        local v = (complex.getNew(lx, ly) - tTop.pos)
        tTop.vtx[#tTop.vtx + 1] = v 
      end
    end
  else
    if(tTop and tTop.vtx) then tTop.vtx[#tTop.vtx] = nil end
  end
end

local function adjustParam(key, aP, aW, tL)
  local typ = type(aP)
  local cng = ((keys.getPress(key, "up") and 1 or 0) - (keys.getPress(key, "down" ) and 1 or 0))
  if(typ == "boolean") then return common.getPick(cng == 0, aP, not aP) end
  if(typ == "number") then local new = (aP + aW * cng)
    if(tL and tL[1] and new < tL[1]) then return tL[1] end
    if(tL and tL[2] and new > tL[2]) then return tL[2] end
    return new
  end
  return aP
end

local function setSettings(key, tInfo)
  local tTop = tInfo.__data[tInfo.__top]
  if(tTop and tTop.set) then local tSet = tTop.set
    tSet.ID = tSet.ID + ((keys.getPress(key, "right") and 1 or 0) - 
                         (keys.getPress(key, "left" ) and 1 or 0))
    tSet.ID = common.getClamp(tSet.ID, 1, #tSet)
    tCnt = tSet[tSet.ID]
    tCnt[2] = adjustParam(key, tCnt[2], tCnt[3], tCnt[4])
    text("Configure: "..tostring(tSet[tSet.ID][1]).." > "..tostring(tSet[tSet.ID][2]),0,150,0)
  end
end

local function modBall(tInfo, bUndo)
  local tTop = tInfo.__data[tInfo.__top]
  if(not bUndo) then
    local rx, ry = keys.getMouseRD()      
    if(rx and ry) then
      if(tTop) then tTop.cmp = true end
      if(tTop and ((tTop.vel and tTop.vel:getNorm() == 0) or not tTop.vel)) then
        local sType = __mode.ST[__mode.ID]
        tInfo.__data[tInfo.__top] = nil
        common.logStatus("Add ["..sType.."]: Deleted invalid velocity <"..tostring(tTop.vel)..">")
      end
      tInfo.__top = tInfo.__top + 1
      tInfo.__data[tInfo.__top] = {
        vtx = {},
        cmp = false,
        vel = complex.getNew(0, 0),
        pos = complex.getNew(rx, ry), 
        set = export.copyItem(__mode.DT[__mode.ID])
      }; tTop = tInfo.__data[tInfo.__top]
    end
    local lx, ly = keys.getMouseLD()
    if(lx and ly) then local tDat = tInfo.__data[tInfo.__top]
      if(tDat) then
        tDat.vel:Set(lx, ly):Sub(tDat.pos)
      end
    end
  else
    if(tTop) then
      local iTop, tDat = tInfo.__top, tInfo.__data
      tDat[iTop] = nil; iTop = iTop - 1
      while(iTop > 0 and not tDat[iTop]) do iTop = iTop - 1 end
      tInfo.__top = iTop
    end
  end
end

local function mainStart()
  for ID = 1, #__mode.DT do
    __setup[ID] = {}
    local tSet = __mode.DT[ID]
    for I = 1, #tSet do
      __setup[ID][tSet[I][1]] = I
    end
  end
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
    if(sType == "brick" or sType == "board") then
      modPoly(tInfo, keys.getPress(key, "Z"))
      drawBricks(tInfo)
    elseif(sType == "ball") then
      modBall(tInfo, keys.getPress(key, "Z"))
      drawBalls(tInfo)
    end
    setSettings(key, tInfo)
    key = keys.getKey(); updt()
  end
  return true
end

open("Block braker level maker")
size(W, H); zero(0, 0); updt(false) 

mainStart()
