local complex      = require("complex")
local colormap     = require("colormap")
local blocks       = require("blockBraker/blocks")
local common       = require("common")
local type         = type
local getmetatable = getmetatable
local level        = {}
local metaActors   = {}
metaActors.stack   = {}
metaActors.garbage = 10
metaActors.curcoll = 0
metaActors.trace   = {
  HitPos = complex.New(),
  HitAim = complex.New(),
  HitNrm = complex.New(),
  VtxStr = complex.New(),
  VtxEnd = complex.New(),
  Hit    = false,
  HitAct = 0,
  HitKey = 0,
  MinLen = 0,
  HitFlt = {}
}
      
local function logStatus(anyMsg, ...)
  io.write(tostring(anyMsg).."\n"); return ...
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
  if(common.GetType(oAct) == "blocks.block") then
    tAct[vKey] = oAct; oAct:setKey(vKey) return true
  end; return logStatus("level.addActor: Object wrong type", false)
end

--[[
  oPos > Start position of the trace
  oVel > Direction of the the trace ( usually the velocity )
  tKey > Table containing the actor keys to be skipped
]]
function level.smpActor(oPos, oVel, tKey)
  local tTr, fTr = metaActors.trace, tKey or {}; tTr.Hit = false
  for k, v in pairs(metaActors.stack) do
    if(v and not fTr[k]) then local nVtx = v:getVertN()
      if(nVtx > 0) then -- Polygon
        local cS, cE = oPos:getNew(), oPos:getNew()
        local ID, vI, vP = 1, v:getVert(1), v:getPos()
        while(ID <= nVtx) do
          cS:Set(vP):Add(v:getVert(ID) or vI); ID = ID + 1
          cE:Set(vP):Add(v:getVert(ID) or vI)
          local bSuc, nT, nU, xX = complex.Intersect(oPos, oVel, cS, cE-cS)
          if(bSuc) then -- Chech only non-parallel surfaces
            if(complex.OnSegment(xX, cS, cE, 1e-10)) then -- Make sure that the point belongs to a surface
              local cV = (xX - oPos); local nD = cV:getDot(oVel)
              if(nD > 0) then -- Chech only these in front of us
                if(not tTr.Hit) then tTr.MinLen, tTr.Hit = nD, true
                  tTr.HitPos:Set(xX); tTr.HitAim:Set(cV); tTr.HitAct = v
                  tTr.VtxStr:Set(cS); tTr.VtxEnd:Set(cE); tTr.HitKey = k
                  tTr.HitNrm:Set(complex.Project(oPos, cS, cE)):Neg():Add(oPos):Unit()
                else -- For all the others that we must compare minimum to
                  if(nD < tTr.MinLen) then
                    tTr.HitAct = v; tTr.HitKey = k
                    tTr.MinLen = nD; tTr.HitPos:Set(xX); tTr.HitAim:Set(cV);
                    tTr.VtxStr:Set(cS); tTr.VtxEnd:Set(cE)
                    tTr.HitNrm:Set(complex.Project(oPos, cS, cE)):Neg():Add(oPos):Unit()
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
  
  if((tTr.HitPos - oPos):getNorm() > oVel:getNorm()) then tTr.Hit = false end
    
  return tTr
end

function level.Clear()
  for k, _ in pairs(metaActors.stack) do metaActors.stack[k] = nil end
  collectgarbage(); return true
end

function level.getActors() return metaActors.stack end

metaActors.store = {
  [1] = {"setPos"      , complex.Convert},
  [2] = {"setVert"     , complex.Convert},
  [3] = {"setAng"      , tonumber},
  [4] = {"setVel"      , complex.Convert},
  [5] = {"setStat"     , common.ToBool},
  [6] = {"setHard"     , common.ToBool},
  [7] = {"setLife"     , tonumber},
  [8] = {"setDrawColor", colormap.Convert}
}

function level.Read(sF, bLog)
  local pF, actSt = io.open("blockBraker/"..sF..".txt"), metaActors.store
  if(not pF) then return logStatus("levels.Read: No file <"..tostring(sF)..">", ""), true end
  local sLn, isEOF, tAct, iID = "", false, metaActors.stack, (#metaActors.stack + 1) 
  while(not isEOF) do sLn, isEOF = common.GetLineFile(pF)
    if(sLn ~= "" and sLn:sub(1,1) ~= "#") then tAct[iID] = blocks.New():setKey(iID)
      local tCmp, bNew = common.StringExplode(sLn,"/"), tAct[iID]
      for I = 1, #actSt do local tPar = actSt[I]
        local tItm = common.StringExplode(common.StringTrim(tCmp[I]),";")
        for J = 1, #tItm do bNew[tPar[1]](bNew,tPar[2](tItm[J]))
         -- logStatus("levels.Read: "..tPar[1].." ("..J..") : "..tItm[J])
        end
        if(bLog) then bNew:Dump() end
      end; iID = (iID + 1)
    end
  end; return true
end

return level
