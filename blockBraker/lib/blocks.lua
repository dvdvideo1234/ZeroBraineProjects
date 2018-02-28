local setmetatable = setmetatable
local complex      = require("complex")
local turtle       = require("turtle")
local colormap     = require("colormap")
local common       = require("common")
local toBool       = common.toBool
local logStatus    = common.logStatus

local blocks       = {}
local metaBlock    = {}

metaBlock.__type  = "blocks.block"
metaBlock.__index = metaBlock
function blocks.New()
  local self = {}; setmetatable(self, metaBlock)
  local mbPfr, mbTrc, mtTrc = false, false, {}
  local mcAxx, mcAxy, mnAng, maKey = complex.getNew(), complex.getNew(), 0
  local mcPos, mcVel, mtVtx = complex.getNew(), complex.getNew(), {__size = 0}
  local mbSta, mbHrd, mbWrp, miLif, mclDr, mfAct, mfDrw, mtDat = true, true, true, 0
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
    mtVtx[mtVtx.__size] = complex.getNew(x,y); return self
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
  function self:drawLife()
    if(not self:isHard()) then
      local px, py = mcPos:getSub(mcSiz):Floor():getParts()
      pncl(mclDr); text(("%4.1f"):format(self:getLife()),0, px, py)
    end; return self
  end
  function self:drawVel()
    local px, py = mcPos:getParts()
    local vx, vy = mcVel:getParts()
    pncl(mclDr); line(px, py, px+vx, py+vy); return self
  end
  function self:drawTrace()
    if(self:isTrace()) then
      if(mtTrc and mtTrc.__top > 0) then local N, O
        if(mtTrc.__top == mtTrc.__max) then
          N, E = mtTrc.__pos, mtTrc.__pos
          E = E + 1; if(E > mtTrc.__max) then E = 1 end
          E = E + 1; if(E > mtTrc.__max) then E = 1 end
        else N, E = mtTrc.__pos, 1 end
        while(N ~= E) do
          local xp, yp = mtTrc[N]:getParts()
          N = N - 1; if(N < 1) then N = mtTrc.__max end
          local xm, ym = mtTrc[N]:getParts()
          pncl(mclDr); line(xp, yp, xm, ym)
          pncl(mclDr); rect(xp-2, yp-2, 5, 5)
        end
      end
    end; return self
  end
  function self:drawPoly()
    local ID, N = 1, self:getVertN()
    local CT, VI = mcPos:getNew(), self:getVert(1)
    while(ID <= N) do local xs, ys, xs, ys
      xs, ys = CT:Set(mcPos):Add(self:getVert(ID) or VI):getParts(); ID = ID + 1
      xe, ye = CT:Set(mcPos):Add(self:getVert(ID) or VI):getParts()
      pncl(mclDr); line(xs, ys, xe, ye)
    end; return self
  end
  function self:Draw(bVel) -- tect(x,y,w,h)
    if(self:isDead()) then return self end
    self:drawTrace()
    self:drawLife()
    if(bVel) then self:drawVel() end
    if(mfDrw) then mfDrw(self); return self end
    self:drawPoly()
    return self
  end
  function self:Act()
    if(self:isStat()) then return self end
    if(mfAct) then mfAct(self) end
    return self
  end
  function self:Move()
    if(self:isStat()) then return self end
    if(self:isFrame()) then self:setFrame(false) else mcPos:Add(mcVel) end
    if(self:isTrace()) then self:addTrace() end; return self
  end
  function self:Damage(iDmg)
    if(self:isHard()) then return self end
    local dmg = (tonumber(iDmg) or 0)
    if(self:isDead() or dmg == 0) then return self end
    miLif = (miLif - dmg); return self
  end
  function self:Dump()
    logStatus("\n["..metaBlock.__type.."]["..tostring(self:getKey()).."]")
    logStatus("  Position: "..tostring(mcPos))
    logStatus("  Velocity: "..tostring(mcVel))
    logStatus("  Hard    : "..tostring(mbHrd))
    logStatus("  Static  : "..tostring(mbSta))
    logStatus("  Life    : "..tostring(miLif))
    logStatus("  Color   : "..tostring(mclDr))
    logStatus("  Table   : "); for k, v in pairs(self:getTable()) do logStatus("    ["..k.."]: "..tostring(v)) end
    logStatus("  Vertexes: "); for ID = 1, self:getVertN() do logStatus("    ["..ID.."]: "..self:getVert(ID)) end
    return self
  end
  function self:setTrace(nMax)
    local nM = math.floor(math.abs(tonumber(nMax) or 0))
    if(nM > 0) then mbTrc = toBool(nM)
      mtTrc = {__pos = 0, __max = (nM+2), __top = 0}
    end
  end
  function self:addTrace(cPos)
    if(not self:isTrace()) then return self end;
    if(not mtTrc) then return self end
    local cVal = (cPos and cPos:getNew() or self:getPos())
    if(mtTrc.__top < mtTrc.__max) then -- The stack is filling
      mtTrc.__top = mtTrc.__top + 1
      mtTrc.__pos = mtTrc.__top
      mtTrc[mtTrc.__top] = cVal
    else -- Top is the came as max. Stack is filled
      mtTrc.__pos = mtTrc.__pos + 1
      if(mtTrc.__pos > mtTrc.__max) then mtTrc.__pos = 1 end
      mtTrc[mtTrc.__pos]:Set(cVal)
    end; return self;
  end
  return self
end

return blocks