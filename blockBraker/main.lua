local colormap = require("colormap")
local complex  = require("complex")
local keys     = require("blockBraker/keys")
local blocks   = require("blockBraker/blocks")
local level    = require("blockBraker/level")
local common   = require("common")

io.stdout:setvbuf("no")

local gnTick  = 0.03 
local gtDebug = {en = false, data = {lxy = "<>", rxy = "<>", key = "#"}}

local gbSuc = level.Read("bumpy")

if(gbSuc) then
  local W, H = level.getScreenSize()
  
  open("Complex block braker")
  size(W, H)
  zero(0, 0)
  updt(false) 

  local axOx  = complex.getNew(1,0)
  local axOy  = complex.getNew(0,1)
  local clBlu = colr(colormap.getColorBlueRGB())
  local clBlk = colr(colormap.getColorBlackRGB())
  local clGrn = colr(colormap.getColorGreenRGB())
  local clGry180 = colr(colormap.getColorPadRGB(180))
  local clRed = colr(colormap.getColorRedRGB())
  local vlMgn = colr(colormap.getColorMagenRGB())
  
  local world = blocks.New():setPos(0,0):setWrap(false)
        world:setVert(0,0):setVert(W-1,0):setVert(W-1,H-1):setVert(0,H-1)
        world:setStat(true):setLife(1):setHard(true):setDrawColor(colormap.getColorGreenRGB())
  local wkey = common.randomGetString(50)
  level.addActor(wkey, world) -- Make sure the key is unique enough

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

  complex.setAction("drawComplexOrigin", drawComplexOrigin)
  complex.setAction("drawComplexLine", drawComplexLine)

  local function actBoard(oBoard)
    local tData = oBoard:getTable()
    local brPos, brVel = oBoard:getPos(), oBoard:getVel()
    local key, vel, sgn, vtx = keys.getKey(), tData.Vel, 0, 0
    if(gtDebug and gtDebug.en) then
      local lx, ly = clck('ld')
      if(lx and ly) then gtDebug.data.lxy = "<"..tostring(lx)..", "..tostring(ly)..">" end
      local rx, ry = clck('rd')
      if(rx and ry) then gtDebug.data.rxy = "<"..tostring(rx)..", "..tostring(ry)..">" end
      if(key) then gtDebug.data.key = tostring(key) end
      local tX = gtDebug.data.lxy.." # "..gtDebug.data.rxy.." # "..gtDebug.data.key
      text(tX, 0, 0, 0)
    end
    if(keys.getPress(key, "right"))    then sgn, vtx =  1, 2
    elseif(keys.getPress(key, "left")) then sgn, vtx = -1, 1
    else brVel:Set(0,0); oBoard:setVel(brVel) return end; brVel:Set(vel*sgn,0)
    local vtb, max, uvel = 0, 0, brVel:getUnit()
    for ID = 1, oBoard:getVertN() do
      local vtt = oBoard:getVert(ID)
      local dot = vtt:getDot(uvel)
      if(dot > max) then vtb, max = ID, dot end
    end
    local wW, dD, bB = world:getVert(vtx), brVel:getNew(0,1), oBoard:getVert(vtb)
    local rR = (bB:getDot(brVel:getUnit())* brVel:getUnit()):Add(brPos)
    local suc, nT, nU, xX = complex.getIntersectRayRay(brPos, brVel, wW, dD)
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
    local baPos = oBall:getPos()
    local baVel = oBall:getVel()
    local tData = oBall:getTable()
    local tKey  = {[oBall:getKey()] = true}
    local tTr = level.smpActor(baPos, baVel, tKey)
    local tBr = level.getBorder(baPos, baVel, tData.Size)
    if(tBr.Hit) then -- Is there a hit to tavke cate in the frame
      local nvPrt, nmBnc = baVel:getNorm(), 0
      local cfPos, cfVel = baPos:getNew(), baVel:getNew()
      local cpInt, cvRef = baPos:getNew(), baVel:getNew()
      while(tBr.Hit) do nmBnc = nmBnc + 1
        tBr.VtxStr:Act("drawComplexLine", tBr.VtxEnd)
        tTr.HitAct:Damage(tData.Dmg)
        if(tTr.HitAct:isDead()) then level.delActor(tTr.HitKey) end
        if(tBr.HitDst < nvPrt) then nvPrt = nvPrt - tBr.HitDst
          local cN, cR = complex.getReflectRayLine(cpInt, cvRef, tBr.VtxStr, tBr.VtxEnd)
          cpInt:Set(tBr.HitPos); cvRef:Set(cR):Mul(nvPrt) -- The rest of the vector to trace
          -- Adjust the next frame position according to the trace
          cfPos:Set(cpInt):Add(cvRef); cfVel:Set(cvRef):Unit():Mul(baVel:getNorm())
          -- Draw the ball trajectory if enabled
          oBall:addTrace(cpInt):addTrace(cfPos)
        end
        tTr = level.smpActor(cpInt, cvRef, tKey)
        tBr = level.getBorder(cpInt, cvRef, tData.Size, nmBnc)
      end -- Hold the current frame while calculating the position ( The ball is still in the crrent frame )
      oBall:setPos(cfPos):setFrame(true):setVel(cfVel)
    else
      -- Update the OOP accordingly and move in 2D space if nothing is hit
      oBall:setVel(baVel)
    end
  end
  
  -- Retrice the current actor stack
  local gtActors = level.getActors()
  
  -- Apply actions and drawings
  local gtBehave = {
    ["board"] = {__act = actBoard, __drw = nil     , __cnt = 0, __all = 0},
    ["ball" ] = {__act = actBall , __drw = drawBall, __cnt = 0, __all = 0},
    ["brick"] = {__act = nil     , __drw = nil     , __cnt = 0, __all = 0}
  }
  
  for k, v in pairs(gtActors) do
    local tDat = v:getTable()
    if(tDat and tDat.Type) then
      local setUp = gtBehave[tDat.Type]
      if(setUp) then
        setUp.__all = setUp.__all + 1
        if(tDat.Type == "board" and setUp.__cnt >= 1) then
          common.logStatus("main.lua: Only one player is allowed. You have <"..setUp.__all..">")
        else
          v:setAction(setUp.__act)
          v:setDraw  (setUp.__drw)
          setUp.__cnt = setUp.__cnt + 1
        end
      end
    end
  end
  
  common.logStatus("main.lua: Here is the level summary:")
  common.logStatus("  Boards: "..gtBehave["board"].__cnt)
  common.logStatus("  Balls : "..gtBehave["ball" ].__cnt)
  common.logStatus("  Blocks: "..gtBehave["brick"].__cnt)
  
  while true do wipe()
    for k, v in pairs(gtActors) do v:Act():Draw() end
    for k, v in pairs(gtActors) do v:Move() end
    updt(); wait(gnTick)
  end

else
  common.logStatus("main.lua: Failed reading the first level !")
end