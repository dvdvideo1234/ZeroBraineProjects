local registerType = function() end
local E2Lib = {}
E2Lib.RegisterExtension = function() end

----------------------------------------------------------------------------------------------------------------------------------------------

--[[ ******************************************************************************
 My custom state LQ-PID control type handling process variables
****************************************************************************** ]]--

local pairs = pairs
local tostring = tostring
local tonumber = tonumber
local bitBor = bit.bor
local mathAbs = math.abs
local mathModf = math.modf
local tableConcat = table.concat
local tableInsert = table.insert
local tableRemove = table.remove
local getTime = CurTime -- Using this as time benchmarking supporting game pause
local outError = error -- The function which generates error and prints it out
local outPrint = print -- The function that outputs a string into the console

-- Register the type up here before the extension registration so that the state control still works
registerType("stcontrol", "xsc", nil,
  nil,
  nil,
  function(retval)
    if(retval == nil) then return end
    if(not istable(retval)) then outError("Return value is neither nil nor a table, but a "..type(retval).."!",0) end
  end,
  function(v)
    return (not istable(v))
  end
)

--[[ ****************************************************************************** ]]

E2Lib.RegisterExtension("stcontrol", true, "Lets E2 chips have dedicated state control objects")

-- Client and server have independent value
local gnIndependentUsed = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
-- Server tells the client what value to use
local gnServerControled = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY, FCVAR_REPLICATED)

local gtComponent = {"P", "I", "D"} -- The names of each term. This is used for indexing and checking
local gsFormatPID = "(%s%s%s)" -- The general type format for the control power setup
local gtMissName  = {"Xx", "X", "Nr"} -- This is a place holder for missing/default type
local gsVarPrefx  = "wire_expression2_stcontrol" -- This is used for variable prefix
local varEnStatus = CreateConVar(gsVarPrefx.."_enst",  1, gnIndependentUsed, "Enables status output messages")
local varDefPrint = CreateConVar(gsVarPrefx.."_dprn", "TALK", gnServerControled, "FTracer default status output")
local gsDefPrint  = varDefPrint:GetString() -- Default print location
local gsFormLogs  = "E2{%s}{%s}:stcontrol: %s" -- Contains the logs format of the addon
local gtPrintName = {} -- Contains the print location specification
			gtPrintName["NOTIFY" ] = 1
			gtPrintName["CONSOLE"] = 2
			gtPrintName["TALK"   ] = 3
			gtPrintName["CENTER" ] = 4

local gsVDP = varDefPrint:GetName()
cvars.RemoveChangeCallback(gsVDP, gsVDP.."_call")
cvars.AddChangeCallback(gsVDP, function(sVar, vOld, vNew)
	local sK = tostring(vNew):upper(); if(gtPrintName[sK]) then gsDefPrint = sK end
end, gsVDP.."_call")

local function isValid(vE)
	return (vE and vE:IsValid())
end

local function getSign(nV)
	return ((nV > 0 and 1) or (nV < 0 and -1) or 0)
end

local function getValue(kV,eV,pV)
	return (kV*getSign(eV)*mathAbs(eV)^pV)
end

local function logStatus(sMsg, oSelf, nPos, ...)
	if(varEnStatus:GetBool()) then
		local nPos = tonumber(nPos) or gtPrintName[gsDefPrint]
		local oPly, oEnt = oSelf.player, oSelf.entity
		local sNam, sEID = oPly:Nick() , tostring(oEnt:EntIndex())
		local sTxt = gsFormLogs:format(sNam, sEID, tostring(sMsg))
		oPly:PrintMessage(nPos, sTxt:sub(1, 200))
	end; return ...
end

local function setGains(oStCon, oSelf, vP, vI, vD, bZ)
	if(not oStCon) then return logStatus("Object missing", oSelf, nil, nil) end
	local nP, nI = (tonumber(vP) or 0), (tonumber(vI) or 0)
	local nD, sT = (tonumber(vD) or 0), "" -- Store control type
	if(vP and ((nP > 0) or (bZ and nP >= 0))) then oStCon.mkP = nP end
	if(vI and ((nI > 0) or (bZ and nI >= 0))) then oStCon.mkI = (nI / 2)
		if(oStCon.mbCmb) then oStCon.mkI = oStCon.mkI * oStCon.mkP end
	end -- Available settings with non-zero coefficients
	if(vD and ((nD > 0) or (bZ and nD >= 0))) then oStCon.mkD = nD
		if(oStCon.mbCmb) then oStCon.mkD = oStCon.mkD * oStCon.mkP end
	end -- Build control type
	for key, val in pairs(gtComponent) do
		if(oStCon["mk"..val] > 0) then sT = sT..val end end
	if(sT:len() == 0) then sT = gtMissName[2]:rep(3) end -- Check for invalid control
	oStCon.mType[2] = sT; return oStCon
end

local function getCode(nN)
	local nW, nF = mathModf(nN, 1)
	if(nN == 1) then return gtMissName[3] end -- [Natural conventional][y=k*x]
	if(nN ==-1) then return "Rr" end -- [Reciprocal relation][y=1/k*x]
	if(nN == 0) then return "Sr" end -- [Sign function relay term][y=k*sign(x)]
	if(nF ~= 0) then
		if(nW ~= 0) then
			if(nF > 0) then return "Gs" end -- [Power positive fractional][y=x^( n); n> 1]
			if(nF < 0) then return "Gn" end -- [Power negative fractional][y=x^(-n); n<-1]
		else
			if(nF > 0) then return "Fs" end -- [Power positive fractional][y=x^( n); 0<n< 1]
			if(nF < 0) then return "Fn" end -- [Power negative fractional][y=x^(-n); 0>n>-1]
		end
	else
		if(nN > 0) then return "Ex" end -- [Exponential relation][y=x^n]
		if(nN < 0) then return "Er" end -- [Reciprocal-exp relation][y=1/x^n]
	end; return gtMissName[1] -- [Invalid settings][N/A]
end

local function setPower(oStCon, oSelf, vP, vI, vD)
	if(not oStCon) then return logStatus("Object missing", oSelf, nil, nil) end
	oStCon.mpP, oStCon.mpI, oStCon.mpD = (tonumber(vP) or 1), (tonumber(vI) or 1), (tonumber(vD) or 1)
	oStCon.mType[1] = gsFormatPID:format(getCode(oStCon.mpP), getCode(oStCon.mpI), getCode(oStCon.mpD))
	return oStCon
end

local function resState(oStCon, oSelf)
	if(not oStCon) then return logStatus("Object missing", oSelf, nil, nil) end
	oStCon.mErrO, oStCon.mErrN = 0, 0 -- Reset the error
	oStCon.mvCon, oStCon.meInt = 0, true -- Control value and integral enabled
	oStCon.mvP, oStCon.mvI, oStCon.mvD = 0, 0, 0 -- Term values
	oStCon.mTimN = getTime(); oStCon.mTimO = oStCon.mTimN; -- Update clock
	return oStCon
end

local function getType(oStCon)
	if(not oStCon) then local mP, mT = gtMissName[1], gtMissName[2]
		return (gsFormatPID:format(mP,mP,mP).."-"..mT:rep(3))
	end; return tableConcat(oStCon.mType, "-")
end

local function dumpItem(oStCon, oSelf, sNam, sPos)
  local sP = tostring(sPos or gsDefPrint)
  local nP = gtPrintName[sP] -- Print location setup
  if(not nP) then return oStCon end
  logStatus("Controller ["..tostring(sNam).."]["..tostring(oStCon.mnTo or gtMissName[2]).."]["..getType(oStCon).."]["..tostring(oStCon.mTimN).."]:", oSelf, nP)
  logStatus(" Manual mode enabled: ["..tostring(oStCon.mbMan).."]", oSelf, nP)
  logStatus("  Value: "..tostring(oStCon.mvMan), oSelf, nP)
  logStatus("   Bias: "..tostring(oStCon.mBias), oSelf, nP)
  logStatus(" Gains for terms:", oSelf, nP)
  for iD = 1, #gtComponent do local sC = gtComponent[iD]
    logStatus("      "..sC..": "..tostring(oStCon["mk"..sC]), oSelf, nP) end
  logStatus(" Power for terms:", oSelf, nP)
  for iD = 1, #gtComponent do local sC = gtComponent[iD]
    logStatus("      "..sC..": "..tostring(oStCon["mp"..sC]), oSelf, nP) end
  logStatus(" Control state value: ["..tostring(oStCon.mvCon).."]", oSelf, nP)
  for iD = 1, #gtComponent do local sC = gtComponent[iD]
    logStatus("      "..sC..": "..tostring(oStCon["mv"..sC]), oSelf, nP) end
  logStatus(" Saturation limits:", oSelf, nP)
  logStatus("    Max: "..tostring(oStCon.mSatU), oSelf, nP)
  logStatus("    Min: "..tostring(oStCon.mSatD), oSelf, nP)
  logStatus(" Time memory state:", oSelf, nP)
  logStatus("    New: "..tostring(oStCon.mTimN), oSelf, nP)
  logStatus("   Past: "..tostring(oStCon.mTimO), oSelf, nP)
  logStatus(" Error memory state:", oSelf, nP)
  logStatus("    New: "..tostring(oStCon.mErrN), oSelf, nP)
  logStatus("   Past: "..tostring(oStCon.mErrO), oSelf, nP)
  logStatus(" Control enable flag: ["..tostring(oStCon.mbOn).."]", oSelf, nP)
  logStatus("   BCmb: "..tostring(oStCon.mbCmb), oSelf, nP)
  logStatus("   BInv: "..tostring(oStCon.mbInv), oSelf, nP)
  logStatus("   EInt: "..tostring(oStCon.meInt), oSelf, nP)
  logStatus("   EDif: "..tostring(oStCon.meDif), oSelf, nP)
  logStatus("   EZcx: "..tostring(oStCon.meZcx), oSelf, nP)
  return oStCon -- The dump method
end

function newItem(oSelf, nTo)
  local eChip = oSelf.entity; if(not isValid(eChip)) then
    return logStatus("Entity invalid", oSelf, nil, nil) end
  local oStCon, sM = {}, gtMissName[3]; oStCon.mnTo = tonumber(nTo) -- Place to store the object
  if(oStCon.mnTo and oStCon.mnTo <= 0) then
    return logStatus("Delta mismatch ["..tostring(oStCon.mnTo).."]", oSelf, nil, nil) end
  local sType = gsFormatPID:format(sM, sM, sM) -- Error state values
  oStCon.mTimN = getTime(); oStCon.mTimO = oStCon.mTimN; -- Reset clock
  oStCon.mErrO, oStCon.mErrN, oStCon.mType = 0, 0, {sType, gtMissName[2]:rep(3)}
  oStCon.mvCon, oStCon.mTimB, oStCon.meInt, oStCon.meDif = 0, 0, true, true -- Control value and integral enabled
  oStCon.mBias, oStCon.mSatD, oStCon.mSatU = 0, nil, nil -- Saturation limits and settings
  oStCon.mvP, oStCon.mvI, oStCon.mvD = 0, 0, 0 -- Term values
  oStCon.mkP, oStCon.mkI, oStCon.mkD = 0, 0, 0 -- P, I and D term gains
  oStCon.mpP, oStCon.mpI, oStCon.mpD = 1, 1, 1 -- Raise the error to power of that much
  oStCon.mbCmb, oStCon.mbInv, oStCon.mbOn, oStCon.mbMan = false, false, false, false
  oStCon.mvMan, oStCon.mSet = 0, eChip -- Configure manual mode and store indexing

  
  function oStCon:dumpItem(nT, sN)
    local this, self = self, oSelf
    return dumpItem(this, self, sN, nT)
  end


  
  
  return oStCon
end

--[[
 * Tunes a controller using the Ziegler-Nichols method
 * When `bP` is true, then 3-parameter model is used
 * otherwise P-controller is hooked to the plant and uK, uT (no model)
 * are obrained from the output. The value `sM` is a additional
 * tunning option for a PID controller.
]]
function tuneZieglerNichols(oStCon, uK, uT, uL, sM, bP)
  if(not oStCon) then return logError("Object missing", nil) end
  local sM, sT = tostring(sM or "classic"), oStCon.mType[2]
  local uK, uT = (tonumber(uK) or 0), (tonumber(uT) or 0)
  if(bP) then if(uT <= 0 or uL <= 0) then return oStCon end
    if(sT == "P") then return setGains(oStCon, (uT/uL), 0, 0, true)
    elseif(sT == "PI") then return setGains(oStCon, (0.9*(uT/uL)), (0.3/uL), 0, true)
    elseif(sT == "PD") then return setGains(oStCon, (1.1*(uT/uL)), 0, (0.8/uL), true)
    elseif(sT == "PID") then return setGains(oStCon, (1.2*(uT/uL)), 1/(2*uL), 2/uL)
    else return logError("Type mismatch <"..sT..">", oStCon) end
  else if(uK <= 0 or uT <= 0) then return oStCon end
    if(sT == "P") then return setGains(oStCon, (0.5*uK), 0, 0, true)
    elseif(sT == "PI") then return setGains(oStCon, (0.45*uK), (1.2/uT), 0, true)
    elseif(sT == "PD") then return setGains(oStCon, (0.80*uK), 0, (uT/8), true)
    elseif(sT == "PID") then
      if(sM == "classic") then return setGains(oStCon, 0.60 * uK, 2.0 / uT, uT / 8.0)
      elseif(sM == "pessen" ) then return setGains(oStCon, (7*uK)/10, 5/(2*uT), (3*uT)/20)
      elseif(sM == "sovers") then return setGains(oStCon, (uK/3), (2/uT), (uT/3))
      elseif(sM == "novers") then return setGains(oStCon, (uK/5), (2/uT), (uT/3))
      else return logError("Method mismatch <"..sM..">", oStCon) end
    else return logError("Type mismatch <"..sT..">", oStCon) end
  end; return oStCon
end


--[[
 * Tunes a controller using the Choen-Coon method
 * Three parameter model: Gain nK, Time nT, Delay nL
]]
function tuneChoenCoon(oStCon, nK, nT, nL)
  if(not oStCon) then return logError("Object missing", nil) end
  if(nK <= 0 or nT <= 0 or nL <= 0) then return oStCon end
  local sT, mT = oStCon.mType[2], (nL/nT)
  if(sT == "P") then
    local kP = (1/(nK*mT))*(1+(1/3)*mT)
    return setGains(oStCon, kP, 0, 0, true)
  elseif(sT == "PI") then
    local kP = (1/(nK*mT))*(9/10+(1/12)*mT)
    local kI = 1/(nL*((30+3*mT)/(9+20*mT)))
    return setGains(oStCon, kP, kI, 0, true)
  elseif(sT == "PD") then
    local kP = (1/(nK*mT))*(5/4+(1/6)*mT)
    local kD = nL*((6-2*mT)/(22+3*mT))
    return setGains(oStCon, kP, 0, kD, true)
  elseif(sT == "PID") then
    local kP = (1/(nK*mT))*(4/3+(1/4)*mT)
    local kI = 1/(nL*((32+6*mT)/(13+8*mT)))
    local kD = nL*(4/(11+2*mT))
    return setGains(oStCon, kP, kI, kD)
  else return logError("Type mismatch <"..sT..">", oStCon) end
end

--[[
 * Tunes a controller using the Chien-Hrones-Reswick (CHR) method
 * Three parameter model: Gain nK, Time nT, Delay nL
 * The flag `bM` if enabled tuning is done for 20% overshot
 * The flag `bR` if enabled tuning is done for load rejection
 * else the tuning is done for set point tracking
]]
function tuneChienHronesReswick(oStCon, nK, nT, nL, bM, bR)
  if(not oStCon) then return logError("Object missing", nil) end
  if(nK <= 0 or nT <= 0 or nL <= 0) then return oStCon end
  local mA, sT = (nK * nL / nT), oStCon.mType[2]
  if(bR) then -- Load rejection
    if(bM) then -- Overshoot 20%
      if(sT == "P") then return setGains(oStCon, 0.7/mA, 0, 0, true)
      elseif(sT == "PI") then return setGains(oStCon, (0.7/mA), (1/(2.3*nT)), 0, true)
      elseif(sT == "PD") then return setGains(oStCon, (0.82/mA), 0, (0.5*uL), true)
      elseif(sT == "PID") then return setGains(oStCon, (1.2/mA), 1/(2*nT), 0.42*uL)
      else return logError("Type mismatch <"..sT..">", oStCon) end
    else
      if(sT == "P") then return setGains(oStCon, (0.3/mA), 0, 0, true)
      elseif(sT == "PI") then return setGains(oStCon, (0.6/mA), (1/(4*nT)), 0, true)
      elseif(sT == "PD") then return setGains(oStCon, (0.75/mA), 0, (0.5*uL), true)
      elseif(sT == "PID") then return setGains(oStCon, (0.95/mA), (1/(2.4*nT)), (0.42*uL))
      else return logError("Type mismatch <"..sT..">", oStCon) end
    end
  else -- Set point tracking
    if(bM) then -- Overshoot 20%
      if(sT == "P") then return setGains(oStCon, 0.7/mA, 0, 0, true)
      elseif(sT == "PI") then return setGains(oStCon, (0.6/mA), 1/nT, 0, true)
      elseif(sT == "PD") then return setGains(oStCon, (0.7/mA), 0, (0.45*uL), true)
      elseif(sT == "PID") then return setGains(oStCon, (0.95/mA), 1/(1.4*nT), 0.47*uL)
      else return logError("Type mismatch <"..sT..">", oStCon) end
    else
      if(sT == "P") then return setGains(oStCon, (0.3/mA), 0, 0, true)
      elseif(sT == "PI") then return setGains(oStCon, (0.35/mA), (1/(1.2*nT)), 0, true)
      elseif(sT == "PD") then return setGains(oStCon, (0.45/mA), 0, (0.45*uL), true)
      elseif(sT == "PID") then return setGains(oStCon, (0.6/mA), (1/nT), (0.5*uL))
      else return logError("Type mismatch <"..sT..">", oStCon) end
    end
  end
end

--[[
 * Tunes a controller using the Astrom-Hagglund method
 * Three parameter model: Gain nK, Time nT, Delay nL
]]
function tuneAstromHagglund(oStCon, nK, nT, nL)
  if(not oStCon) then return logError("Object missing", nil) end
  if(nK <= 0 or nT <= 0 or nL <= 0) then return oStCon end
  local kP = (1/nK)*(0.2+0.45*(nT/nL))
  local kI = 1/(((0.4*nL+0.8*nT)/(nL+0.1*nT))*nL)
  local kD = (0.5*nL*nT)/(0.3*nL+nT)
  return setGains(oStCon, kP, kI, kD)
end

--[[
 * Tunes a controller using the integrall error method
 * Three parameter model: Gain nK, Time nT, Delay nL
]]
local tIE ={
  ISE  = {
    PI  = {1.305, -0.959, 0.492, 0.739, 0    , 0    },
    PID = {1.495, -0.945, 1.101, 0.771, 0.560, 1.006}
  },
  IAE  = {
    PI  = {0.984, -0.986, 0.608, 0.707, 0    , 0    },
    PID = {1.435, -0.921, 0.878, 0.749, 0.482, 1.137}
  },
  ITAE = {
    PI  = {0.859, -0.977, 0.674, 0.680, 0    , 0    },
    PID = {1.357, -0.947, 0.842, 0.738, 0.381, 0.995}
  }
}
function tuneIE(oStCon, nK, nT, nL, sM)
  if(not oStCon) then return logError("Object missing", nil) end
  if(nK <= 0 or nT <= 0 or nL <= 0) then return oStCon end
  local sM, sT, tT = tostring(sM or "ISE"), oStCon.mType[2], nil
  tT = tIE[sM]; if(not isHere(tT)) then
    return logError("Mode mismatch <"..sM..">", oStCon) end
  tT = tT[sT]; if(not isHere(tT)) then
    return logError("Type mismatch <"..sT..">", oStCon) end
  local A, B, C, D, E, F = unpack(tT)
  local kP = (A*(nL/nT)^B)/nK
  local kI = 1/((nT/C)*(nL/nT)^D)
  local kD = nT*E*(nL/nT)^F
  return setGains(oStCon, kP, kI, kD)
end

----------------------------------------------------------------------------------------------------------------------------------------------

function getSet() return gtStoreOOP end

