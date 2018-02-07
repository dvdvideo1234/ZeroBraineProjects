local complex      = require("complex")
local export       = require("export")
local colormap     = require("colormap")
local blocks       = require("blockBraker/blocks")
local common       = require("common")
local logStatus    = common.logStatus
local type         = type
local getmetatable = getmetatable
local level        = {}
local metaActors   = {}
metaActors.stack   = {}
metaActors.garbage = 10
metaActors.curcoll = 0
metaActors.scrsize = {W = 800, H = 400}
metaActors.trace   = {
  HitPos = complex.getNew(),
  HitAim = complex.getNew(),
  HitNrm = complex.getNew(),
  VtxStr = complex.getNew(),
  VtxEnd = complex.getNew(),
  HitAct = 0,
  HitKey = 0,
  MinLen = 0,
  HitFlt = {}
}
metaActors.border = {
  Hit    = false,
  HitDst = 0,
  HitCnt = 0,
  HitPos = complex.getNew(),
  HitOrg = complex.getNew(),
  HitDir = complex.getNew(),
  VtxStr = complex.getNew(),
  VtxEnd = complex.getNew()
}

function level.getScreenSize()
  return metaActors.scrsize.W, metaActors.scrsize.H
end

function level.setGarbage(vGrb)
  metaActors.garbage = (tonumber(vGrb) or 0)
  if(metaActors.garbage < 1) then metaActors.garbage = 1 end
end

function level.delActor(vKey)
  if(not vKey) then return logStatus("level.delActor: Key invalid", false) end
  if(metaActors.stack[vKey]) then metaActors.stack[vKey] = nil
     metaActors.curcoll = metaActors.curcoll + 1
     if(metaActors.curcoll >= metaActors.garbage) then collectgarbage() end; return true
  end; return false
end

function level.addActor(vKey, oAct)
  if(not vKey) then return logStatus("level.addActor: Key invalid", false) end
  local tAct = metaActors.stack
  if(common.getType(oAct) == "blocks.block") then
    tAct[vKey] = oAct; oAct:setKey(vKey) return true
  end; return logStatus("level.addActor: Object wrong type", false)
end

--[[
  oPos > Start position of the trace
  oVel > Direction of the the trace ( usually the velocity )
  tKey > Table containing the actor keys to be skipped
]]
function level.smpActor(oPos, oVel, tKey)
  local tTr, fTr, trHit = metaActors.trace, tKey or {}, false
  for k, v in pairs(metaActors.stack) do
    if(v and not fTr[k]) then local nVtx = v:getVertN()
      if(nVtx > 0) then -- Polygon
        local cS, cE = oPos:getNew(), oPos:getNew()
        local ID, vI, vP = 1, v:getVert(1), v:getPos()
        while(ID <= nVtx) do
          cS:Set(vP):Add(v:getVert(ID) or vI); ID = ID + 1
          cE:Set(vP):Add(v:getVert(ID) or vI)
          local bSuc, nT, nU, xX = complex.getIntersectRayRay(oPos, oVel, cS, cE-cS)
          if(bSuc) then -- Chech only non-parallel surfaces
            if(xX:isAmong(cS, cE, 1e-10)) then -- Make sure that the point belongs to a surface
              local cV = (xX - oPos); local nD = cV:getDot(oVel)
              if(nD > 0) then -- Chech only these in front of us
                if(not trHit) then tTr.MinLen, trHit = nD, true
                  tTr.HitPos:Set(xX); tTr.HitAim:Set(cV); tTr.HitAct = v
                  tTr.VtxStr:Set(cS); tTr.VtxEnd:Set(cE); tTr.HitKey = k
                  tTr.HitNrm:Set(oPos):Project(cS, cE):Neg():Add(oPos):Unit()
                else -- For all the others that we must compare minimum to
                  if(nD < tTr.MinLen) then
                    tTr.HitAct = v; tTr.HitKey = k
                    tTr.MinLen = nD; tTr.HitPos:Set(xX); tTr.HitAim:Set(cV);
                    tTr.VtxStr:Set(cS); tTr.VtxEnd:Set(cE)
                    tTr.HitNrm:Set(oPos):Project(cS, cE):Neg():Add(oPos):Unit()
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
  return tTr
end

function level.getHit(oPos, oVel, vHit)
  local tTr  = metaActors.trace
  local cHit = (vHit and vHit or tTr.HitPos)
  if((cHit - oPos):getNorm() > oVel:getNorm()) then return false end
  return true
end

function level.Clear()
  for k, _ in pairs(metaActors.stack) do metaActors.stack[k] = nil end
  collectgarbage(); return true
end

function level.getBorder(oPos, oVel, nOfs)
  local tTr = metaActors.trace
  local tBr = metaActors.border; tBr.Hit, tBr.HitCnt = false, 0
  local vnO = tBr.HitOrg:Set(tTr.HitNrm):Mul(nOfs)
  local cpS = tBr.VtxStr:Set(tTr.VtxStr):Add(vnO)
  local cpE = tBr.VtxEnd:Set(tTr.VtxEnd):Add(vnO)  
  local bSuc, nT, nU, xX = complex.getIntersectRayRay(oPos, oVel, cpS, cpE-cpS)
  if(bSuc) then
    local cpH  = tBr.HitPos:Set(xX)
    local vdH  = tBr.HitDir:Set(xX):Sub(oPos)
    tBr.HitDst = vdH:getNorm()
    if(tBr.HitDst < oVel:getNorm()) then
      tBr.Hit, tBr.HitCnt = true, (tBr.HitCnt + 1)
    end
  end
  return tBr
end

function level.getActors() return metaActors.stack end

metaActors.store = {
  [1]  = {"setTable"    , export.stringTable},
  [2]  = {"setPos"      , complex.convNew},
  [3]  = {"setVel"      , complex.convNew},
  [4]  = {"setVert"     , complex.convNew},
  [5]  = {"setAng"      , tonumber},
  [6]  = {"setStat"     , common.toBool},
  [7]  = {"setHard"     , common.toBool},
  [8]  = {"setLife"     , tonumber},
  [9]  = {"setDrawColor", colormap.Convert},
  [10] = {"setTrace"    , tonumber}
}

function level.Read(sF, bLog)
  local pF, actSt = io.open("blockBraker/levels/"..sF..".txt"), metaActors.store
  if(not pF) then return logStatus("levels.Read: No file <"..tostring(sF)..">", ""), true end
  local sLn, isEOF, tAct, iID = "", false, metaActors.stack, (#metaActors.stack + 1) 
  while(not isEOF) do sLn, isEOF = common.fileGetLine(pF)
    if(sLn ~= "" and sLn:sub(1,1) ~= "#") then tAct[iID] = blocks.New():setKey(iID)
      if(bLog) then logStatus("\nlevels.Read: <"..sLn..">") end
      local tCmp, bNew = common.stringExplode(sLn,"/"), tAct[iID]
      for I = 1, #actSt do local tPar = actSt[I]
        if(bLog) then logStatus("  levels.Read: Start ["..I.."] <"..tostring(tCmp[I])..">") end
        local tItm = common.stringExplode(common.stringTrim(tCmp[I]),";")
        for J = 1, #tItm do
          if(bLog) then logStatus("  levels.Read:   "..tPar[1].." ("..J..") : "..tItm[J]) end
          bNew[tPar[1]](bNew,tPar[2](tItm[J]))
        end
        if(bLog) then bNew:Dump() end
      end; iID = (iID + 1)
    end
  end; return true
end

return level
