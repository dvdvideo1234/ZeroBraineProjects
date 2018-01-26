local colormap = require("colormap")
local complex  = require("complex")
local keys     = require("blockBraker/keys")
local blocks   = require("blockBraker/blocks")
local level    = require("blockBraker/level")
local test     = require("blockBraker/test")
local common   = require("blockBraker/common")

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
local clRed = colr(colormap.getColorRedRGB())
local suc = level.Read(1)
local act = level.getActors()

local function drawComplexOrigin(oC, nS, oO, bL)
  local ss = (tonumber(nS) or 2)
  local xx, yy = oC:getParts()
  if(bL and oO) then
    local ox, ox = oO:getParts()
    pncl(clBlk); line(ox, ox, xx, yy)
  end
  rect(xx-ss, yy-ss, 2*ss+1, 2*ss+1)
end

complex.SetDraw("drawComplexOrigin", drawComplexOrigin)

local fild = blocks.New():setVert(0,0):setVert(W-1,0):setVert(W-1,H-1):setVert(0,H-1):setPos(0,0)
      fild:setStat(true):setLife(1):setHard(true):setDrawColor(clGrn)
      
local bord = blocks.New():setVert(-50,-7):setVert(50,-7):setVert(50,7):setVert(-50,7)
      bord:setStat(false):setLife(1):setHard(true); print(bord:getVert(1))
      bord:setPos(W/2, H-math.abs(bord:getVert(1):getImag())-4)
      bord:setDrawColor(colormap.getColorRedRGB()):setTable({10, Type = "board"})
            
local ball = blocks.New():setVert(5,5):setVert(5,-5):setVert(-5,-5):setVert(-5,5)
      ball:setStat(false)
      ball:setLife(1):setHard(true)
      ball:setPos(bord:getPos() + complex.New(14,-20))
      ball:setVel(-2,-2):setDrawColor(colormap.getColorGreenRGB())
      ball:setDraw(drawBall):setTable({7, 7, 1, Type = "ball", Sens = {true, ["X"] = complex.New(), ["Y"] = complex.New(), ["V"] = complex.New()}})

local function actBall(oBall)
  local baVel = oBall:getVel()
  local baPos = oBall:getPos()
  local tData = oBall:getTable()
  local sx, ex, sy, ey = oBall:getBords()
  if(sx <= 0 or ex >= W) then baVel:NegRe() end
  if(sy <= 0 or ey >= H) then baVel:NegIm() end
  -- Update ball sensors
  local tSens = tData.Sens
  tSens.X:Set(axOx):Mul(common.getSign(baVel:getDot(axOx)) * tData[1])
  tSens.Y:Set(axOy):Mul(common.getSign(baVel:getDot(axOy)) * tData[1])
  tSens.V:Set(baVel):Unit():Mul(tData[2])
  -- Check collisions
  for k, v in pairs(act) do
    if(v and v ~= oBall) then
      if(v:isInside(tSens.X + baPos)) then
        baVel:NegRe(); v:Damage(tData[3])
        if(v:isDead()) then level.delActor(k) end
      end
      if(v and v:isInside(tSens.Y + baPos)) then
        baVel:NegIm(); v:Damage(tData[3])
        if(v:isDead()) then level.delActor(k) end
      end
      if(v and v:isInside(tSens.V + baPos)) then
        baVel:Neg(); v:Damage(tData[3])
        if(v:isDead()) then level.delActor(k) end
      end
      local vTab = v:getTable()
      if(vTab and vTab.Type == "board") then
        
      end
    end
  end
  -- Update the OOP accordingly and move in 2D space
  oBall:setVel(baVel)
end

local function actBoard(oBoard)
  local tData = oBoard:getTable()
  local brVel = oBoard:getVel()
  local brPos = oBoard:getPos()  
  local key, vel, sgn, vtx = char(), tData[1], 0, 0
  if(keys.Check(key, "right"))    then sgn, vtx =  1, 2
  elseif(keys.Check(key, "left")) then sgn, vtx = -1, 1
  else brVel:Set(0,0); oBoard:setVel(brVel) return end; brVel:Set(vel*sgn,0)
  local wW, dD, bB = fild:getVert(vtx), brVel:getNew(0,1), bord:getVert(vtx)
  local rR = (bB:getDot(brVel:getUnit())* brVel:getUnit()):Add(brPos)
  local suc, nT, nU, xX = complex.Intersect(brPos, brVel, wW, dD)
  if(suc) then
    rR:Draw("drawComplexOrigin", 4)
    xX:Draw("drawComplexOrigin", 4) 
    local rN = rR:Sub(xX):getNorm()
    if(rN <= vel) then brVel:Set(rN*sgn,0) end
  end

  oBoard:setVel(brVel)
end

local function drawBall(oBall)
  if(oBall:isDead()) then return end
  -- Main stuff
  local bP = oBall:getPos()
  local px, py = bP:getParts()
  local sx, sy = oBall:getSize():Floor():getParts()
  pncl(clBlk); oval(px, py, sx, sy, oBall:getDrawColor())
  -- Velocity
  local cVel = oBall:getVel()
  local vx, vy = cVel:getFloor():getParts()
  pncl(clBlk); line(px, py, px+vx, py+vy)
  -- Draw collision check
  local tData  = oBall:getTable()
  if(tData.Sens and tData.Sens[1]) then
    local dxx, dxy = tData.Sens.X:getParts(); pncl(clBlk); line(px, py, px+dxx, py+dxy)
    local dyx, dyy = tData.Sens.Y:getParts(); pncl(clBlk); line(px, py, px+dyx, py+dyy)
    local dvx, dvy = tData.Sens.V:getParts(); pncl(clBlk); line(px, py, px+dvx, py+dvy)
  end
end

bord:setAction(actBoard)
ball:setAction(actBall)

level.addActor("bord", bord)
level.addActor("fild", fild)
--level.addActor("ball", ball1)

while true do wipe()
  for k, v in pairs(act) do v:Act():Draw(true) end
  for k, v in pairs(act) do v:Move() end
  updt(); wait(0.01)
end
 
