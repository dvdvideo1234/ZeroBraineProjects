require("dvdlualib/gmodlib")

local registerType = function() end
local E2Lib = {}
E2Lib.RegisterExtension = function() end

----------------------------------------------------------------------------------------------------------------------------------------------

--[[ ******************************************************************************
 My custom flash sensor tracer type ( Based on wire rangers )
****************************************************************************** ]]--

local next = next
local Angle = Angle
local Vector = Vector
local tostring = tostring
local tonumber = tonumber
local LocalToWorld = LocalToWorld
local WorldToLocal = WorldToLocal
local bitBor = bit.bor
local mathAbs = math.abs
local mathSqrt = math.sqrt
local mathClamp = math.Clamp
local tableRemove = table.remove
local tableInsert = table.insert
local utilTraceLine = util.TraceLine
local utilGetSurfacePropName = util.GetSurfacePropName
local outError = error -- The function which generates error and prints it out
local outPrint = print -- The function that outputs a string into the console

-- Register the type up here before the extension registration so that the fsensor still works
registerType("fsensor", "xfs", nil,
  nil,
  nil,
  function(retval)
    if(retval == nil) then return end
    if(not istable(retval)) then outError("Return value is neither nil nor a table, but a "..type(retval).."!",0) end
  end,
  function(v)
    return (not istable(v)) or (not v.StartPos)
  end
)

--[[ ****************************************************************************** ]]

E2Lib.RegisterExtension("fsensor", true, "Lets E2 chips trace ray attachments and check for hits.")

local gsZeroStr   = "" -- Empty string to use instead of creating one everywhere
local gaZeroAng   = Angle() -- Dummy zero angle for transformations
local gvZeroVec   = Vector() -- Dummy zero vector for transformations
local gtStringMT  = getmetatable(gsZeroStr) -- Store the string metatable
local gtStoreOOP  = {} -- Store flash sensors here linked to the entity of the E2
local gnMaxBeam   = 50000 -- The tracer maximum length just about one cube map
local gtEmptyVar  = {["#empty"]=true}; gtEmptyVar[gsZeroStr] = true -- Variable being set to empty string
local gsVarPrefx  = "wire_expression2_fsensor" -- This is used for variable prefix
local gtBoolToNum = {[true]=1,[false]=0} -- This is used to convert between GLua boolean and wire boolean
local gtMethList  = {} -- Placeholder for blacklist and convar prefix
local gnServContr = bitBor(FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_PRINTABLEONLY)
local varMethSkip = CreateConVar(gsVarPrefx.."_skip", gsZeroStr, gnServContr, "E2 FSensor entity method black list")
local varMethOnly = CreateConVar(gsVarPrefx.."_only", gsZeroStr, gnServContr, "E2 FSensor entity method white list")
local varMaxTotal = CreateConVar(gsVarPrefx.."_max" , 30, gnServContr, "E2 FSensor maximum count")
local gsVNS, gsVNO = varMethSkip:GetName(), varMethOnly:GetName()

function isEntity(vE)
  return (vE and vE:IsValid())
end

function isHere(vV)
  return (vV ~= nil)
end

function getNorm(tV)
  local nN = 0; if(not isHere(tV)) then return nN end
  if(tonumber(tV)) then return math.abs(tV) end
  for ID = 1, 3 do local nV = tonumber(tV[ID]) or 0
    nN = nN + nV^2 end; return mathSqrt(nN)
end

function remValue(tSrc, aKey, bCall)
  tSrc[aKey] = nil; if(bCall) then collectgarbage() end
end

function logError(sMsg, ...)
  outError("E2:fsensor:"..tostring(sMsg)); return ...
end

function logStatus(sMsg, ...)
  outPrint("E2:fsensor:"..tostring(sMsg)); return ...
end

function convArrayKeys(tA)
  if(not tA) then return nil end
  if(not next(tA)) then return nil end
  local nE = #tA; for ID = 1, #tA do local key = tA[ID]
    if(not gtEmptyVar[key]) then
      tA[key] = true end; remValue(tA, ID)
  end; return ((tA and next(tA)) and tA or nil)
end

cvars.RemoveChangeCallback(gsVNS, gsVNS.."_call")
cvars.AddChangeCallback(gsVNS, function(sVar, vOld, vNew)
  gtMethList.SKIP = convArrayKeys(("/"):Explode(tostring(vNew or gsZeroStr)))
end, gsVNS.."_call")

cvars.RemoveChangeCallback(gsVNO, gsVNO.."_call")
cvars.AddChangeCallback(gsVNO, function(sVar, vOld, vNew)
  gtMethList.ONLY = convArrayKeys(("/"):Explode(tostring(vNew or gsZeroStr)))
end, gsVNO.."_call")

function getSensorsCount() local mC = 0
  for ent, con in pairs(gtStoreOOP) do mC = mC + #con end; return mC
end

function convDirLocal(oFSen, vE, vA)
  if(not oFSen) then return {0,0,0} end
  local oD, oE = oFSen.mDir, (vE or oFSen.mEnt)
  if(not (isEntity(oE) or vA)) then return {oD[1], oD[2], oD[3]} end
  local oV, oA = Vector(oD[1], oD[2], oD[3]), (vA and vA or oE:GetAngles())
  return {oV:Dot(oA:Forward()), -oV:Dot(oA:Right()), oV:Dot(oA:Up())}
end -- Gmod +Y is the left direction

function convDirWorld(oFSen, vE, vA)
  if(not oFSen) then return {0,0,0} end
  local oD, oE = oFSen.mDir, (vE or oFSen.mEnt)
  if(not (isEntity(oE) or vA)) then return {oD[1], oD[2], oD[3]} end
  local oV, oA = Vector(oD[1], oD[2], oD[3]), (vA and vA or oE:GetAngles())
  oV:Rotate(oA); return {oV[1], oV[2], oV[3]}
end

function convOrgEnt(oFSen, sF, vE)
  if(not oFSen) then return {0,0,0} end
  local oO, oE = oFSen.mPos, (vE or oFSen.mEnt)
  if(not isEntity(oE)) then return {oO[1], oO[2], oO[3]} end
  local oV = Vector(oO[1], oO[2], oO[3])
  oV:Set(oE[sF](oE, oV)); return {oV[1], oV[2], oV[3]}
end

function convOrgUCS(oFSen, sF, vP, vA)
  if(not oFSen) then return {0,0,0} end
  local oO, oE = oFSen.mPos, (vE or oFSen.mEnt)
  if(not isEntity(oE)) then return {oO[1], oO[2], oO[3]} end
  local oV, vN, aN = Vector(oO[1], oO[2], oO[3])
  if(sF == "LocalToWorld") then
    vN, aN = LocalToWorld(oV, gaZeroAng, vP, vA); oV:Set(vN)
  elseif(sF == "WorldToLocal") then
    vN, aN = WorldToLocal(oV, gaZeroAng, vP, vA); oV:Set(vN)
  end; return {oV[1], oV[2], oV[3]}
end

--[[ Returns the hit status based on filter parameters
 * oF > The filter to be checked
 * vK > Value key to be checked
 * Returns:
 * 1) The status of the filter (1,2,3)
 * 2) The value to return for the status
]] local vHit, vSkp, vNop = true, nil, nil
function getHitStatus(oF, vK)
  -- Skip current setting on empty data type
  if(not oF.TYPE) then return 1, vNop end
  local tO, tS = oF.ONLY, oF.SKIP
  if(tO and isHere(next(tO))) then if(tO[vK]) then
    return 3, vHit else return 2, vSkp end end
  if(tS and isHere(next(tS))) then if(tS[vK]) then
    return 2, vSkp else return 1, vNop end end
  return 1, vNop -- Check next setting on empty table
end

function newHitFilter(oFSen, oChip, sM)
  if(not oFSen) then return 0 end -- Check for available method
  if(sM:sub(1,3) ~= "Get" and sM:sub(1,2) ~= "Is" and sM ~= gsZeroStr) then
    return logError("Method <"..sM.."> disabled", 0) end
  local tO = gtMethList.ONLY; if(tO and isHere(next(tO)) and not tO[sM]) then
    return logError("Method <"..sM.."> use only", 0) end
  local tS = gtMethList.SKIP; if(tS and isHere(next(tS)) and tS[sM]) then
    return logError("Method <"..sM.."> use skip", 0) end
  if(not oChip.entity[sM]) then -- Check for available method
    return logError("Method <"..sM.."> mismatch", 0) end
  local tHit = oFSen.mHit; if(tHit.ID[sM]) then -- Check for available method
    return logError("Method <"..sM.."> exists", 0) end
  tHit.Size = (tHit.Size + 1); tHit[tHit.Size] = {CALL=sM}
  tHit.ID[sM] = tHit.Size; collectgarbage(); return (tHit.Size)
end

function remHitFilter(oFSen, sM)
  if(not oFSen) then return nil end
  local tHit = oFSen.mHit; tHit.Size = (tHit.Size - 1)
  tableRemove(tHit, tHit.ID[sM]); remValue(tHit.ID, sM); return oFSen
end

function setHitFilter(oFSen, oChip, sM, sO, vV, bS)
  if(not oFSen) then return nil end
  local tHit, sTyp = oFSen.mHit, type(vV) -- Obtain hit filter location
  local nID = tHit.ID[sM]; if(not isHere(nID)) then
    nID = newHitFilter(oFSen, oChip, sM)
  end -- Obtain the current data index
  local tID = tHit[nID]; if(not tID.TYPE) then tID.TYPE = type(vV) end
  if(tID.TYPE ~= sTyp) then -- Check the current data type and prevent the user from messing up
    return logError("Type "..sTyp.." mismatch <"..tID.TYPE.."@"..sM..">", oFSen) end
  if(not tID[sO]) then tID[sO] = {} end
  if(sM:sub(1,2) == "Is" and sTyp == "number") then
    tID[sO][((vV ~= 0) and 1 or 0)] = bS
  else tID[sO][vV] = bS end; collectgarbage(); return oFSen
end

function convHitValue(oEnt, sM) local vV = oEnt[sM](oEnt)
  if(sM:sub(1,2) == "Is") then vV = gtBoolToNum[vV] end; return vV
end

function remSensorEntity(eChip)
  if(not isEntity(eChip)) then return end
  local tSen = gtStoreOOP[eChip]; if(not tSen) then return end
  local mSen = #tSen; for ID = 1, mSen do tableRemove(tSen) end
  gtStoreOOP[eChip] = nil; collectgarbage() -- Preform table cleanup
  logStatus("Cleanup ["..tostring(mSen).."] items for "..tostring(eChip))
end

function trcLocal(oFSen, eB)
  if(not oFSen) then return nil end
  local eE = (eB and eB or oFSen.mEnt)
  if(not isEntity(eE)) then return oFSen end
  local eP, eA = eE:GetPos(), eE:GetAngles()
  local trS, trE = oFSen.mTrI.start, oFSen.mTrI.endpos
  trS:Set(oFSen.mPos); trS:Rotate(eA); trS:Add(eP)
  trE:Set(oFSen.mDir); trE:Rotate(eA); trE:Add(trS)
  -- http://wiki.garrysmod.com/page/util/TraceLine
  utilTraceLine(oFSen.mTrI); return oFSen
end

function trcWorld(oFSen)
  if(not oFSen) then return nil end
  local trS, trE = oFSen.mTrI.start, oFSen.mTrI.endpos
  trS:Set(oFSen.mPos); trE:Set(oFSen.mDir); trE:Add(trS)
  -- http://wiki.garrysmod.com/page/util/TraceLine
  utilTraceLine(oFSen.mTrI); return oFSen
end

function newItem(oSelf, vEnt, vPos, vDir, nLen)
  local eChip = oSelf.entity; if(not isEntity(eChip)) then
    return logError("Entity invalid", nil) end
  local nTot, nMax = getSensorsCount(), varMaxTotal:GetInt()
  if(nMax <= 0) then remSensorEntity(eChip)
    return logError("Limit invalid ["..tostring(nMax).."]", nil) end
  if(nTot >= nMax) then remSensorEntity(eChip)
    return logError("Count reached ["..tostring(nMax).."]", nil) end
  local oFSen, tSen = {}, gtStoreOOP[eChip]; oFSen.mSet, oFSen.mHit = eChip, {Size=0, ID={}};
  if(not tSen) then gtStoreOOP[eChip] = {}; tSen = gtStoreOOP[eChip] end
  if(isEntity(vEnt)) then oFSen.mEnt = vEnt -- Store attachment entity to manage local sampling
    oFSen.mHit.Ent = {SKIP={[vEnt]=true},ONLY={}} -- Store the base entity for ignore
  else oFSen.mHit.Ent, oFSen.mEnt = {SKIP={},ONLY={}}, nil end -- Make sure the entity is cleared
  -- Local tracer position the trace starts from
  oFSen.mPos, oFSen.mDir = Vector(), Vector()
  if(isHere(vPos)) then oFSen.mPos.x, oFSen.mPos.y, oFSen.mPos.z = vPos[1], vPos[2], vPos[3] end
  -- Local tracer direction to read the data of
  if(isHere(vDir)) then oFSen.mDir.x, oFSen.mDir.y, oFSen.mDir.z = vDir[1], vDir[2], vDir[3] end
  if(oFSen.mDir:Length() == 0) then logStatus("Direction zero <"..tostring(oFSen.mDir).."> !") end
  -- How long the flash sensor length will be. Must be positive
  oFSen.mLen = (tonumber(nLen) or 0)
  oFSen.mLen = (oFSen.mLen == 0 and getNorm(vDir) or oFSen.mLen)
  oFSen.mLen = mathClamp(oFSen.mLen,-gnMaxBeam,gnMaxBeam)
  -- Internal failsafe configurations
  oFSen.mDir:Normalize() -- Normalize the direction
  oFSen.mDir:Mul(oFSen.mLen) -- Multiply to add in real-time
  oFSen.mLen = mathAbs(oFSen.mLen) -- Length to absolute
  -- http://wiki.garrysmod.com/page/Structures/TraceResult
  oFSen.mTrO = {} -- Trace output parameters
  -- http://wiki.garrysmod.com/page/Structures/Trace
  oFSen.mTrI = { -- Trace input parameters
    mask = MASK_SOLID, -- Mask telling the trace what to hit
    start = Vector(), -- The start position of the trace
    output = oFSen.mTrO, -- Provide output place holder table
    endpos = Vector(), -- The end position of the trace
    filter = function(oEnt) local tHit, nS, vV = oFSen.mHit
      if(not isEntity(oEnt)) then return end
      nS, vV = getHitStatus(tHit.Ent, oEnt)
      if(nS > 1) then return vV end -- Entity found/skipped
      if(tHit.Size > 0) then
        for IH = 1, tHit.Size do local sFoo = tHit[IH].CALL
          nS, vV = getHitStatus(tHit[IH], convHitValue(oEnt, sFoo))
          if(nS > 1) then return vV end -- Option skipped/selected
        end -- All options are checked then trace hit notmally
      end; return true -- Finally we register the trace hit enabled
    end, ignoreworld = false, -- Should the trace ignore world or not
    collisiongroup = COLLISION_GROUP_NONE } -- Collision group control
  eChip:CallOnRemove("fsensor_remove_ent", remSensorEntity)
  tableInsert(tSen, oFSen); collectgarbage()
  
  function oFSen:addHitSkip( sM,  vN)
    local this, self = self, oSelf
    return setHitFilter(this, self, sM, "SKIP", vN, true)
  end

  function oFSen:remHitSkip( sM,  vN)
    return setHitFilter(this, self, sM, "SKIP", vN, nil)
  end
  
  return oFSen
end

----------------------------------------------------------------------------------------------------------------------------------------------

function getSet() return gtStoreOOP end
