local complex      = require("complex")
local colormap     = require("colormap")
local blocks       = require("blockBraker/blocks")
local common       = require("blockBraker/common")
local type         = type
local getmetatable = getmetatable
local level        = {}
local metaActors   = {}
metaActors.stack = {}
metaActors.garbage = 10
metaActors.curcoll = 0
      
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
  if(common.getType(oAct) == "blocks.block") then
    tAct[vKey] = oAct; return true
  end; return logStatus("level.addActor: Object wrong type", false)
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
  [5] = {"setStat"     , common.getBool},
  [6] = {"setHard"     , common.getBool},
  [7] = {"setLife"     , tonumber},
  [8] = {"setDrawColor", colormap.Convert}
}

function level.Read(sF, bLog)
  local pF, actSt = io.open("blockBraker/"..sF..".txt"), metaActors.store
  if(not pF) then return logStatus("levels.Read: No file <"..tostring(sF)..">", ""), true end
  local sLn, isEOF, tAct, iID = "", false, metaActors.stack, (#metaActors.stack + 1) 
  while(not isEOF) do sLn, isEOF = common.fgetLine(pF)
    if(sLn ~= "" and sLn:sub(1,1) ~= "#") then tAct[iID] = blocks.New()
      local tCmp, bNew = common.stringExplode(sLn,"/"), tAct[iID]
      for I = 1, #actSt do local tPar = actSt[I]
        local tItm = common.stringExplode(common.stringTrim(tCmp[I]),";")
        for J = 1, #tItm do bNew[tPar[1]](bNew,tPar[2](tItm[J]))
         -- logStatus("levels.Read: "..tPar[1].." ("..J..") : "..tItm[J])
        end
        if(bLog) then bNew:Dump() end
      end; iID = (iID + 1)
    end
  end; return true
end

return level
