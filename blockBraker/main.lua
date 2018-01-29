local colormap = require("colormap")
local complex  = require("complex")
local keys     = require("blockBraker/keys")
local blocks   = require("blockBraker/blocks")
local level    = require("blockBraker/level")
local common   = require("common")

io.stdout:setvbuf("no")

local W, H = 800, 400

open("Complex block braker")
size(W,H)
zero(0, 0)
updt(false) 

local axOx  = complex.New(1,0)
local axOy  = complex.New(0,1)
local clBlu = colr(colormap.getColorBlueRGB())
local clBlk = colr(colormap.getColorBlackRGB())
local clGrn = colr(colormap.getColorGreenRGB())
local clGry180 = colr(colormap.getColorPadRGB(180))
local clRed = colr(colormap.getColorRedRGB())
local vlMgn = colr(colormap.getColorMagenRGB())
local suc = level.Read(1)
local act = level.getActors()

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

local function drawComplexLine(S,E,nS)
  local ss = (tonumber(nS) or 2)
  local sx, sy = S:getParts()
  local ex, ey = E:getParts()
  pncl(vlMgn); line(sx, sy, ex, ey)
  pncl(vlMgn); rect(sx-ss, sy-ss, 2*ss+1, 2*ss+1)
  pncl(vlMgn); rect(ex-ss, ey-ss, 2*ss+1, 2*ss+1)
end

complex.Draw("drawComplexOrigin", drawComplexOrigin)
complex.Draw("drawComplexLine", drawComplexLine)

local fild = blocks.New():setPos(10,10):setWrap(false)
      fild:setVert(-10,-10):setVert(W-11,-10)
      fild:setVert(W-11,H-11):setVert(-10,H-11)
      fild:setStat(true):setLife(1):setHard(true):setDrawColor(colormap.getColorGreenRGB())
      
local bord = blocks.New():setVert(-50,-7):setVert(50,-7):setVert(50,7):setVert(-50,7)
      bord:setStat(false):setLife(1):setHard(true)
      bord:setPos(W/2, H-math.abs(bord:getVert(1):getImag())-4)
      bord:setDrawColor(colormap.getColorRedRGB()):setTable({Vel = 10, Type = "board"})
            
local ball = blocks.New()
      ball:setStat(false)
      ball:setLife(1):setHard(true)
      ball:setPos(bord:getPos() + complex.New(14,-20))
      ball:setVel(0,-2):setDrawColor(colormap.getColorGreenRGB())
      ball:setTable({Type = "ball", Size = 5})

local function actBoard(oBoard)
  local tData = oBoard:getTable()
  local brVel = oBoard:getVel()
  local brPos = oBoard:getPos()  
  local key, vel, sgn, vtx = char(), tData.Vel, 0, 0
  if(keys.Check(key, "right"))    then sgn, vtx =  1, 2
  elseif(keys.Check(key, "left")) then sgn, vtx = -1, 1
  else brVel:Set(0,0); oBoard:setVel(brVel) return end; brVel:Set(vel*sgn,0)
  local wW, dD, bB = fild:getVert(vtx), brVel:getNew(0,1), bord:getVert(vtx)
  local rR = (bB:getDot(brVel:getUnit())* brVel:getUnit()):Add(brPos)
  local suc, nT, nU, xX = complex.Intersect(brPos, brVel, wW, dD)
  if(suc) then local rN = rR:Sub(xX):getNorm()
    if(rN <= vel) then brVel:Set(rN*sgn,0) end
  end
  oBoard:setVel(brVel)
end

local function drawBall(oBall)
  if(oBall:isDead()) then return oBall end
  local tData  = oBall:getTable()
  local bP     = oBall:getPos()
  local px, py = bP:getParts()
  pncl(clBlk); oval(px, py, tData.Size, tData.Size, oBall:getDrawColor())
  -- Velocity
  local cVel = oBall:getVel()
  local vx, vy = cVel:getFloor():getParts()
  pncl(clBlk); line(px, py, px+vx, py+vy)
  -- Draw collision check
end

local function actBall(oBall)
  local baVel = oBall:getVel()
  local baPos = oBall:getPos()
  local tData = oBall:getTable()
 
  -- Trace hit/first/min/vector
  local tTr = {}
        tTr.HitPos = baPos:getNew()
        tTr.HitAim = baPos:getNew()
        tTr.HitNrm = baPos:getNew()
        tTr.Hit    = false
        tTr.VtxStr = baPos:getNew()
        tTr.VtxEnd = baPos:getNew()
        tTr.HitAct = {}
        tTr.MinLen = 0
        
  -- Check collisions
  for k, v in pairs(act) do
    if(v and  v~= oBall) then local nVtx = v:getVertN()
      if(nVtx > 0) then -- Polygon
        local cS, cE = baPos:getNew(), baPos:getNew()
        local ID, vI, vP = 1, v:getVert(1), v:getPos()
        while(ID <= nVtx) do
          cS:Set(vP):Add(v:getVert(ID) or vI); ID = ID + 1 
          cE:Set(vP):Add(v:getVert(ID) or vI)
          local suc, nT, nU, xX = complex.Intersect(baPos, baVel, cS, cE-cS)
          if(suc) then
            if(complex.OnSegment(xX, cS, cE, 1e-10)) then
              local cV = (xX - baPos)
              local nD = cV:getDot(baVel)
              if(nD > 0) then -- Chech only these in front of us
                if(not tTr.Hit) then tTr.MinLen, tTr.Hit = nD, true
                  tTr.HitPos:Set(xX); tTr.HitAim:Set(cV); tTr.HitEnt = {k,v}
                  tTr.VtxStr:Set(cS); tTr.VtxEnd:Set(cE)
                  tTr.HitNrm:Set(complex.Project(baPos, cS, cE)):Neg():Add(baPos):Unit()
                else -- For all the others we must compare minimum to
                  if(nD < tTr.MinLen) then tTr.HitEnt = {k,v}
                    tTr.MinLen = nD; tTr.HitPos:Set(xX); tTr.HitAim:Set(cV);
                    tTr.VtxStr:Set(cS); tTr.VtxEnd:Set(cE)
                    tTr.HitNrm:Set(complex.Project(baPos, cS, cE)):Neg():Add(baPos):Unit()
                  end
                end
              end
            end
          end
        end
      else -- Another ball
        
      end
    end
  end
  
  if(tTr.Hit) then tTr.HitPos:Draw("drawComplexOrigin")
    local bO = (tData.Size * tTr.HitNrm)
    
 --   bO:Draw("drawComplexOrigin", tTr.HitPos)
    
    local vS = tTr.VtxStr:getNew():Add(bO)
    local vE = tTr.VtxEnd:getNew():Add(bO)
    vS:Draw("drawComplexLine",vE)
  end
  
  -- Update the OOP accordingly and move in 2D space
  oBall:setVel(baVel)
end

bord:setAction(actBoard)
ball:setAction(actBall)
ball:setDraw(drawBall)

level.addActor("bord", bord)
level.addActor("fild", fild)
level.addActor("ball", ball)

while true do wipe()
  for k, v in pairs(act) do v:Act():Draw(true) end
  for k, v in pairs(act) do v:Move() end
  updt();
  wait(0.02)
end
 
