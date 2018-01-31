local setmetatable = setmetatable
local complex      = require("complex")
local turtle       = require("turtle")
local colormap     = require("colormap")
local common       = require("common")
local export       = require("export")
local blocks       = {}
local metaBlock    = {}
local toBool       = common.ToBool

local function logStatus(anyMsg, ...)
  io.write(tostring(anyMsg).."\n"); return ...
end

metaBlock.__trace = {}
metaBlock.__type  = "blocks.block"
metaBlock.__index = metaBlock
function blocks.New()
  local self = {}; setmetatable(self, metaBlock)
  local mbPfr, mbTrc = false, false
  local mcAxx, mcAxy, mnAng, maKey = complex.New(), complex.New(), 0
  local mcPos, mcVel, mtVtx = complex.New(), complex.New(), {__size = 0}
  local mbSta, mbHrd, mbWrp, miLif, mtTrc, mclDr, mfAct, mfDrw, mtDat = true, true, true, 0, {}
  function self:setHard(bHrd) mbHrd = bHrd; return self end
  function self:setStat(bSta) mbSta = bSta; return self end
  function self:setLife(nLif) miLif = (tonumber(nLif) or 0); return self end
  function self:getLife() return miLif end
  function self:setPos(x,y) mcPos:Set(x,y):Abs(true,true); return self end
  function self:getPos() return mcPos:getNew() end
  function self:setVel(x,y) mcVel:Set(x,y); return self end
  function self:getVel() return mcVel:getNew() end
  function self:isDead() return (miLif <= 0) end
  function self:isHard() return mbHrd end
  function self:isFrame() return mbPfr end
  function self:isStat() return mbSta end
  function self:isWrap() return mbWrp end
  function self:isTrace() return mbTrc end
  function self:getTable() return mtDat end
  function self:getKey() return maKey end
  function self:setKey(aK) maKey = aK; return self end
  function self:setFrame(bF) mbPfr = toBool(bF); return self end
  function self:setWrap(bR) mbWrp = toBool(bR); return self end
  function self:setAction(fAct) mfAct = ((type(fAct) == "function") and fAct or nil); return self end
  function self:setDraw(fDrw) mfDrw = ((type(fDrw) == "function") and fDrw or nil); return self end
  function self:setTable(tDat) mtDat = ((type(tDat) == "table") and tDat or nil); return self end  
  function self:getVertN() return mtVtx.__size end
  function self:setVert(x,y)
    mtVtx.__size = mtVtx.__size + 1
    mtVtx[mtVtx.__size] = complex.New(x,y); return self
  end
  function self:getVert(vID)
    local iID = math.floor(tonumber(vID) or 0)
    local cV = mtVtx[iID]; return (cV and cV:getNew() or nil)
  end
  function self:getDrawColor() return mclDr end
  function self:setDrawColor(r,g,b)
    mclDr = colr(colormap.getClamp(r),
                 colormap.getClamp(g),
                 colormap.getClamp(b)); return self
  end
  function self:setAng(nA)
    for ID = 1, self:getVertN() do
      mtVtx[ID]:RotDeg(nA) end
    mnAng = mnAng + (tonumber(nA) or 0)
  end
  function self:isAround(cP)
    local ID, N, bO = 1, self:getVertN(), true
    local VI, cS, cE = self:getVert(1), mcPos:getNew(), mcPos:getNew()
    while(ID <= N) do 
      cS:Set(mcPos):Add(self:getVert(ID) or VI); ID = ID + 1 
      cE:Set(mcPos):Add(self:getVert(ID) or VI)
      if(complex.Lay(cP, cS, cE) < 0) then bO = false; break end
    end; if(not self:isWrap()) then bO = (not bO) end
    return bO
  end
  function self:Draw(bVel) -- tect(x,y,w,h)
    if(self:isDead()) then return self end
    if(self:isTrace()) then
      local vKey = self:getKey()
      local tVtx = metaBlock.__trace[vKey]
      if(tVtx and tVtx.__top > 0) then local N, O
        if(tVtx.__top == tVtx.__max) then
          N, E = tVtx.__pos, tVtx.__pos
          E = E + 1; if(E > tVtx.__max) then E = 1 end
          E = E + 1; if(E > tVtx.__max) then E = 1 end
        else N, E = tVtx.__pos, 1 end
        while(N ~= E) do     
          local xp, yp = tVtx[N]:getParts()
          N = N - 1; if(N < 1) then N = tVtx.__max end
          local xm, ym = tVtx[N]:getParts()
          pncl(mclDr); line(xp, yp, xm, ym)
          pncl(mclDr); rect(xp-2, yp-2, 5, 5)
        end
      end
    end
    if(mfDrw) then mfDrw(self); return self end
    local ID, N = 1, self:getVertN()
    local CT, VI = mcPos:getNew(), self:getVert(1)
    while(ID <= N) do local xs, ys, xs, ys     
      xs, ys = CT:Set(mcPos):Add(self:getVert(ID) or VI):getParts(); ID = ID + 1 
      xe, ye = CT:Set(mcPos):Add(self:getVert(ID) or VI):getParts()
      pncl(mclDr); line(xs, ys, xe, ye)
    end
    if(bVel) then local px, py, vx, vy
      px, py = mcPos:getParts()
      vx, vy = mcVel:getParts()
      line(px, py, px+vx, py+vy)
    end
    if(not self:isHard()) then
      local px, py = mcPos:getSub(mcSiz):Floor():getParts()
      pncl(mclDr); text(("%4.2f"):format(self:getLife()),0, px, py)
    end
    return self
  end
  function self:Act()
    if(self:isStat()) then return self end
    if(mfAct) then mfAct(self); return self end
  end
  function self:Move()
    if(self:isStat()) then return self end
    if(self:isFrame()) then self:setFrame(false) else mcPos:Add(mcVel) end
    if(self:isTrace()) then self:addTrace() end; return self
  end
  function self:Damage(iDmg)
    if(self:isHard()) then return self end
    local dmg = (tonumber(iDmg) or 0)
    if(self:isDead() or dmg <= 0) then return self end
    miLif = (miLif - dmg); return self
  end
  function self:Dump(iID)
    logStatus("\n["..metaBlock.__type.."]["..tostring(iID).."]")
    logStatus("  Position: "..tostring(mcPos))
    logStatus("  Velocity: "..tostring(mcVel))
    logStatus("  Hard    : "..tostring(mbHrd))
    logStatus("  Static  : "..tostring(mbSta))
    logStatus("  Life    : "..tostring(miLif))
    logStatus("  Color   : "..tostring(mclDr))
    logStatus("  Vertexes: "); for ID = 1, self:getVertN() do logStatus("    ["..ID.."]: "..self:getVert(ID)) end
    return self
  end
  function self:setTrace(nMax)
    local nM = math.floor(math.abs(tonumber(nMax) or 0))
    if(nM > 0) then  mbTrc = toBool(nM)
      metaBlock.__trace[self:getKey()] = {__pos = 0, __max = (nM+2), __top = 0}
    end
  end  
  function self:addTrace(cPos)
    if(not self:isTrace()) then return self end;
    local vKey = self:getKey()
    local tVtx = metaBlock.__trace[vKey]
    if(not tVtx) then return self end
    local cVal = (cPos and cPos:getNew() or self:getPos())
    if(tVtx.__top < tVtx.__max) then -- The stack is filling
      tVtx.__top = tVtx.__top + 1
      tVtx.__pos = tVtx.__top
      tVtx[tVtx.__top] = cVal
    else -- Top is the came as max. Stack is filled
      tVtx.__pos = tVtx.__pos + 1
      if(tVtx.__pos > tVtx.__max) then tVtx.__pos = 1 end
      tVtx[tVtx.__pos]:Set(cVal)
    end; return self;
  end
  return self
end

local function concatInternal(tIn, sCh)
  local aAr, aID, aIN = {}, 1, 0
  for ID = 1, #tIn do
    local sVal = common.StringTrim(tIn[ID])
    if(sVal:find("{")) then aIN = aIN + 1 end
    if(sVal:find("}")) then aIN = aIN - 1 end
    if(not aAr[aID]) then aAr[aID] = "" end
    if(aIN == 0) then
      aAr[aID] = aAr[aID]..sVal; aID = (aID + 1)
    else
      aAr[aID] = aAr[aID]..sVal..sCh
    end
  end; return aAr
end

local function importRecursive(sRc) 
  local sIn = common.StringTrim(tostring(sRc or ""))
  logStatus("blocks.getTable: Table input <"..sIn..">")
  if(sIn:sub(1,1)..sIn:sub(-1,-1) ~= "{}") then
    return logStatus("blocks.getTable: Table format invalid <"..sIn..">", false) end
  local aIn, tOut = common.StringExplode(sIn:sub(2,-2),","), {}
  local tIn = concatInternal(aIn, ",")
  for ID = 1, #tIn do local sVal = common.StringTrim(tIn[ID])
    if(sVal ~= "") then
      local aVal = common.StringExplode(sVal,"=")
      local tVal = concatInternal(aVal, "=")      
      local kVal, vVal = tVal[1], tVal[2]
      -- Handle keys
      if(kVal == "") then return logStatus("blocks.getTable: Table key fail at <"..vVal..">", false) end
      if(kVal:sub(1,1)..kVal:sub(-1,-1) == "\"\"") then kVal = tostring(kVal):sub(2,-2)
      elseif(tonumber(kVal)) then kVal = tonumber(kVal)
      else kVal = tostring(kVal) end
      -- Handle values
      if(vVal == "") then vVal = nil
      elseif(vVal:sub(1,1)..vVal:sub(-1,-1) == "\"\"") then vVal = vVal:sub(2,-2)
      elseif(vVal:sub(1,1)..vVal:sub(-1,-1) == "{}")   then vVal = importRecursive(vVal)
      else vVal = (tonumber(vVal) or 0) end
      -- Write stuff
      logStatus("blocks.getTable: Table key <"..kVal.."> <"..tostring(vVal)..">")
      tOut[kVal] = vVal
    end
  end; return tOut
end

function blocks.getTable(sIn)
  local tOut = importRecursive(sIn)
  export.Table(tOut, "tOut", {[tOut] = "tOut"})
  return tOut
end

return blocks