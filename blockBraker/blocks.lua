local setmetatable = setmetatable
local complex      = require("complex")
local turtle       = require("turtle")
local colormap     = require("colormap")
local common       = require("common")
local blocks       = {}
local metaBlock    = {}
local toBool       = common.ToBool

local function logStatus(anyMsg, ...)
  io.write(tostring(anyMsg).."\n"); return ...
end

metaBlock.__type  = "blocks.block"
metaBlock.__index = metaBlock
function blocks.New()
  local self = {}; setmetatable(self, metaBlock)
  local mcAxx, mcAxy, mnAng = complex.New(), complex.New(), 0
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
  function self:isStat() return mbSta end
  function self:isWrap() return mbWrp end
  function self:getTable() return mtDat end
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
      pncl(mclDr); text(tostring(self:getLife()),0, px, py)
    end
    return self
  end
  function self:Act()
    if(self:isStat()) then return self end
    if(mfAct) then mfAct(self); return self end
  end
  function self:Move()
    if(self:isStat()) then return self end
    mcPos:Add(mcVel); return self
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
  return self
end

return blocks