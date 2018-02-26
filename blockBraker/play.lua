local colormap = require("colormap")
local complex  = require("complex")
local common   = require("common")
local keys     = require("blockBraker/lib/keys")
local blocks   = require("blockBraker/lib/blocks")
local level    = require("blockBraker/lib/level")

io.stdout:setvbuf("no")

local gnOut    = 5
local gnTick   = 0.01
local gtDebug  = {en = false, data = {lxy = "<>", rxy = "<>", key = "#"}}
local mainLoop = true
local gbSuc    = level.readStage(2)

function stopExecution(oBall, tTr, sMsg)
  mainLoop = false
  level.logStatus("")
  level.logStatus("stopExecution: Opps! That should not happen !")
  level.logStatus("   surf: ", level.traceReflect("surf"))
  level.logStatus("   edge: ", level.traceReflect("edge"))
  level.logStatus("   ball: ", level.traceReflect("ball"))
  for k, v in pairs(tTr) do
    local typ = common.getType(v)
    if(typ == "table") then
      common.logTable(v, "   key: "..k)
    else
      level.logStatus("   key: ", k, tostring(v))
    end
  end
  oBall:Dump()
  tTr.HitAct:Dump()
  level.logStatus(sMsg.."\n")
end

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
  
  local world = blocks.New():setPos(0,0):setWrap(false):setTable({Type="world"})
        world:setVert(0,0):setVert(W-1,0):setVert(W-1,H-1):setVert(0,H-1)
        world:setStat(true):setLife(1):setHard(true):setDrawColor(colormap.getColorGreenRGB())
        world:setKey(level.getKey())
  level.addActor(world) -- Make sure the key is unique enough

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
    pncl(clDrw or vlMgn); rect(xx-ss, yy-ss, 2*ss+1, 2*ss+1)
    if(bUp) then updt() end
  end

  local function drawComplexLine(S,E,nS,bUp)
    local ss = (tonumber(nS) or 2)
    local sx, sy = S:getParts()
    local ex, ey = E:getParts()
    pncl(vlMgn); line(sx, sy, ex, ey)
    pncl(vlMgn); rect(sx-ss, sy-ss, 2*ss+1, 2*ss+1)
    pncl(vlMgn); rect(ex-ss, ey-ss, 2*ss+1, 2*ss+1)
    if(bUp) then updt() end
  end
  
  local function drawComplexCircle(S,nR,clDrw,sTx,bUp)
    local ss = (tonumber(nS) or 2)
    local sx, sy = S:getParts()
    if(tX) then
      pncl(clBlk); text(tostring(tX),0,sx+nR,sy-nR)
    end
    pncl(clBlk); oval(sx, sy, nR, nR, clDrw)
    if(bUp) then updt() end
  end
  
  complex.setAction("drawComplexOrigin", drawComplexOrigin)
  complex.setAction("drawComplexCircle", drawComplexCircle)
  complex.setAction("drawComplexLine", drawComplexLine)

  local function actBoard(oBoard)
    local tData = oBoard:getTable()
    local brPos, brVel = oBoard:getPos(), oBoard:getVel()
    local key, vel, sgn, vtx = keys.getKey(), tData.Velocity, 0, 0
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
    -- Draw collision check
  end

  local function actBall(oBall)
    local baPos = oBall:getPos()
    local baVel = oBall:getVel()
    local tData = oBall:getTable()
    local tfSlf = {[oBall:getKey()] = true}
    local tfAll = {[tData.Type] = tfSlf}
    local tTr   = level.traceRay(baPos, baVel, tData.Size, tfAll)
    local bHit  = level.gonnaHit(baPos, baVel)
    tTr.HitPos:Action("drawComplexOrigin", nil, 2)
    tTr.VtxStr:Action("drawComplexLine", tTr.VtxEnd)
    
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
      level.logStatus(niCnt, "hit_loop", bHit)
        tTr.VtxStr:Action("drawComplexLine", tTr.VtxEnd)        
        
      level.logStatus(niCnt,"dif1", tTr.HitDst, nvPrt)
        
        nvPrt = (nvPrt - tTr.HitDst)
        
        tTr.HitAct:Damage(tData.Damage)
        if(tTr.HitAct:isDead()) then level.delActor(tTr.HitAct) end
        
        level.logStatus(niCnt,"dif2", tTr.HitDst, tTr.HitAim:getNorm(), nvPrt)
        
        local cN, cR
        local bSurf = level.traceReflect("surf")
        local bEdge = level.traceReflect("edge")
        local bBall = level.traceReflect("ball")
        
        level.logStatus("flg", bSurf, bEdge, bBall)
        
        if(bSurf) then
          cN, cR = complex.getReflectRayLine(cpInt, cvRef, tTr.VtxStr, tTr.VtxEnd)
        elseif(bEdge) then
          cN, cR = complex.getReflectRayCircle(cpInt, cvRef, tTr.VtxStr, tData.Size, tTr.HitPos)
        elseif(bBall) then
          local nRad = tTr.HitAct:getTable().Size + tData.Size
          cN, cR = complex.getReflectRayLine(cpInt, cvRef, tTr.VtxStr, nRad, tTr.HitPos)
        end
        
        level.logStatus(niCnt,"ref", cN, cR, nvPrt)
        
        if(common.isNan(cN:getReal()) or common.isNan(cN:getImag())) then
          stopExecution(oBall, tTr, "Cannot reflect velocity at iteration #"..niCnt)
        end
        
        cpInt:Set(tTr.HitPos); cvRef:Set(cR):Mul(nvPrt) -- The rest of the vector to trace
        
        level.logStatus(niCnt,"trs", tTr.HitPos, cpInt, cvRef)
        
        -- Adjust the next frame position according to the trace
        cfPos:Set(cpInt):Add(cvRef); cfVel:Set(cvRef):Unit():Mul(baVel:getNorm())
        
        level.logStatus(niCnt,"nve", cfPos, cfVel)
        
        -- Draw the ball trajectory if enabled
        oBall:addTrace(cpInt):addTrace(cfPos)
        
        level.logStatus(niCnt,"loop_end")
        
        tTr  = level.traceRay(cpInt, cvRef, tData.Size, tfAll)
        bHit = level.gonnaHit(cpInt, cvRef)
        
        level.logStatus(niCnt,"new_trace", bHit, tTr.HitPos, cpInt, cvRef)
        level.logStatus(niCnt,"loop_end\n\n")
        
        niCnt = niCnt + 1
      end -- Hold the current frame while calculating the position ( The ball is still in the crrent frame )
      
      oBall:setFrame(true):setPos(cfPos):setVel(cfVel)
    else
      -- Update the OOP accordingly and move in 2D space if nothing is hit
      oBall:setVel(baVel)
    end
  end
  
  -- Retrice the current actor stack
  local gtActors = level.getActors()
  
  -- Actor working priorities
  local tPrior = level.getPriorityKeys()
  local nPrior = #tPrior
  
  -- Apply action and drawing behaviors
  local gtBehave = {
    ["board"] = {__act = actBoard, __drw = nil     , __cnt = 0, __all = 0},
    ["brick"] = {__act = nil     , __drw = nil     , __cnt = 0, __all = 0},
    ["ball" ] = {__act = actBall , __drw = drawBall, __cnt = 0, __all = 0},
    ["world"] = {__act = nil     , __drw = nil     , __cnt = 0, __all = 0}
  }
  
 -- common.logTable(gtActors)
  
  for ID = 1, nPrior do
    sTyp = tPrior[ID]
    tAct = gtActors[sTyp]
    if(type(tAct) == "table") then
      for k, v in pairs(gtActors[sTyp]) do
        local tDat = v:getTable()
        if(tDat and tDat.Type) then
          local setUp = gtBehave[tDat.Type]
          if(setUp) then
            setUp.__all = setUp.__all + 1
            if(tDat.Type == "board" and setUp.__cnt >= 1) then
              common.logStatus("Play: Only one player is allowed. You have <"..setUp.__all..">")
            elseif(tDat.Type == "world" and setUp.__cnt >= 1) then
              common.logStatus("Play: Only one world is allowed. You have <"..setUp.__all..">")
            else
              v:setAction(setUp.__act)
              v:setDraw  (setUp.__drw)
              setUp.__cnt = setUp.__cnt + 1
            end
          end
        end
      end
    end
  end
  
  common.logStatus("Play: Current level summary:")
  common.logStatus("  Worlds: "..gtBehave["world"].__cnt)
  common.logStatus("  Boards: "..gtBehave["board"].__cnt)
  common.logStatus("  Balls : "..gtBehave["ball" ].__cnt)
  common.logStatus("  Bricks: "..gtBehave["brick"].__cnt)
   
  while (mainLoop and level.hasBalls()) do wipe()
    for ID = 1, nPrior do level.procStackType(ID) end    
    updt(); wait(gnTick)
  end
  
  common.logStatus("The level has finished there are no spare balls left !")
  
else
  common.logStatus("Play: Failed reading the first level !")
end