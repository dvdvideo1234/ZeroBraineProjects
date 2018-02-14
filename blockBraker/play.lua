local colormap = require("colormap")
local complex  = require("complex")
local keys     = require("blockBraker/keys")
local blocks   = require("blockBraker/blocks")
local level    = require("blockBraker/level")
local common   = require("common")
local export   = require("export")

io.stdout:setvbuf("no")

local gnTick  = 1 
local gtDebug = {en = false, data = {lxy = "<>", rxy = "<>", key = "#"}}

local gbSuc = level.readStage("internals")

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

  local function drawComplexOrigin(oC, nS, oO, tX)
    local ss = (tonumber(nS) or 2)
    local xx, yy = oC:getParts()
    if(oO) then
      local ox, oy = oO:getParts()
      pncl(clGry180); line(xx, yy, ox, oy)
    end
    if(tX) then
      pncl(clBlk); text(tostring(tX),0,xx,yy)
    end
    pncl(vlMgn); rect(xx-ss, yy-ss, 2*ss, 2*ss)
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
    local tKey  = {[oBall:getKey()] = true}
    local tTr   = level.traceRay(baPos, baVel, tData.Size, tKey)
    local bHit  = level.gonnaHit(baPos, baVel)
    tTr.HitPos:Action("drawComplexOrigin", 2)
    tTr.VtxStr:Action("drawComplexLine", tTr.VtxEnd)
    local T = (tTr.HitPos + tTr.HitNrm * 20)
    T:Action("drawComplexOrigin", 1.8, tTr.HitPos)
    
    
    
    if(bHit) then -- Is there a hit to tavke cate in the frame
      local nvPrt = baVel:getNorm()
      local cfPos, cfVel = baPos:getNew(), baVel:getNew()
      local cpInt, cvRef = baPos:getNew(), baVel:getNew()
      
      print("pos", baPos, baVel)
      
      while(bHit) do
        
        tTr.VtxStr:Action("drawComplexLine", tTr.VtxEnd)        
        
        if(tTr.HitAct:isDead()) then
          level.delActor(tTr.HitAct)
        else
          tTr.HitAct:Damage(tData.Damage)
        end
        print(1, tTr.HitDst, nvPrt)
        if(tTr.HitDst < nvPrt) then nvPrt = (nvPrt - tTr.HitDst)
          local cN, cR = complex.getReflectRayLine(cpInt, cvRef, tTr.VtxStr, tTr.VtxEnd)
          print(2, cN, cR)
          
          local T = (tTr.HitPos + cR * 30)
          T:Action("drawComplexOrigin", 1.8, tTr.HitPos)
          
          cpInt:Set(tTr.HitPos); cvRef:Set(cR):Mul(nvPrt) -- The rest of the vector to trace
          -- Adjust the next frame position according to the trace
          cfPos:Set(cpInt); cfVel:Set(cvRef):Unit():Mul(baVel:getNorm())
          -- Draw the ball trajectory if enabled
          oBall:addTrace(cpInt):addTrace(cfPos)
        end
        
        
        tTr  = level.traceRay(cpInt, cvRef, tData.Size, tKey)
        bHit = level.gonnaHit(cpInt, cvRef)
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
  
  -- Apply actions and drawings
  local gtBehave = {
    ["board"] = {__act = actBoard, __drw = nil     , __cnt = 0, __all = 0},
    ["brick"] = {__act = nil     , __drw = nil     , __cnt = 0, __all = 0},
    ["ball" ] = {__act = actBall , __drw = drawBall, __cnt = 0, __all = 0},
    ["world"] = {__act = nil     , __drw = nil     , __cnt = 0, __all = 0}
  }
  
 -- export.tableString(gtActors)
  
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
   
  while true do wipe()
    for ID = 1, nPrior do level.procStackType(ID) end    
    updt(); wait(gnTick)
  end

else
  common.logStatus("Play: Failed reading the first level !")
end