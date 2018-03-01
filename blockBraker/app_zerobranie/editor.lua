require("lib/paths").regDir("E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms","*.lua")

-- Global libraries
local turtle    = require("turtle"  )
local common    = require("common"  )
local complex   = require("complex" )
local colormap  = require("colormap")

-- Local project libraries
local keys      = require("lib/keys" )
local level     = require("lib/level")

local logStatus = common.logStatus

local W, H  = level.getScreenSize()

local clBlu = colr(colormap.getColorBlueRGB())
local clBlk = colr(colormap.getColorBlackRGB())
local clGrn = colr(colormap.getColorGreenRGB())
local clRed = colr(colormap.getColorRedRGB())
local vlMgn = colr(colormap.getColorMagenRGB())
local clGry180 = colr(colormap.getColorPadRGB(180))

local __items = {__size = 0} -- Items stack
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
  SL = {0, 0, 0},
  -- table/position/velocity/vertexes(clockwise)/angle/static/hard/life/colorRGB/trail
  EX = { Base = "{Type=\"%s\"%s}/%s/%s/%s/%f/%s/%s/%f/%d,%d,%d/%d", ",Velocity=%f", ",Size=%f,Damage=%f", ""}
}

local function typeID(iID)
  if(iID) then __mode.ID = iID end
  return __mode.ID
end

local function typeSelect(iID, vID)
  if(vID) then __mode.SL[iID] = vID end
  return __mode.SL[iID]
end

local function typeName(iID)     return __mode.ST[iID] end
local function typeData(iID)     return __mode.DT[iID] end
local function typeComment(iID)  return __mode.CM[iID] end
local function typeExport(iID)   return __mode.EX[iID] end
local function getItems()        return __items end
local function getItem(iID)      return __items[iID] end
local function setItem(iID, vI)         __items[iID] = vI end
local function addItem(iID)
  setItem(iID, {__top = 0, __data = {}, __name = typeName(iID)})
  if(__items.__size <= iID) then __items.__size = iID end
  return getItem(iID)
end
local function getItemsN()   return __items.__size end
local function isSelected(aKey, iID) return (aKey == typeSelect(iID)) end


local function getVertex(tBlk)
  local vT, vtx = "", tBlk.vtx
  for ID = 1, #vtx do
    vT = vT..tostring(vtx[ID]):sub(2,-2)
    if(vtx[ID+1]) then vT = vT..";" end
  end; return vT
end

local function getValueSet(sNam, tSet, iD, vF)
  local exp = typeName(iD)
  if(not (sNam and tSet)) then
    return logStatus("getValueSet("..exp.."): <"..tostring(sNam).."/"..tostring(tSet)..">", vF) end
  local ID = __setup[iD][sNam]; if(not ID) then 
    return logStatus("getValueSet("..exp.."): Cannot retrieve ID for <"..tostring(sNam)..">", vF) end   
  local tDat = tSet[ID]; if(not tDat) then 
    common.logTable(tSet, "getValueSet: tSet")
    return logStatus("getValueSet("..exp.."): No table provided <"..tostring(ID)..">", vF) end   
  local out = tDat[2]; return common.getPick(out~=nil, out, vF)
end

local function getItemColor(tSet, iD)
  return getValueSet("Color R", tSet, iD),
         getValueSet("Color G", tSet, iD),
         getValueSet("Color B", tSet, iD)
end

local function getStringSet(tSet, iD)
  local tPar, tOut, I = typeData(iD), {}, 1
  while(tPar[I][5]) do tOut[I] = getValueSet(tPar[I][1], tSet, iD); I = I + 1
  end; return typeExport(iD):format(unpack(tOut))
end

local function saveFile()
  local fNam, tStu, key = "", getItems(), char()
  while(not (keys.getPress(key, "enter") or keys.getPress(key, "nument"))) do wipe()
    if(key) then
      fNam = fNam..tostring(keys.getChar(key) or ""):sub(1,1)
      if(keys.getPress(key, "backsp")) then fNam = fNam:sub(1,-2) end
    end
    text("Save: "..tostring(fNam):lower(),0,0,0)
    key = char(); updt()
  end; fNam = "levels/"..fNam:lower()..".txt"
  local iO = io.open(fNam, "wb")
  if(not iO) then
    return common.logStatus("saveLevel: File invalid <"..fNam..">", false) end
  iO:write("# Blocks general parameters\n")
  iO:write("# table/position/velocity/vertexes(clockwise)/angle/static/hard/life/colorRGB/trail\n\n")
  local tItems = getItems()
  for ID = 1, getItemsN() do
    local tInfo, sType = getItem(ID), typeName(ID)
    if(tInfo) then local tDat = tInfo.__data
      iO:write("# "..typeComment(ID).."\n")
      for I = 1, #tDat do
        local v = tDat[I]
          if(v) then
            local tSet = v.set
            local sVtx = getVertex(v)
            local sPos = tostring(v.pos):sub(2,-2)
            local sVel = tostring(v.vel):sub(2,-2)
            local parE = typeExport("Base"):format(sType, "%s", sPos, sVel, sVtx,
                     getValueSet("Angle"  , tSet, ID),
            tostring(getValueSet("Static" , tSet, ID)),
            tostring(getValueSet("Hard"   , tSet, ID)),
                     getValueSet("Life"   , tSet, ID),
                     getValueSet("Color R", tSet, ID),
                     getValueSet("Color G", tSet, ID),
                     getValueSet("Color B", tSet, ID),
                     getValueSet("Trail"  , tSet, ID))
          -- Generate table and format it inside the string second stage
          iO:write(parE:format(getStringSet(tSet, ID))); iO:write("\n")
        end
      end; iO:write("\n") 
    end
  end
  iO:flush()
  iO:close()
  return true
end

local function drawComplexOrigin(oC, nS, oO, clDrw)
  local ss = common.getClamp(tonumber(nS) or 0, 0, 50)
  local xx, yy = oC:getParts()
  local ox, oy = nil, nil
  if(oO) then ox, oy = oO:getParts()
    pncl(clBlk); line(ox, oy, xx, yy)
  end
  pncl(clDrw or vlMgn); rect(xx-ss, yy-ss, 2*ss, 2*ss)
end

complex.setAction("editor_draw_complex", drawComplexOrigin)

local function drawPoly(tInfo, vID)
  local iID  = common.getPick(vID, vID, typeID())
  local tDat = tInfo.__data
  for k, v  in pairs(tDat) do
    local ang = getValueSet("Angle", v.set, iID)
    local r, g, b = getItemColor(v.set, iID)
    local clr = colr(r, g, b)
    local pos, vtx = v.pos, v.vtx
    if(isSelected(k, iID)) then pos:Action("editor_draw_complex", 10) end
    local len, ftx = #vtx, vtx[1]; pos:Action("editor_draw_complex", 3)
    for i = 1, len do 
      local s = (vtx[i]   or ftx):getRotDeg(ang):Add(pos)
      local e = (vtx[i+1] or ftx):getRotDeg(ang):Add(pos)
      local sx, sy = s:getParts()
      local ex, ey = e:getParts()
      if(not vtx[i+1]) then
        pncl(vlMgn)
      else
        pncl(clr)
      end
      line(sx, sy, ex, ey)
    end
  end
end

local function drawBall(tInfo, vID)
  local iID  = common.getPick(vID, vID, typeID())
  local tDat = tInfo.__data
  for k, v  in pairs(tDat) do
    local pos, vel = v.pos, v.vel
    local r, g, b = getItemColor(v.set, iID)
    local clr = colr(r, g, b)
    local px, py = pos:getParts()
    local sz = getValueSet("Size", v.set, iID)
    if(isSelected(k, iID)) then pos:Action("editor_draw_complex",sz + 4) end
    pncl(clBlk); oval(px, py, sz, sz, clr)
    if(vel) then
      local vx, vy = vel:getParts()
      pncl(clBlk); line(px, py, px+vx, py+vy)
    end
  end
end

local function modPoly(tInfo, bUndo)
  local tDat = tInfo.__data
  local tTop = tDat[tInfo.__top]
  local tSel = tDat[typeSelect(typeID())]
  if(not bUndo) then
    local rx, ry = keys.getMouseRD()      
    if(rx and ry) then
      if(tTop and tTop.vtx and #tTop.vtx <= 2) then
        local sType = typeName(typeID())
        tDat[tInfo.__top] = nil; tInfo.__top = tInfo.__top - 1
        common.logStatus("Add ["..sType.."]: Deleted missing vertex #"..#tTop.vtx)
      end; if(tTop) then tTop.cmp = true end
      tInfo.__top = tInfo.__top + 1
      tDat[tInfo.__top] = {
        vtx = {},
        cmp = false,
        vel = complex.getNew(0,0),
        pos = complex.getNew(rx, ry),
        set = common.copyItem(typeData(typeID()))
      }
      tTop = tDat[tInfo.__top]; tTop.set["FUNC"] = "modPoly"
      typeSelect(typeID(), tInfo.__top)
    end
    local lx, ly = keys.getMouseLD()
    if(lx and ly) then
      if(tSel) then
        local v = (complex.getNew(lx, ly) - tSel.pos)
        tSel.vtx[#tSel.vtx + 1] = v 
      end
    end
  else
    if(tTop) then local nVtx = common.getPick(tTop.vtx, #tTop.vtx, 0)
      if(nVtx == 0) then
        tDat[tInfo.__top] = nil
        tInfo.__top = (tInfo.__top - 1)
        tTop = tDat[tInfo.__top]
      else
        if(tTop and tTop.vtx) then
          tTop.vtx[#tTop.vtx] = nil end
      end
    end
  end
end

local function adjustParam(key, aP, aW, tL)
  local typ = type(aP)
  local cng = ((keys.getPress(key, "up") and 1 or 0) - 
               (keys.getPress(key, "down" ) and 1 or 0))
  if(typ == "boolean") then return common.getPick(cng == 0, aP, not aP) end
  if(typ == "number") then local new = (aP + aW * cng)
    if(tL and tL[1] and new < tL[1]) then return tL[1] end
    if(tL and tL[2] and new > tL[2]) then return tL[2] end
    return new
  end
  return aP
end

local function setSettings(key, tInfo)
  local iTyp = typeID()
  local tDat = tInfo.__data
  local tTop = tDat[tInfo.__top]
  local iSel = typeSelect(iTyp)
  local tSel = tDat[iSel]
  if(tSel) then
    iSel = iSel + ((keys.getPress(key, "pgup") and 1 or 0) - 
                   (keys.getPress(key, "pgdn") and 1 or 0))
    iSel = common.getClamp(iSel, 1, tInfo.__top)
    typeSelect(iTyp, iSel)
    -- Adjust the settings union for every item
    if(tSel.set) then local tSet = tSel.set
      tSet.ID = tSet.ID + ((keys.getPress(key, "right") and 1 or 0) - 
                           (keys.getPress(key, "left" ) and 1 or 0))
      tSet.ID = common.getClamp(tSet.ID, 1, #tSet); tCnt = tSet[tSet.ID]
      tCnt[2] = adjustParam(key, tCnt[2], tCnt[3], tCnt[4])
      text("Configure: "..tostring(tSet[tSet.ID][1]).." > "..tostring(tSet[tSet.ID][2]),0,100,0)
    end
    if(tSel.__vel) then
      local dif = (keys.getPress(key, "num+") and  1 or 0) +
                  (keys.getPress(key, "num-") and -1 or 0)
      tSel.__vel:Add(tSel.__vel:getUnit():Mul(dif))
    end
    if(tSel.pos) then
      local px, py = tSel.pos:getParts()
            px  = px + ((keys.getPress(key, "num3") and 1 or 0) +
                        (keys.getPress(key, "num6") and 1 or 0) +
                        (keys.getPress(key, "num9") and 1 or 0) - 
                        (keys.getPress(key, "num1") and 1 or 0) -
                        (keys.getPress(key, "num4") and 1 or 0) -
                        (keys.getPress(key, "num7") and 1 or 0))
            py  = py + ((keys.getPress(key, "num1") and 1 or 0) +
                        (keys.getPress(key, "num2") and 1 or 0) +
                        (keys.getPress(key, "num3") and 1 or 0) - 
                        (keys.getPress(key, "num7") and 1 or 0) -
                        (keys.getPress(key, "num8") and 1 or 0) - 
                        (keys.getPress(key, "num9") and 1 or 0))
      tSel.pos:Set(px, py)
      text("Position ["..typeSelect(iTyp).."]: "..tostring(tSel.pos),0,280,0)
    end
  end
end

local function modBall(tInfo, bUndo)
  local tDat = tInfo.__data
  local tTop = tDat[tInfo.__top]
  local tSel = tDat[typeSelect(typeID())]
  if(not bUndo) then
    local rx, ry = keys.getMouseRD()      
    if(rx and ry) then
      if(tTop and ((tTop.vel and tTop.vel:getNorm() == 0) or not tTop.vel)) then
        tDat[tInfo.__top] = nil; tInfo.__top = (tInfo.__top - 1)
        common.logStatus("Add ["..typeName(typeID()).."]: Deleted invalid velocity <"..tostring(tTop.vel)..">")
      end; if(tTop) then tTop.cmp = true end
      tInfo.__top = tInfo.__top + 1
      tDat[tInfo.__top] = {
        vtx = {},
        cmp = false,
        vel = complex.getNew(0, 0),
        pos = complex.getNew(rx, ry), 
        set = common.copyItem(typeData(typeID())),
        __vel = complex.getNew(0, 0)
      }
      tTop = tDat[tInfo.__top]; tTop.set["FUNC"] = "modBall"
      typeSelect(typeID(), tInfo.__top)
    end
    local lx, ly = keys.getMouseLD()
    if(lx and ly and tSel) then
      tSel.__vel:Set(lx, ly):Sub(tSel.pos); tSel.vel:Set(tSel.__vel)
    end
    if(tSel and tSel.vel and tSel.__vel) then
      tSel.vel:Set(tSel.__vel):RotDeg(getValueSet("Angle", tSel.set, typeID()))
    end
  else
    if(tTop) then
      tDat[tInfo.__top] = nil
      tInfo.__top = tInfo.__top - 1
      while(tInfo.__top > 0 and not tDat[tInfo.__top]) do
        tInfo.__top = tInfo.__top - 1
      end
    end
  end
end

local function drawStuff()
  local tItems, nCnt = getItems(), getItemsN()
  for ID = 1, nCnt do
    local tInfo = getItem(ID)
    local sType = typeName(ID)
    if(tInfo) then
      local tData = tInfo.__data
      local niTop = tInfo.__top
      for DI = 1, niTop do
        if(sType == "brick" or sType == "board") then
          drawPoly(tInfo, ID)
        elseif(sType == "ball") then
          drawBall(tInfo, ID)
        end
      end
    end
  end
end

local function mainStart()
  for ID = 1, #__mode.DT do __setup[ID] = {}
    local tSet = typeData(ID)
    for I = 1, #tSet do __setup[ID][tSet[I][1]] = I end
  end
  local key  = keys.getKey()
  while(not keys.getPress(key, "escape")) do wipe()
    local tInfo = getItem(typeID())
    if    (keys.getPress(key, "f1")) then tInfo = getItem(typeID(1))
    elseif(keys.getPress(key, "f2")) then tInfo = getItem(typeID(2))
    elseif(keys.getPress(key, "f3")) then tInfo = getItem(typeID(3))
    elseif(keys.getPress(key, "S")) then saveFile() end
    if(not tInfo) then tInfo = addItem(typeID()) end
    local sType = typeName(typeID())
    text("Adding: "..sType,0,0,0)
    if(sType == "brick" or sType == "board") then
      modPoly(tInfo, keys.getPress(key, "Z"))
    elseif(sType == "ball") then
      modBall(tInfo, keys.getPress(key, "Z"))
    end
    drawStuff()
    setSettings(key, tInfo)
    key = keys.getKey(); updt()
  end
  return true
end

open("Block braker level maker")
size(W, H); zero(0, 0); updt(false) 

mainStart()
