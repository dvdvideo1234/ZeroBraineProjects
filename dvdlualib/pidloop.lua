local type         = type
local tonumber     = tonumber
local tostring     = tostring
local setmetatable = setmetatable
local getSign      = getSignAnd
local math         = math
--[[
 * newControl: Class manages the maglev state processing
 * arPar > Parameter array {Kp, Ti, Td, satD, satU}
 * nTo   > Controller sampling time in seconds
]]
local metaControl = {}
      metaControl.__index = metaControl
      metaControl.__type  = "Control"
function newControl(nTo, sName)
  if((tonumber(nTo) or 0) <= 0) then
    return logStatus(nil, "newControl: Sampling time <"..tostring(nTo).."> invalid")
  end
  local self = {}
  local mTo  = tonumber(nTo)     -- Sampling time [s]
  local mSatD, mSatU             -- Saturation limits
  local mErrN, mErrO  = 0, 0     -- Error state values
  local mvCon, meInt  = 0, true  -- Control value and integral enabled
  local mvP, mvI, mvD = 0, 0, 0  -- Term values
  local mkP, mkI, mkD = 0, 0, 0  -- P, I and D term gains
  local mpP, mpI, mpD = 1, 1, 1  -- Raise the error to power of that much
  local mName, mType, mUser = (sName and tostring(sName) or "N/A"), "", {}

  setmetatable(self, metaControl)

  function self:getGains() return mkP, mkI, mkD end
  function self:setEnIntegral(bEn) meInt = tobool(bEn); return self end
  function self:getEnIntegral() return meInt end
  function self:getError() return mErrO, mErrN end
  function self:getControl(bNeg) return (bNeg and (-mvCon) or (mvCon)) end
  function self:getUser() return mUser end
  function self:getType() return mType end
  function self:getPeriod() return mTo end
  function self:setPower(pP, pI, pD)
    mpP, mpI, mpD = (tonumber(pP) or 0), (tonumber(pI) or 0), (tonumber(pD) or 0); return self end
  function self:setClamp(sD, sU) mSatD, mSatU = (tonumber(sD) or 0), (tonumber(sU) or 0); return self end

  function self:Reset()
    mErrN, mErrO  = 0, 0
    mvP, mvI, mvD = 0, 0, 0
    mvCon, meInt  = 0, true
    return self
  end

  function self:Process(vRef,vOut,bNeg)
    mErrO = mErrN
    mErrN = (bNeg and (vOut-vRef) or (vRef-vOut)) -- Refresh error state
    errS  = getSignAnd(mErrN)
    if(mkP > 0) then -- P-Term
      mvP = mkP * errS * math.abs(mErrN)^mpP end
    if((mkI > 0) and (mErrN ~= 0) and meInt) then -- I-Term
      mvI = mvI + mkI * errS * math.abs(mErrN + mErrO)^mpI end
    if((mkD > 0) and (mErrN ~= mErrO)) then -- D-Term
      mvD = mkD * errS * math.abs(mErrN - mErrO)^mpD end
    -- Control and saturation
    mvCon = mvP + mvI + mvD
    if(mSatD and mSatU) then
      if    (mvCon < mSatD) then mvCon, meInt = mSatD, false
      elseif(mvCon > mSatU) then mvCon, meInt = mSatU, false
      else meInt = true end
    end; return self
  end

  function self:Setup(arParam, bPOut)
    if(type(arParam) ~= "table") then
      return logStatus(nil,"newControl.Setup: Params table <"..type(arParam).."> invalid") end

    if(arParam[1] and (tonumber(arParam[1] or 0) > 0)) then
      mkP = (tonumber(arParam[1] or 0))
    else return logStatus(nil,"newControl.Setup: P-gain <"..tostring(arParam[1]).."> invalid") end

    if(arParam[2] and (tonumber(arParam[2] or 0) > 0)) then
      mkI = (mTo / (2 * (tonumber(arParam[2] or 0)))) -- Discrete integral approximation
      if(bPOut) then mkI = mkI * mkP end
    else logStatus(nil,"newControl.Setup: I-gain <"..tostring(arParam[2]).."> skipped") end

    if(arParam[3] and (tonumber(arParam[3] or 0) > 0)) then
      mkD = (tonumber(arParam[3] or 0) * mTo)  -- Discrete derivative approximation
      if(bPOut) then mkD = mkD * mkP end
    else logStatus(nil,"newControl.Setup: D-gain <"..tostring(arParam[3]).."> skipped") end

    if(arParam[4] and arParam[5] and ((tonumber(arParam[4]) or 0) < (tonumber(arParam[5]) or 0))) then
      mSatD, mSatU = (tonumber(arParam[4]) or 0), (tonumber(arParam[5]) or 0)
    else logStatus(nil,"newControl.Setup: Saturation skipped <"..tostring(arParam[4]).."<"..tostring(arParam[5]).."> skipped") end
    mType = ((mkP > 0) and "P" or "")..((mkI > 0) and "I" or "")..((mkD > 0) and "D" or "")
    for ID = 1, 5, 1 do mUser[ID] = arParam[ID] end; return self -- Init multiple states using the table
  end

  function self:Dump()
    local sType = ((mkP > 0) and "P" or "")..((mkI > 0) and "I" or "")..((mkD > 0) and "D" or "")
    if(sType ~= "") then sType = sType.."-" end
    logStatus(nil, "["..sType..metaControl.__type.."]["..tostring(self).."] with properties:")
    logStatus(nil, "  Name : "..mName.." ["..tostring(mTo).."]s")
    logStatus(nil, "  Gains: {P="..tostring(mkP)..", I="..tostring(mkI)..", D="..tostring(mkD).."}")
    logStatus(nil, "  Power: {P="..tostring(mpP)..", I="..tostring(mpI)..", D="..tostring(mpD).."}")
    if(mUser and type(mUser) == "table") then
      logStatus(nil, "  Param: {"..tostring(mUser[1])..", "..tostring(mUser[2])..", "
        ..tostring(mUser[3])..", "..tostring(mUser[4])..", "..tostring(mUser[5]).."}")
    end; return self
  end
  return self
end