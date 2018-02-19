local complex       = require("complex")
local export        = require("export")
local colormap      = require("colormap")
local blocks        = require("blockBraker/blocks")
local common        = require("common")
local logStatus     = common.logStatus
local type          = type
local getmetatable  = getmetatable
local level         = {}
local metaActors    = {}
metaActors.stack    = {}
metaActors.garbage  = 10
metaActors.curcoll  = 0
metaActors.trace    = {
  Hit    = false,
  HitPos = complex.getNew(),
  HitAim = complex.getNew(),
  HitNrm = complex.getNew(),
  VtxStr = complex.getNew(),
  VtxEnd = complex.getNew(),
  HitTyp = "",
  HitDst = 0,
  HitAct = 0,
  HitKey = 0,
  HitFlt = {}
}

metaActors.scrsize  = {W = 800, H = 400}
function level.getScreenSize()
  return metaActors.scrsize.W, metaActors.scrsize.H
end

metaActors.priorkey = {"board","brick","world","ball"}
function level.getPriorityKeys()
  return export.copyItem(metaActors.priorkey)
end

metaActors.keyprior = {} for I = 1, #metaActors.priorkey do
  metaActors.keyprior[metaActors.priorkey[I]] = I end
function level.getKeysPriority()
  return export.copyItem(metaActors.keyprior)
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

function level.procStackType(vID)
  local iID  = common.getClamp(tonumber(vID) or 0, 1, #metaActors.priorkey)
  local sTyp = metaActors.priorkey[iID]; if(not sTyp) then
    return logStatus("level.procTypeStack: ID missing <"..tostring(iID)..">", false) end
  local tAct = metaActors.stack[sTyp]; if(not tAct) then
    return logStatus("level.procTypeStack: Stack missing <"..tostring(iID).."/"..tostring(sTyp)..">", false) end
  for key, val in pairs(tAct) do
    val:Act()
    val:Move()
    val:Draw()
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
  tTr.Hit, tTr.HitDst = false, 0
  for ID = 1, #keyPri do
    local nam = keyPri[ID]
    local stk = actStk[nam]
    local ftr = fTr[nam]
    for key, val in pairs(stk) do
      if(val and not (ftr and ftr[key])) then
        local nVtx = val:getVertN()
        if(nVtx > 0) then -- Polygon
          local vS, vE, vN = oPos:getNew(), oPos:getNew(), oPos:getNew()
          local cS, cE, vA = oPos:getNew(), oPos:getNew(), oPos:getNew()
          local ID, vI, vP = 1, val:getVert(1), val:getPos()
          while(ID <= nVtx) do
            cS:Set(vP):Add(val:getVert(ID) or vI); ID = ID + 1
            cE:Set(vP):Add(val:getVert(ID) or vI)
            vN:Set(oPos):Project(cS, cE):Neg():Add(oPos):Unit()
            vS:Set(vN):Mul(nOfs):Add(cS)
            vE:Set(vN):Mul(nOfs):Add(cE)
            
            vS:Action("drawComplexLine", vE, 3, true)
            
            
            local xX = complex.getIntersectRayRay(oPos, oVel, vS, vE-vS)
            if(xX) then -- Chech only non-parallel surfaces
              if(xX:isAmong(vS, vE)) then vA:Set(xX):Sub(oPos)
                -- Make sure that the point belongs to a surface
                if(vA:getDot(oVel) > 0 and vN:getDot(oVel) < 0) then
                  -- Chech only these in front of us and these that we are probably gonna hit
                  local nA = vA:getNorm() -- Lngth to the trace position to check if a hit is present
                  if(tTr.Hit) then -- If we have registered a hit with the new trace call
                    if(nA < tTr.HitDst) then
                      tTr.HitPos:Set(xX)
                      tTr.HitAct, tTr.HitKey, tTr.HitTyp = val, key, nam
                      tTr.HitAim:Set(vA); tTr.HitDst = nA
                      tTr.HitNrm:Set(vN); tTr.VtxStr:Set(vS); tTr.VtxEnd:Set(vE)
                      tTr.HitPos:Action("drawComplexOrigin", clBlu, 4, nil, nCnt, true)
                      nCnt = nCnt + 1
                    end -- For all the others that we must compare minimum to
                  else tTr.Hit = true
                    tTr.HitPos:Set(xX)
                    tTr.HitAct, tTr.HitKey, tTr.HitTyp = val, key, nam
                    tTr.HitAim:Set(vA); tTr.HitDst = nA
                    tTr.HitNrm:Set(vN); tTr.VtxStr:Set(vS); tTr.VtxEnd:Set(vE)
                    tTr.HitPos:Action("drawComplexOrigin", clBlu, 4, nil, nCnt, true)
                    nCnt = nCnt + 1
                  end
                end
              end
            end
          end
        else -- Ball
         -- xF, xC = cmp.getIntersectRayCircle(oPos, oVel, cRay2[1], nOfs)
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

function level.getActors() return metaActors.stack end

metaActors.store = {
  [1 ] = {"setTable"    , export.stringTable},
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
  local pF, actSt = io.open("blockBraker/levels/"..sF..".txt"), metaActors.store
  if(not pF) then return logStatus("levels.readStage: No file <"..tostring(sF)..">", ""), true end
  local sLn, isEOF = "", false
  while(not isEOF) do sLn, isEOF = common.fileGetLine(pF)
    if(sLn ~= "" and sLn:sub(1,1) ~= "#") then 
      if(bLog) then logStatus("\nlevels.readStage: <"..sLn..">") end
      local tCmp, bNew = common.stringExplode(sLn,"/")
      for I = 1, #actSt do local tPar = actSt[I]
        if(tPar[1] == "setTable") then bNew = blocks.New() end
        if(bLog) then logStatus("  levels.readStage: Start ["..I.."] <"..tostring(tCmp[I])..">") end
        local tItm = common.stringExplode(common.stringTrim(tCmp[I]),";")
        for J = 1, #tItm do if(bLog) then logStatus("  levels.readStage:   "..tPar[1].." ("..J..") : "..tItm[J]) end
          if(not tPar[2]) then return logStatus("levels.readStage: Data convertor ["..J.."] missing <"..tPar[1]..">", false) end
          bNew[tPar[1]](bNew,tPar[2](tItm[J]))
        end
      end; level.addActor(bNew); if(bLog) then bNew:Dump() end
    end
  end; return true
end

return level
