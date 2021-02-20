--[[ ******************************************************************************
 My custom flash tracer tracer type ( Based on wire rangers )
****************************************************************************** ]]--

local next          = next
local type          = type
local pairs         = pairs
local error         = error
local Angle         = Angle
local Vector        = Vector
local istable       = istable
local tostring      = tostring
local tonumber      = tonumber
local CreateConVar  = CreateConVar
local LocalToWorld  = LocalToWorld
local WorldToLocal  = WorldToLocal
local bitBor        = bit and bit.bor
local mathAbs       = math and math.abs
local mathSqrt      = math and math.sqrt
local mathClamp     = math and math.Clamp
local tableEmpty    = table and table.Empty
local tableRemove   = table and table.remove
local tableInsert   = table and table.insert
local utilTraceLine = util and util.TraceLine
local utilGetSurfacePropName = util and util.GetSurfacePropName

-- Register the type up here before the extension registration so that the ftrace still works
registerType("ftrace", "xft", nil,
  nil,
  nil,
  function(retval)
    if(retval == nil) then return end
    if(not istable(retval)) then error("Return value is neither nil nor a table, but a "..type(retval).."!",0) end
  end,
  function(v)
    return (not istable(v)) or (not v.StartPos)
  end
)

--[[ **************************** CONFIGURATION **************************** ]]

E2Lib.RegisterExtension("ftrace", true, "Lets E2 chips trace ray attachments and check for hits.")

-- Client and server have independent value
local gnIndependentUsed = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
-- Server tells the client what value to use
local gnServerControled = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY, FCVAR_REPLICATED)

local gsVarName   = "" -- This stores current variable name
local gsCbcHash   = "_call" -- This keeps suffix realted to the file
local gvTransform = Vector() -- Temporary vector for transformation calculation
local gaTransform = Angle() -- Temporary angle for transformation calculation
local gsZeroStr   = "" -- Empty string to use instead of creating one everywhere
local gsFormHit   = " Hit: [%d]{%s} Entity" -- This stores the hit parameters dump format
local gsFormDump  = "  [%s] : {%s} > {%s}" -- The format used for dumping SKIP/ONLY interals
local gsNotAvStr  = "N/A" -- What to print when something is not available
local gaZeroAng   = Angle() -- Dummy zero angle for transformations
local gvZeroVec   = Vector() -- Dummy zero vector for transformations
local gnMaxBeam   = 50000 -- The tracer maximum length just about one cube map
local gtEmptyVar  = {["#empty"]=true}; gtEmptyVar[gsZeroStr] = true -- Variable being set to empty string
local gsVarPrefx  = "wire_expression2_ftrace" -- This is used for variable prefix
local gtBoolToNum = {[true]=1,[false]=0} -- This is used to convert between GLua boolean and wire boolean
local gtMethList  = {} -- Place holder for blacklist and convar prefix
local gtConvEnab  = {["LocalToWorld"] = LocalToWorld, ["WorldToLocal"] = WorldToLocal} -- Coordinate conversion list
local varMethSkip = CreateConVar(gsVarPrefx.."_skip", gsZeroStr, gnServerControled, "E2 FTrace entity black listed methods")
local varMethOnly = CreateConVar(gsVarPrefx.."_only", gsZeroStr, gnServerControled, "E2 FTrace entity white listed methods")
local varEnStatus = CreateConVar(gsVarPrefx.."_enst",  0, gnIndependentUsed, "Enables status output messages")
local varDefPrint = CreateConVar(gsVarPrefx.."_dprn", "TALK", gnServerControled, "FTrace default status output")
local gsFormLogs  = "E2{%s}{%s}:ftrace: %s" -- Contains the logs format of the addon
local gsDefPrint  = varDefPrint:GetString() -- Default print location
local gtPrintName = {} -- Contains the print location specification
      gtPrintName["NOTIFY" ] = HUD_PRINTNOTIFY
      gtPrintName["CONSOLE"] = HUD_PRINTCONSOLE
      gtPrintName["TALK"   ] = HUD_PRINTTALK
      gtPrintName["CENTER" ] = HUD_PRINTCENTER

--[[ **************************** PRIMITIVES **************************** ]]

local function isValid(vE)
  return (vE and vE:IsValid())
end

local function formDump(sS, sM, sV)
  return gsFormDump:format(sS, sM, tostring(sV))
end

local function formType(iD, sT)
  return gsFormHit:format(iD, tostring(sT))
end

local function getNorm(tV)
  local nN = 0; if(not tV) then return nN end
  if(tonumber(tV)) then return mathAbs(tV) end
  for ID = 1, 3 do local nV = tonumber(tV[ID]) or 0
    nN = nN + nV^2 end; return mathSqrt(nN)
end

local function logStatus(sMsg, oSelf, nPos, ...)
  if(varEnStatus:GetBool()) then
    local nPos = (tonumber(nPos) or gtPrintName[gsDefPrint])
    local oPly, oEnt = oSelf.player, oSelf.entity
    local sNam, sEID = oPly:Nick() , tostring(oEnt:EntIndex())
    local sTxt = gsFormLogs:format(sNam, sEID, tostring(sMsg))
    oPly:PrintMessage(nPos, sTxt:sub(1, 200))
  end; return ...
end

local function convArrayKeys(tA)
  if(not tA) then return nil end
  if(not next(tA)) then return nil end
  for ID = 1, #tA do
    local key = tostring(tA[ID] or ""):gsub("%s+", "")
    if(not gtEmptyVar[key]) then
      tA[key] = true end; tA[ID] = nil
  end; return ((tA and next(tA)) and tA or nil)
end

--[[ **************************** CALLBACKS **************************** ]]

gsVarName = varMethSkip:GetName()
cvars.RemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvars.AddChangeCallback(gsVarName, function(sVar, vOld, vNew)
  gtMethList.SKIP = convArrayKeys(("/"):Explode(tostring(vNew or gsZeroStr)))
end, gsVarName..gsCbcHash)

gsVarName = varMethOnly:GetName()
cvars.RemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvars.AddChangeCallback(gsVarName, function(sVar, vOld, vNew)
  gtMethList.ONLY = convArrayKeys(("/"):Explode(tostring(vNew or gsZeroStr)))
end, gsVarName..gsCbcHash)

gsVarName = varDefPrint:GetName()
cvars.RemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvars.AddChangeCallback(gsVarName, function(sVar, vOld, vNew)
  local sK = tostring(vNew):upper(); if(gtPrintName[sK]) then gsDefPrint = sK end
end, gsVarName..gsCbcHash)

--[[ **************************** WRAPPERS **************************** ]]

local function convDirLocal(oFTrc, vE, vA)
  if(not oFTrc) then return {0,0,0} end
  local oD, oE = oFTrc.mDir, (vE or oFTrc.mEnt)
  if(not (isValid(oE) or vA)) then return {oD[1], oD[2], oD[3]} end
  local oV, oA = Vector(oD[1], oD[2], oD[3]), (vA and vA or oE:GetAngles())
  return {oV:Dot(oA:Forward()), -oV:Dot(oA:Right()), oV:Dot(oA:Up())}
end -- Gmod +Y is the left direction

local function convDirWorld(oFTrc, vE, vA)
  if(not oFTrc) then return {0,0,0} end
  local oD, oE = oFTrc.mDir, (vE or oFTrc.mEnt)
  if(not (isValid(oE) or vA)) then return {oD[1], oD[2], oD[3]} end
  local oV, oA = Vector(oD[1], oD[2], oD[3]), (vA and vA or oE:GetAngles())
  oV:Rotate(oA); return {oV[1], oV[2], oV[3]}
end

local function convOrgEnt(oFTrc, sF, vE)
  if(not oFTrc) then return {0,0,0} end
  if(not gtConvEnab[sF or gsZeroStr]) then return {0,0,0} end
  local oO, oE = oFTrc.mPos, (vE or oFTrc.mEnt)
  if(not isValid(oE)) then return {oO[1], oO[2], oO[3]} end
  local oV = Vector(oO[1], oO[2], oO[3])
  oV:Set(oE[sF](oE, oV)); return {oV[1], oV[2], oV[3]}
end

local function convOrgUCS(oFTrc, sF, vP, vA)
  if(not oFTrc) then return {0,0,0} end
  if(not gtConvEnab[sF or gsZeroStr]) then return {0,0,0} end
  local oO, oE = oFTrc.mPos, (vE or oFTrc.mEnt)
  if(not isValid(oE)) then return {oO[1], oO[2], oO[3]} end
  local oV, vN, aN = Vector(oO[1], oO[2], oO[3])
  vN, aN = gtConvEnab[sF](oV, gaZeroAng, vP, vA); oV:Set(vN)
  return {oV[1], oV[2], oV[3]}
end

local function vectorMul(vV, nX, nY, nZ)
  vV.x, vV.y, vV.z = (vV.x * nX), (vV.y * nY), (vV.z * nZ)
  return vV -- returned the first argument scaled vector
end

local function vectorDiv(vV, nX, nY, nZ)
  vV.x, vV.y, vV.z = (vV.x / nX), (vV.y / nY), (vV.z / nZ)
  return vV -- returned the first argument scaled vector
end

--[[ Returns the hit status based on filter parameters
 * oF > The filter to be checked
 * vK > Value key to be checked
 * Returns:
 * 1) The status of the filter (1,2,3)
 * 2) The value to return for the status
]] local vHit, vSkp, vNop = true, nil, nil
local function getHitStatus(oF, vK)
  -- Skip current setting on empty data type
  if(not oF.TYPE) then return 1, vNop end
  local tO, tS = oF.ONLY, oF.SKIP
  if(tO and next(tO)) then if(tO[vK]) then
    return 3, vHit else return 2, vSkp end end
  if(tS and next(tS)) then if(tS[vK]) then
    return 2, vSkp else return 1, vNop end end
  return 1, vNop -- Check next setting on empty table
end

local function newHitFilter(oFTrc, oSelf, sM)
  if(not oFTrc) then return 0 end -- Check for available method
  if(sM:sub(1,3) ~= "Get" and sM:sub(1,2) ~= "Is" and sM ~= gsZeroStr) then
    return logStatus("Method <"..sM.."> disabled", oSelf, nil, 0) end
  local tHit = oFTrc.mHit; if(tHit.ID[sM]) then -- Check for available method
    return logStatus("Method <"..sM.."> exists", oSelf, nil, 0) end
  if(not oSelf.entity[sM]) then -- Check for available method
    return logStatus("Method <"..sM.."> mismatch", oSelf, nil, 0) end
  local tO = gtMethList.ONLY; if(tO and next(tO) and not tO[sM]) then
    return logStatus("Method <"..sM.."> use only", oSelf, nil, 0) end
  local tS = gtMethList.SKIP; if(tS and next(tS) and tS[sM]) then
    return logStatus("Method <"..sM.."> use skip", oSelf, nil, 0) end
  tHit.Size = (tHit.Size + 1); tHit[tHit.Size] = {CALL = sM}
  tHit.ID[sM] = tHit.Size; return (tHit.Size)
end

local function remHitFilter(oFTrc, sM)
  if(not oFTrc) then return nil end
  local tHit = oFTrc.mHit; if(not tHit) then return oFTrc end
  local ID = tHit.ID[sM]; if(not ID) then return oFTrc end
  tHit.Size = (tHit.Size - 1); tableRemove(tHit, ID)
  for IH = 1, tHit.Size do local HM = tHit[IH].CALL
    tHit.ID[HM] = IH end; tHit.ID[sM] = nil; return oFTrc
end

function setHitFilter(oFTrc, oSelf, sM, sO, vV, bS)
  if(not oFTrc) then return nil end
  local tHit, sTyp = oFTrc.mHit, type(vV) -- Obtain hit filter location
  local nID = tHit.ID[sM]; if(not nID) then
    nID = newHitFilter(oFTrc, oSelf, sM)
  end -- Obtain the current data index
  local tID = tHit[nID]; if(not tID) then -- Check the current data type and prevent the user from messing up
    return logStatus("ID mismatch <"..nID.."@"..sM..">", oSelf, nil, oFTrc) end
  if(not tID.TYPE) then tID.TYPE = type(vV) end
  if(tID.TYPE ~= sTyp) then -- Check the current data type and prevent the user from messing up
    return logStatus("Type "..sTyp.." mismatch <"..tID.TYPE.."@"..sM..">", oSelf, nil, oFTrc) end
  if(not tID[sO]) then tID[sO] = {} end
  if(sM:sub(1,2) == "Is" and sTyp == "number") then
    tID[sO][((vV ~= 0) and 1 or 0)] = bS
  else tID[sO][vV] = bS end; return oFTrc
end

local function convHitValue(oEnt, sM) local vV = oEnt[sM](oEnt)
  if(sM:sub(1,2) == "Is") then vV = gtBoolToNum[vV] end; return vV
end

local function trcLocal(oFTrc, eB, vP, vA)
  if(not oFTrc) then return nil end
  local eE = (eB and eB or oFTrc.mEnt)
  local eP, eA = gvTransform, gaTransform
  if(isValid(eE)) then eP:Set(eE:GetPos()); eA:Set(eE:GetAngles()) end
  if(vP) then eP.x, eP.y, eP.z = vP[1], vP[2], vP[3] end
  if(vA) then eA.p, eA.y, eA.r = vA[1], vA[2], vA[3] end
  local trS, trE = oFTrc.mTrI.start, oFTrc.mTrI.endpos
  trS:Set(oFTrc.mPos); trS:Rotate(eA); trS:Add(eP)
  trE:Set(oFTrc.mDir); trE:Rotate(eA); trE:Add(trS)
  -- http://wiki.garrysmod.com/page/util/TraceLine
  utilTraceLine(oFTrc.mTrI); return oFTrc
end

local function trcWorld(oFTrc, eE, vP, vA)
  if(not oFTrc) then return nil end
  local eP, eA = gvTransform, gaTransform
  eP:Set(oFTrc.mPos); eA:Set(oFTrc.mDir:Angle())
  if(isValid(eE)) then eP:Set(eE:GetPos()); eA:Set(eE:GetAngles()) end
  if(vP) then eP.x, eP.y, eP.z = vP[1], vP[2], vP[3] end
  if(vA) then eA.p, eA.y, eA.r = vA[1], vA[2], vA[3] end
  local trS, trE = oFTrc.mTrI.start, oFTrc.mTrI.endpos
  trS:Set(eP); trE:Set(eA:Forward()); trE:Add(trS)
  -- http://wiki.garrysmod.com/page/util/TraceLine
  utilTraceLine(oFTrc.mTrI); return oFTrc
end

local function dumpItem(oFTrc, oSelf, sNam, sPos)
  local sP = tostring(sPos or gsDefPrint)
  local nP = gtPrintName[sP] -- Print location setup
  if(not nP) then return oFTrc end
  logStatus("["..tostring(sNam or gsNotAvStr).."] Data:", oSelf, nP)
  logStatus(" Len: "..tostring(oFTrc.mLen or gsNotAvStr), oSelf, nP)
  logStatus(" Pos: "..tostring(oFTrc.mPos or gsNotAvStr), oSelf, nP)
  logStatus(" Dir: "..tostring(oFTrc.mDir or gsNotAvStr), oSelf, nP)
  logStatus(" Ent: "..tostring(oFTrc.mEnt or gsNotAvStr), oSelf, nP)
  logStatus(" E2 : "..tostring(oFTrc.mSet or gsNotAvStr), oSelf, nP)
  local tHit = oFTrc.mHit -- Read the general hit list
  local tEnt = tHit.Ent   -- Read the direct hit entities list
  local tS, tO = tEnt.SKIP, tEnt.ONLY -- Read entity skip and only list
  logStatus(formType(0, tEnt.TYPE), oSelf, nP)
  if(tS and next(tS)) then for kS, vS in pairs(tS) do logStatus(formDump("SKIP", kS, vS), oSelf, nP) end end
  if(tO and next(tO)) then for kO, vO in pairs(tO) do logStatus(formDump("ONLY", kO, vO), oSelf, nP) end end
  local nSz = tHit.Size; if(nSz <= 0) then return oFTrc end
  for iH = 1, nSz do local tID = tHit[iH]; tS, tO = tID.SKIP, tID.ONLY
    logStatus(formType(iH, tID.TYPE)..":"..tostring(tID.CALL or gsNotAvStr), oSelf, nP)
    if(tS) then for kS, vS in pairs(tS) do logStatus(formDump("SKIP", kS, vS), oSelf, nP) end end
    if(tO) then for kO, vO in pairs(tO) do logStatus(formDump("ONLY", kO, vO), oSelf, nP) end end
  end; return oFTrc -- The dump method returns a pointer to the current instance
end

function newItem(oSelf, vEnt, vPos, vDir, nLen)
  local eChip = oSelf.entity; if(not isValid(eChip)) then
    return logStatus("Entity invalid", oSelf, nil, nil) end
  local oFTrc = {}; oFTrc.mSet, oFTrc.mHit = eChip, {Size = 0, ID = {}};
  oFTrc.mHit.Ent = {SKIP = {}, ONLY = {}, TYPE = type(eChip)} -- No entities in ONLY or SKIP by default
  if(isValid(vEnt)) then oFTrc.mEnt = vEnt else oFTrc.mEnt = nil end -- Make sure the entity is cleared
  -- Local tracer position the trace starts from
  oFTrc.mPos, oFTrc.mDir = Vector(), Vector()
  if(vPos) then oFTrc.mPos.x, oFTrc.mPos.y, oFTrc.mPos.z = vPos[1], vPos[2], vPos[3] end
  -- Local tracer direction to read the data of
  if(vDir) then oFTrc.mDir.x, oFTrc.mDir.y, oFTrc.mDir.z = vDir[1], vDir[2], vDir[3] end
  -- How long the flash tracer length will be. Must be positive
  oFTrc.mLen = (tonumber(nLen) or 0)
  oFTrc.mLen = (oFTrc.mLen == 0 and getNorm(vDir) or oFTrc.mLen)
  oFTrc.mLen = mathClamp(oFTrc.mLen,-gnMaxBeam,gnMaxBeam)
  -- Internal failsafe configurations
  oFTrc.mDir:Normalize() -- Normalize the direction
  oFTrc.mDir:Mul(oFTrc.mLen) -- Multiply to add in real-time
  oFTrc.mLen = mathAbs(oFTrc.mLen) -- Length to absolute
  -- http://wiki.garrysmod.com/page/Structures/TraceResult
  oFTrc.mTrO = {} -- Trace output parameters
  -- http://wiki.garrysmod.com/page/Structures/Trace
  oFTrc.mTrI = { -- Trace input parameters
    mask = MASK_SOLID, -- Mask telling the trace what to hit
    start = Vector(), -- The start position of the trace
    output = oFTrc.mTrO, -- Provide output place holder table
    endpos = Vector(), -- The end position of the trace
    filter = function(oEnt) local tHit, nS, vV = oFTrc.mHit
      if(not isValid(oEnt)) then return end
      nS, vV = getHitStatus(tHit.Ent, oEnt)
      if(nS > 1) then return vV end -- Entity found/skipped
      if(tHit.Size > 0) then
        for IH = 1, tHit.Size do local sFoo = tHit[IH].CALL
          nS, vV = getHitStatus(tHit[IH], convHitValue(oEnt, sFoo))
          if(nS > 1) then return vV end -- Option skipped/selected
        end -- All options are checked then trace hit normally
      end; return true -- Finally we register the trace hit enabled
    end, ignoreworld = false, -- Should the trace ignore world or not
    collisiongroup = COLLISION_GROUP_NONE } -- Collision group control


  function oFTrc:addHitSkip( sM,  vN)
    local this, self = self, oSelf
    return setHitFilter(this, self, sM, "SKIP", vN, true)
  end

  function oFTrc:remHitSkip( sM,  vN)
    local this, self = self, oSelf
    return setHitFilter(this, self, sM, "SKIP", vN, nil)
  end
       
  function oFTrc:setAttachEntity(eE)
    local this, self = self, oSelf
    if(not this) then return nil end
    if(not isValid(eE)) then return this end
    this.mEnt = eE; return this
  end
  
  function oFTrc:addHitOnly(sM, vN)
    local this, self = self, oSelf
    return setHitFilter(this, self, sM, "ONLY", vN, true)
  end
  
  function oFTrc:dumpItem(nT, sN)
    local this, self = self, oSelf
    return dumpItem(this, self, sN, nT)
  end

  function oFTrc:remHit(sM)
    local this, self = self, oSelf
    return remHitFilter(this, sM)
  end
    
  function oFTrc:smpLocal()
    local this, self = self, oSelf
    return trcLocal(this, nil, nil, nil)
  end
  
  function oFTrc:addEntHitSkip(vE)
    local this, self = self, oSelf
    if(not this) then return nil end
    if(not isValid(vE)) then return nil end
    this.mHit.Ent.SKIP[vE] = true; return this
  end
  
  function oFTrc:addEntHitOnly(vE)
    local this, self = self, oSelf
    if(not this) then return nil end
    if(not isValid(vE)) then return nil end
    this.mHit.Ent.ONLY[vE] = true; return this
  end
  
  function oFTrc:getChip()
    local this, self = self, oSelf
    if(not this) then return nil end; local vE = this.mSet
    if(not isValid(vE)) then return nil end; return vE
  end
  
  function oFTrc:rayAim(nX, nY, nZ)
    local this, self = self, oSelf
    if(not this) then return nil end
    local vD = Vector(nX, nY, nZ)
    vD:Sub(this.mPos); vD:Normalize()
    vD:Mul(this.mLen); this.mDir:Set(vD)
    return this
  end
  
  return oFTrc
end

----------------------------------------------------------------------------------------------------------------------------------------------

function getSet() return gtStoreOOP end
function getMethList() return gtMethList end