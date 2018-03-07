local complex       = require("complex")
local colormap      = require("colormap")
local blocks        = require("lib/blocks")
local common        = require("common")
local logStatus     = common.logStatus
local type          = type
local getmetatable  = getmetatable
local level         = {}
local metaActors    = {}
metaActors.stack    = {}
metaActors.garbage  = 10
metaActors.curcoll  = 0
metaActors.logwork  = false
metaActors.logfile  = false
metaActors.trace    = {
  Hit    = false,
  HitRef = {
    ["surf"] = false,
    ["edge"] = false,
    ["ball"] = false
  },
  HitPos = complex.getNew(),
  HitAim = complex.getNew(),
  HitNrm = complex.getNew(),
  VtxStr = complex.getNew(),
  VtxEnd = complex.getNew(),
  HitTyp = "",
  HitOfs = 0,
  HitDst = 0,
  HitAct = 0,
  HitKey = 0,
  HitFlt = {}
}

function level.logStatus(...)
  local bW = metaActors.logwork
  local bF = metaActors.logfile
  if(bW) then
    local sL, tA = "", {...}
    for ID = 1, #tA do sL = sL.."\t"..tostring(tA[ID]) end
    sL = common.stringTrim(sL)
    if(bF) then
      local fF = io.open("level_log.txt","a")
      if(fF) then fF:write(sL.."\n") end
      common.logStatus("logStatus: Log write failed")
    else
      common.logStatus(sL)
    end
  end
end

metaActors.typereflect = {"surf","edge","ball"}

metaActors.scrsize  = {W = 800, H = 400}
function level.getScreenSize()
  return metaActors.scrsize.W, metaActors.scrsize.H
end

function level.openWindow(sT)
  local W, H = level.getScreenSize()
  open(tostring(sT or "Default"))
  size(W, H); zero(0, 0); updt(false) 
end

metaActors.priorkey = {"board","brick","world","ball"}
function level.getPriorityKeys()
  return common.copyItem(metaActors.priorkey)
end

metaActors.keyprior = {} for I = 1, #metaActors.priorkey do
  metaActors.keyprior[metaActors.priorkey[I]] = I end
function level.getKeysPriority()
  return common.copyItem(metaActors.keyprior)
end

function level.getKey()
  return common.randomGetString(50)
end

function level.setGarbage(vGrb)
  metaActors.garbage = (tonumber(vGrb) or 0)
  if(metaActors.garbage < 1) then metaActors.garbage = 1 end
end

function level.delActor(oAct)
  if(common.getType(oAct) == "blocks.block") then
    local tTab, tAct = oAct:getTable(), metaActors.stack
    if(not tTab) then return logStatus("level.addActor: Object setup invalid", false) end
    local sKey, sTyp = oAct:getKey(), tTab.Type
    if(not metaActors.keyprior[sTyp]) then 
      return logStatus("level.addActor: Object type invalid <"..tostring(sTyp)..">", false) end
    local tPlc = tAct[sTyp]; if(not tPlc) then tAct[sTyp] = {}; tPlc = tAct[sTyp] end
    tPlc[sKey], metaActors.curcoll = nil, (metaActors.curcoll + 1)
    if(metaActors.curcoll >= metaActors.garbage) then
      collectgarbage(); metaActors.curcoll = 0 end
    return true
  end; return logStatus("level.delActor: Object wrong type", false)  
end

function level.addActor(oAct)
  local tAct, oTyp = metaActors.stack, common.getType(oAct)
  if(oTyp == "blocks.block") then
    local tTab = oAct:getTable()
    if(not tTab) then return logStatus("level.addActor: Object setup invalid", false) end
    local sKey, sTyp = level.getKey(), tTab.Type
    if(not metaActors.keyprior[sTyp]) then 
      return logStatus("level.addActor: Object type invalid <"..tostring(sTyp)..">", false) end
    local tPlc = tAct[sTyp]; if(not tPlc) then tAct[sTyp] = {}; tPlc = tAct[sTyp] end
    tPlc[sKey] = oAct; oAct:setKey(sKey); return true
  end; return logStatus("level.addActor: Object wrong type <"..oTyp..">", false)
end

function level.procStack(vID, sMth, ...)
  local iID  = common.getClamp(tonumber(vID) or 0, 1, #metaActors.priorkey)
  local sTyp = metaActors.priorkey[iID]; if(not sTyp) then
    return logStatus("level.procStack: ID missing <"..tostring(iID)..">", false) end
  local tAct = metaActors.stack[sTyp]; if(not tAct) then
    return logStatus("level.procStack: Stack missing <"..tostring(iID).."/"..tostring(sTyp)..">", false) end
  if(not common.isString(sMth)) then 
    return logStatus("level.procStack: Mthod <"..tostring(sMth).."> not hash <"..tostring(iID).."/"..tostring(sTyp)..">", false) end
  if(common.isDryString(sMth)) then 
    return logStatus("level.procStack: Mthod empty <"..tostring(iID).."/"..tostring(sTyp)..">", false) end
  for key, val in pairs(tAct) do val[sMth](val, ...) end
end

function level.traceReflect(sTyp, vSta)
  local bSt = common.toBool(vSta)
  local sTy = tostring(sTyp or "")
  local tRf = metaActors.trace.HitRef
  if(not common.isNil(tRf[sTy])) then
    if(not common.isNil(vSta)) then tRf[sTy] = bSt end
    return tRf[sTy]
  end return nil
end

function level.getActors() return metaActors.stack end

function level.hasActors(sAct)
  if(not common.isString(sAct)) then 
    return logStatus("level.hasActors: Name invalid <"..tostring(sMth)..">", false) end
  if(common.isDryString(sAct)) then 
    return logStatus("level.hasActors: Name empty", false) end
  if(common.isNil(metaActors.keyprior[sAct])) then
    return logStatus("level.hasActors: Type missing <"..sAct..">", false) end
  if(common.isDryTable(metaActors.stack[sAct])) then
    return logStatus("level.hasActors: Actor missing <"..sAct..">", false) end
  return true
end

function level.hookAction(tBeh)
  local tStk = metaActors.stack
  local tPri = metaActors.priorkey
  for ID = 1, #tPri do
    local sTyp = tPri[ID]
    local tAct = tStk[sTyp]
    if(type(tAct) == "table") then
      for k, v in pairs(tStk[sTyp]) do
        local tDat = v:getTable()
        if(tDat and tDat.Type) then
          local setUp = tBeh[tDat.Type]
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
end

--[[
  oPos > Start position of the trace
  oVel > Direction of the the trace ( usually the velocity )
  tKey > Table containing the actor keys to be skipped
]]
function level.traceRay(oPos, oVel, nOfs, tKey)
  local nCnt = 0
  local clBlu = colr(colormap.getColorBlueRGB())
  local tTr, fTr = metaActors.trace, (tKey or {})
  local keyPri, actStk = metaActors.priorkey, metaActors.stack
  tTr.Hit, tTr.HitDst, tTr.HitOfs = false, 0, nOfs
  level.traceReflect("surf", false)
  level.traceReflect("edge", false)
  level.traceReflect("ball", false)
  for ID = 1, #keyPri do
    local nam = keyPri[ID]
    local stk = actStk[nam]
    local ftr = fTr[nam]
    for key, val in pairs(stk) do
      if(val and not (ftr and ftr[key])) then
        local nVtx = val:getVertN()
        if(nVtx > 0) then -- Polygon
          local cS, cE, vA = oPos:getNew(), oPos:getNew(), oPos:getNew()
          local vS, vE, vN = oPos:getNew(), oPos:getNew(), oPos:getNew()
          local ID, vI, vP = 1, val:getVert(1), val:getPos(), oPos:getNew()
          while(ID <= nVtx) do
            cS:Set(vP):Add(val:getVert(ID) or vI); ID = ID + 1
            cE:Set(vP):Add(val:getVert(ID) or vI)
            vN:Set(oPos):ProjectLine(cS, cE):Neg():Add(oPos):Unit()
            vS:Set(vN):Mul(tTr.HitOfs):Add(cS)
            vE:Set(vN):Mul(tTr.HitOfs):Add(cE)
          --  vS:Action("drawComplexLine", vE, 1, true)
          --  cS:Action("drawComplexCircle", tTr.HitOfs, nil, nCnt, true)
            local xR = complex.getIntersectRayRay(oPos, oVel, vS, vE-vS)
            local xS = common.getPick(xR and xR:isAmongLine(vS, vE) and (vN:getDot(oVel) < 0), xR, nil)
            local xE = complex.getIntersectRayCircle(oPos, oVel, cS, tTr.HitOfs)
            local hitSurf, hitEdge, hitPos, hitNorm = false, false
            if(xS and xE) then
              local nS = (xS - oPos):getNorm()
              local nE = (xE - oPos):getNorm()
              local bP = (nS < nE)
              hitPos  = common.getPick(bP, xS, xE)
              hitEdge = common.getPick(bP, false, true ) 
              hitSurf = common.getPick(bP, true , false)
              hitNorm = common.getPick(bP, vN, xE:getSub(cS):Unit())
            elseif(xS and not xE) then
              hitPos, hitNorm, hitEdge, hitSurf = xS, vN, false, true
            elseif(not xS and xE) then
              hitPos, hitNorm, hitEdge, hitSurf = xE, xE:getSub(cS):Unit(), true, false 
            else
              hitPos, hitNorm, hitEdge, hitSurf = nil, nil, false, false
            end
            if(hitPos and (hitSurf or hitEdge)) then -- Chech only non-parallel surfaces
              vA:Set(hitPos):Sub(oPos)
                -- Make sure that the point belongs to a surface
              if(vA:getDot(oVel) > 0) then
                -- Chech only these in front of us and these that we are probably gonna hit
                local nA = vA:getNorm() -- Lngth to the trace position to check if a hit is present
                if(tTr.Hit) then -- If we have registered a hit with the new trace call
                  if(nA < tTr.HitDst) then
                    tTr.HitPos:Set(hitPos)
                    level.traceReflect("surf", hitSurf)
                    level.traceReflect("edge", hitEdge)
                    level.traceReflect("ball", false)
                    tTr.HitAct, tTr.HitKey, tTr.HitTyp = val, key, nam
                    tTr.HitAim:Set(vA); tTr.HitDst = nA
                    tTr.HitNrm:Set(hitNorm)
                    if(hitSurf) then     tTr.VtxStr:Set(vS); tTr.VtxEnd:Set(vE)
                    elseif(hitEdge) then tTr.VtxStr:Set(cS); tTr.VtxEnd:Set(cS) end
                  end -- For all the others that we must compare minimum to
                else tTr.Hit = true
                  tTr.HitPos:Set(hitPos)
                  level.traceReflect("surf", hitSurf)
                  level.traceReflect("edge", hitEdge)
                  level.traceReflect("ball", false)
                  tTr.HitAct, tTr.HitKey, tTr.HitTyp = val, key, nam
                  tTr.HitAim:Set(vA); tTr.HitDst = nA
                  tTr.HitNrm:Set(hitNorm);
                  if(hitSurf) then     tTr.VtxStr:Set(vS); tTr.VtxEnd:Set(vE)
                  elseif(hitEdge) then tTr.VtxStr:Set(cS); tTr.VtxEnd:Set(cS) end
                end
              end
            end
          end
        else -- Ball
          local vP = val:getPos()
          local tB = val:getTable()
          local nR = (tB.Size + nOfs)
          local xN = complex.getIntersectRayCircle(oPos, oVel, vP, nR)
          if(xN and xN:isAmongRay(oPos, oVel, true)) then
            vP:Action("drawComplexCircle", nR, nil, nil, true)
            local vA = xN:getNew():Sub(oPos)
            local nA = vA:getNorm()
            local vN = xN:getNew():Sub(vP):Unit()
            if(tTr.Hit) then
              if(nA < tTr.HitDst) then
                tTr.HitPos:Set(xN)
                level.traceReflect("surf", false)
                level.traceReflect("edge", false)
                level.traceReflect("ball", true)
                tTr.HitAct, tTr.HitKey, tTr.HitTyp = val, key, nam
                tTr.HitAim:Set(vA); tTr.HitDst = nA
                tTr.HitNrm:Set(vN)
                tTr.VtxStr:Set(vP); tTr.VtxEnd:Set(vP)
              end
            else
              tTr.Hit = true
              tTr.HitPos:Set(xN)
              level.traceReflect("surf", false)
              level.traceReflect("edge", false)
              level.traceReflect("ball", true)
              tTr.HitAct, tTr.HitKey, tTr.HitTyp = val, key, nam
              tTr.HitAim:Set(vA); tTr.HitDst = nA
              tTr.HitNrm:Set(vN)
              tTr.VtxStr:Set(vP); tTr.VtxEnd:Set(vP)
            end
          end
        end
      end
    end
  end
  
  return tTr
end

function level.gonnaHit(oPos, oVel)
  local tTr = metaActors.trace
  if(tTr.Hit and (tTr.HitPos - oPos):getNorm() < oVel:getNorm())
  then return true end; return false
end

function level.clearAll()
  for k, _ in pairs(metaActors.stack) do
    metaActors.stack[k] = nil end
  collectgarbage(); return true
end

metaActors.store = {
  [1 ] = {"setTable"    , common.stringToTable},
  [2 ] = {"setPos"      , complex.convNew},
  [3 ] = {"setVel"      , complex.convNew},
  [4 ] = {"setVert"     , complex.convNew},
  [5 ] = {"setAng"      , tonumber},
  [6 ] = {"setStat"     , common.toBool},
  [7 ] = {"setHard"     , common.toBool},
  [8 ] = {"setLife"     , tonumber},
  [9 ] = {"setDrawColor", colormap.convColorRGB},
  [10] = {"setTrace"    , tonumber}
}
function level.readStage(sF, bLog)
  local cF = tostring(sF or ""); if(common.isDryString(cF)) then
    return logStatus("levels.readStage: Missing file name", false) end
  local pF, actSt = io.open("levels/"..cF..".txt"), metaActors.store
  if(not pF) then return logStatus("levels.readStage: No file <"..tostring(sF)..">", false) end
  local sLn, isEOF = "", false
  while(not isEOF) do sLn, isEOF = common.fileGetLine(pF)
    if(sLn ~= "" and sLn:sub(1,1) ~= "#") then 
      if(bLog) then logStatus("\nlevels.readStage: <"..sLn..">") end
      local tCmp, bNew = common.stringExplode(sLn,"/")
      for I = 1, #actSt do local tPar = actSt[I]
        if(tPar[1] == "setTable") then bNew = blocks.New() end
        if(bLog) then logStatus("  levels.readStage: Start ["..I.."] <"..tostring(tCmp[I])..">") end
        local tItm = common.stringExplode(common.stringTrim(tCmp[I]),";")
        for J = 1, #tItm do tItm[J] = common.stringTrim(tItm[J])
          if(bLog) then logStatus("  levels.readStage:   "..tPar[1].." ("..J..") : "..tItm[J]) end
          if(not tPar[2]) then return logStatus("levels.readStage: Data convertor ["..J.."] missing <"..tPar[1]..">", false) end
          if(not common.isDryString(tItm[J])) then bNew[tPar[1]](bNew,tPar[2](tItm[J])) end
        end
      end; level.addActor(bNew); if(bLog) then bNew:Dump() end
    end
  end; return true
end

return level
