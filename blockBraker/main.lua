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
local gbSuc = level.Read("1")
if(gbSuc) then

  local gtActors = level.getActors()

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

  local fild = blocks.New():setPos(0,0):setWrap(false)
        fild:setVert(0,0):setVert(W-1,0)
        fild:setVert(W-1,H-1):setVert(0,H-1)
        fild:setStat(true):setLife(1):setHard(true):setDrawColor(colormap.getColorGreenRGB())
        
  local bord = blocks.New():setVert(-50,-7):setVert(50,-7):setVert(50,7):setVert(-50,7)
        bord:setStat(false):setLife(1):setHard(true)
        bord:setPos(W/2, H-math.abs(bord:getVert(1):getImag())-4)
        bord:setDrawColor(colormap.getColorRedRGB()):setTable({Vel = 10, Type = "board", Ang = 45})
              
  local ball = blocks.New()
        ball:setStat(false)
        ball:setLife(1):setHard(true)
        ball:setPos(10,10)
        ball:setVel(-1,10):setDrawColor(colormap.getColorGreenRGB())
        ball:setTable({Type = "ball", Size = 5, Dmg = 0.5})

  local function actBoard(oBoard)
    local lx, ly = clck('ld')
    if(lx and ly) then print(lx..","..ly) end
    
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
    local tFilt = {[oBall:getKey()]=true}
    local tTr   = level.smpActor(baPos, baVel, tFilt)
    print("1z", baPos, baVel)
    if(tTr.Hit) then
      local nrVel = baVel:getNorm()
      local nrPrt = baVel:getNorm()
      local cfPos = baPos:getNew()
      local cfVel = baVel:getNew()
      local cpInt = baPos:getNew()
      local cvRef = baVel:getNew()
      while(tTr.Hit) do
        tTr.HitAct:Damage(tData.Dmg)
        if(tTr.HitAct:isDead()) then level.delActor(tTr.HitKey) end
        local bO = (tData.Size * tTr.HitNrm)
        local vS = tTr.VtxStr:getNew():Add(bO)
        local vE = tTr.VtxEnd:getNew():Add(bO)
       -- vS:Draw("drawComplexLine",vE)
        print(vS, vE)
        local bSuc, nT, nU, xX = complex.Intersect(cpInt, cvRef, vS, vE - vS)
        if(bSuc) then local rV = xX:getSub(cpInt):getNorm()
          xX:Draw("drawComplexOrigin")
          print("1a", xX, cpInt, cvRef, rV, nrPrt)
          if(rV < nrPrt) then nrPrt = nrPrt - rV
            print("1b", xX, cpInt, cvRef, rV, nrPrt)
            local cN, cR = complex.Reflect(cpInt, cvRef, vS, vE)
            cpInt:Set(xX); cvRef:Set(cR):Mul(nrPrt) -- The rest of the vector to trace
            -- Adjust the next frame position according to the trace
            cfPos:Set(cpInt):Add(cvRef); cfVel:Set(cvRef):Unit():Mul(nrVel)
            -- Draw the ball trajectory if enabled
            oBall:addTrace(cpInt):addTrace(cfPos)
          end
        end
        tTr = level.smpActor(cpInt, cvRef, tFilt)
      end
      oBall:setPosFrm(cfPos):setVel(cfVel)
    else
      -- Update the OOP accordingly and move in 2D space if nothing is hit
      oBall:setVel(baVel)
    end
  end

  bord:setAction(actBoard)
  ball:setAction(actBall)
  ball:setDraw(drawBall)

  level.addActor("bord", bord)
  level.addActor("fild", fild)
  level.addActor("ball", ball)

  ball:setTrace(30)

  while true do wipe()
    for k, v in pairs(gtActors) do v:Act():Draw() end
    for k, v in pairs(gtActors) do v:Move() end
    updt();
    wait(0.5)
  end
 
end