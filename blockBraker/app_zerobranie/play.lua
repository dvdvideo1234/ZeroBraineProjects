require("lib/paths")

local turtle   = require("turtle")
local common   = require("common")
local complex  = require("complex")
local colormap = require("colormap")

local keys     = require("lib/keys")
local blocks   = require("lib/blocks")
local level    = require("lib/level")

io.stdout:setvbuf("no")

-- Changed during testing
local gnOut    = 5
local gnCurLev = "test"
local gnTick   = 0
local gtDebug  = {en = false, data = {lxy = "<>", rxy = "<>", key = "#"}}

-- Managed automatically !
local mainLoop = true
local mainPaus = false
local mainExit = false
local W, H     = level.getScreenSize()
local axOx     = complex.getNew(1,0)
local axOy     = complex.getNew(0,1)
local clBlu    = colr(colormap.getColorBlueRGB())
local clBlk    = colr(colormap.getColorBlackRGB())
local clGrn    = colr(colormap.getColorGreenRGB())
local clGry180 = colr(colormap.getColorPadRGB(180))
local clRed    = colr(colormap.getColorRedRGB())
local clMgn    = colr(colormap.getColorMagenRGB())
local clWht    = colr(colormap.getColorWhiteRGB())
local bSbox    = (not common.isNumber(gnCurLev))
local gbSuc    = level.readStage(gnCurLev)

common.logSkipAdd("complex.getIntersectRayCircle: Imaginary roots")

local function stopExecution(oBall, tTr, sMsg)
  mainLoop, mainPaus, mainExit = false, true, true
  level.setLog(true, true)
  level.logStatus("stopExecution: Opps! That should not happen !")
  level.logStatus("stopExecution: "..os.date())
  level.logStatus("trace", tTr)
  oBall:Dump()
  tTr.HitAct:Dump()
  level.logStatus(sMsg)
  level.setLog(false, false)
end

local function drawComplexOrigin(oC, clDrw, nS, oO, tX, bUp)
  local ss = (tonumber(nS) or 2)
  local xx, yy = oC:getParts()
  if(oO) then
    local ox, oy = oO:getParts()
    pncl(clGry180); line(xx, yy, ox, oy)
  end
  if(tX) then
    pncl(clBlk); text(tostring(tX),0,xx,yy)
  end
  pncl(clDrw or clMgn); rect(xx-ss, yy-ss, 2*ss+1, 2*ss+1)
  if(bUp) then updt() end
end

local function drawComplexLine(S,E,nS,bUp)
  local ss = (tonumber(nS) or 2)
  local sx, sy = S:getParts()
  local ex, ey = E:getParts()
  pncl(clMgn); line(sx, sy, ex, ey)
  pncl(clMgn); rect(sx-ss, sy-ss, 2*ss+1, 2*ss+1)
  pncl(clMgn); rect(ex-ss, ey-ss, 2*ss+1, 2*ss+1)
  if(bUp) then updt() end
end

local function drawComplexCircle(cC,nR,clDrw,sTx,bUp)
  local ss = (tonumber(nS) or 2)
  local cx, cy = cC:getParts()
  if(tX) then
    pncl(clBlk); text(tostring(tX),0,sx+nR,sy-nR)
  end
  pncl(clDrw or clMgn); oval(cx, cy, nR, nR, clDrw or clWht)
  if(bUp) then updt() end
end

complex.setAction("drawComplexOrigin", drawComplexOrigin)
complex.setAction("drawComplexCircle", drawComplexCircle)
complex.setAction("drawComplexLine"  , drawComplexLine)

if(not gbSuc) then
  return common.logStatus("Play: Failed reading the first level !") end

level.openWindow("Complex block breaker")

while(gbSuc and not mainExit) do
  level.setLog(false, false)
    
  local world = blocks.New():setPos(0,0):setWrap(false):setTable({Type="world"})
        world:setVert(0,0):setVert(W-1,0):setVert(W-1,H-1):setVert(0,H-1)
        world:setStat(true):setLife(1):setHard(true):setDrawColor(colormap.getColorGreenRGB())
        world:setKey(level.getKey())
  level.addActor(world) -- Make sure the key is unique enough

  local function actBoard(oBoard, key)
    local tData = oBoard:getTable()
    local brPos, brVel = oBoard:getPos(), oBoard:getVel()
    local vel, sgn, vtx = tData.Velocity, 0, 0    
    if(gtDebug and gtDebug.en) then
      local lx, ly = clck('ld')
      if(lx and ly) then gtDebug.data.lxy = "<"..tostring(lx)..", "..tostring(ly)..">" end
      local rx, ry = clck('rd')
      if(rx and ry) then gtDebug.data.rxy = "<"..tostring(rx)..", "..tostring(ry)..">" end
      if(key) then gtDebug.data.key = tostring(key) end
      local tX = gtDebug.data.lxy.." # "..gtDebug.data.rxy.." # "..gtDebug.data.key
      text(tX, 0, 0, 0)
    end
    if(keys.getCheck(key, "right"))    then sgn, vtx =  1, 2
    elseif(keys.getCheck(key, "left")) then sgn, vtx = -1, 1
    else brVel:Set(0,0); oBoard:setVel(brVel) return end; brVel:Set(vel*sgn,0)
    local wW, dD, bB = world:getVert(vtx), brVel:getNew(0,1), oBoard:getVertVec(brVel)
    local rR = (bB:getDot(brVel:getUnit())* brVel:getUnit()):Add(brPos)
    local xX = complex.getIntersectRayRay(brPos, brVel, wW, dD)
    if(xX) then local rN = rR:Sub(xX):getNorm()
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
    if(not oBall:isHard()) then
      
    end
    -- Draw collision check
  end

  local function drawHitSurface(tTr, oBall)
    local bSurf = level.traceReflect("surf")
    local bEdge = level.traceReflect("edge")
    local bBall = level.traceReflect("ball")
    if(bBall and oBall) then
      tMe, tTh = oBall:getTable(), tTr.HitAct:getTable()
      tTr.VtxStr:Action("drawComplexCircle", tMe.Size + tTh.Size)
    else
      if(tTr.VtxStr == tTr.VtxEnd) then -- The center of an edge is stored
        tTr.VtxStr:Action("drawComplexCircle", tTr.VtxStr:getSub(tTr.HitPos):getNorm())
      else
        tTr.VtxStr:Action("drawComplexLine", tTr.VtxEnd)        
      end
      tTr.HitPos:Action("drawComplexOrigin", nil, 2)
    end
  end

  local function actBall(oBall)
    local baPos = oBall:getPos()
    local baVel = oBall:getVel()
    local tData = oBall:getTable()
    local tfSlf = {[oBall:getKey()] = true}
    local tfAll = {[tData.Type] = tfSlf}
    local tTr   = level.traceRay(baPos, baVel, tData.Size, tfAll)
    local bHit  = level.gonnaHit(baPos, baVel)
    
    drawHitSurface(tTr, oBall)

    level.logStatus("hit_beg", bHit)
    
    level.logStatus("actBall(state)", baPos, baVel)
      
    local bx, by = baPos:getParts()
    if(not common.isAmong(bx,-gnOut,W+gnOut)) then
      stopExecution(oBall, tTr, "Ball ["..oBall:getKey().."] action cannot continue "..
        "because X posision "..baPos.." is out of bounds {"..W..","..H.."}") end
    if(not common.isAmong(by,-gnOut,H+gnOut)) then
      stopExecution(oBall, tTr, "Ball ["..oBall:getKey().."] action cannot continue "..
        "because Y posision "..baPos.." is out of bounds {"..W..","..H.."}") end
   
    if(bHit) then -- Is there a hit to tavke cate in the frame
      local nvPrt, niCnt = baVel:getNorm(), 1
      local cfPos, cfVel = baPos:getNew(), baVel:getNew()
      local cpInt, cvRef = baPos:getNew(), baVel:getNew()
      
      while(bHit and (tTr.HitDst < nvPrt)) do
        level.logStatus("hit_loop", niCnt, bHit)
        
        drawHitSurface(tTr, oBall)        
        
        level.logStatus("dif1", niCnt,tTr.HitDst, nvPrt)
        
        nvPrt = (nvPrt - tTr.HitDst)
        
        tTr.HitAct:Damage(tData.Damage)
        if(tTr.HitAct:isDead()) then level.delActor(tTr.HitAct) end
        
        oBall:Damage(tData.Damage)
        if(oBall:isDead()) then level.delActor(oBall) end
        
        level.logStatus("dif2", niCnt,tTr.HitDst, tTr.HitAim:getNorm(), nvPrt)
        
        local cN, cR
        local bSurf = level.traceReflect("surf")
        local bEdge = level.traceReflect("edge")
        local bBall = level.traceReflect("ball")
        
        level.logStatus("flg", bSurf, bEdge, bBall)
        
        if(bSurf) then
          cR, cN = complex.getReflectRayLine(cpInt:getSub(cvRef), cvRef, tTr.VtxStr, tTr.VtxEnd)
        elseif(bEdge) then
          cR, cN = complex.getReflectRayCircle(cpInt:getSub(cvRef), cvRef, tTr.VtxStr, tData.Size, tTr.HitPos)
        elseif(bBall) then
          local nRad = tTr.HitAct:getTable().Size + tData.Size
          cR, cN = complex.getReflectRayCircle(cpInt:getSub(cvRef), cvRef, tTr.VtxStr, nRad, tTr.HitPos)
        end
        
        level.logStatus("ref", niCnt,cN, cR, nvPrt)
        
        if(cN:isNanReal() or cN:isNanImag()) then
          stopExecution(oBall, tTr, "Cannot reflect velocity at iteration #"..niCnt)
        end
        
        cpInt:Set(tTr.HitPos); cvRef:Set(cR):Mul(nvPrt) -- The rest of the vector to trace
        
        level.logStatus("trs",niCnt, tTr.HitPos, cpInt, cvRef)
        
        -- Adjust the next frame position according to the trace
        cfPos:Set(cpInt):Add(cvRef); cfVel:Set(cvRef):Unit():Mul(baVel:getNorm())
        
        level.logStatus("nve",niCnt, cfPos, cfVel)
        
        -- Draw the ball trajectory if enabled
        oBall:addTrace(cpInt)
        
        level.logStatus("loop_end",niCnt)
        
        tTr  = level.traceRay(cpInt, cvRef, tData.Size, tfAll)
        bHit = level.gonnaHit(cpInt, cvRef)
        
        level.logStatus("new_trace",niCnt, bHit, tTr.HitPos, cpInt, cvRef)
        level.logStatus("loop_end",niCnt)
        
        niCnt = niCnt + 1
      end -- Hold the current frame while calculating the position ( The ball is still in the crrent frame )
      
      oBall:setFrame(true):addTrace(cfPos):setPos(cfPos):setVel(cfVel)
    else
      -- Update the OOP accordingly and move in 2D space if nothing is hit
      oBall:setVel(baVel)
    end
  end
    
  -- Apply action and drawing behaviors
  local gtBehave = {
    ["board"] = {__act = actBoard, __drw = nil     , __cnt = 0, __all = 0},
    ["brick"] = {__act = nil     , __drw = nil     , __cnt = 0, __all = 0},
    ["ball" ] = {__act = actBall , __drw = drawBall, __cnt = 0, __all = 0},
    ["world"] = {__act = nil     , __drw = nil     , __cnt = 0, __all = 0}
  }

  level.hookAction(gtBehave)
    
  if(gtBehave["board"].__cnt == 0) then
    return common.logStatus("Play: Player missing in the level data #"..tostring(gnCutLev)) end
    
  if(gtBehave["ball"].__cnt == 0) then
    return common.logStatus("Play: Balls missing in the level data #"..tostring(gnCutLev)) end
  
  if(gtBehave["brick"].__cnt == 0) then
    return common.logStatus("Play: Bricks missing in the level data #"..tostring(gnCutLev)) end
  
  common.logStatus("Play: Current level summary:")
  common.logStatus("  Worlds: "..gtBehave["world"].__cnt)
  common.logStatus("  Boards: "..gtBehave["board"].__cnt)
  common.logStatus("  Balls : "..gtBehave["ball" ].__cnt)
  common.logStatus("  Bricks: "..gtBehave["brick"].__cnt)
   
  -- Actor working priorities
  local nPri = #(level.getPriorityKeys())
   
  while(mainLoop and not mainExit) do
    local key = keys.getKey()
    local imp = keys.getImpulse(key, "P")
    if(imp > 0) then mainPaus = (not mainPaus) end
    if(not mainPaus) then wipe()
      for ID = 1, nPri do level.procStack(ID, "Act", key) end
      for ID = 1, nPri do level.procStack(ID, "Draw") end
      for ID = 1, nPri do level.procStack(ID, "Move") end; updt()
      if(not bSbox) then 
        if(not level.hasActors("ball")) then
          gnCurLev, mainLoop = 1, false
          common.logStatus("Play: GAME OVER !")
        elseif(not level.hasActors("brick")) then
          common.logStatus("Play: Congratulations passing level "..gnCurLev.." !")
          gnCurLev, mainLoop = (gnCurLev + 1), false
        end
      end
      if(keys.getCheck(key, "escape")) then
        gnCurLev, mainLoop = nil, false end
    end; wait(gnTick)
  end; mainLoop = true
  
  if(not mainExit) then
    if(not bSbox) then
      level.clearAll()
      common.logStatus("Loading level... "..gnCurLev)
      gbSuc = level.readStage(gnCurLev)
      if(not gbSuc) then
        common.logStatus("Play: Failed loading level #"..tostring(gnCurLev)) end
    else
      gbSuc = level.readStage(gnCurLev)
      common.logStatus("Play: The game is in sandbox mode !")
    end
  end
end

if(not mainExit) then common.logStatus("Play: Congratulations for beating the game !") end

