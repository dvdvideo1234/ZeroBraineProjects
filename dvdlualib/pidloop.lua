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

local metaUnit = {}
      metaUnit.__index    = metaUnit
      metaUnit.__type     = "Unit"
      metaUnit.__tostring = function(oUnit) return "["..metaUnit.__type.."]" end
function newUnit(tNum, tDen)
  local mND  = #tDen
  local mNN  = #tNum
  if(mND <= mNN) then
    return logStatus(nil,"Unit physically impossible") end
  if(tDen[1] == 0) then
    return logStatus(nil,"Unit denominator invalid") end
       
  local self = {}
  local mSta, mDen, mNum = {}, {}, {}
  for iK = 1, mNN, 1 do mNum[iK] =    tNum[iK]            / tDen[1] end
  for iK = 1, mND, 1 do mSta[iK] = 0; mDen[iK] = tDen[iK] / tDen[1] end
    
  function getValue(bNeg)
    local tSrc = bNeg and mDen or mNum
    local nSgn = bNeg and -1   or 1
    local vOut = 0
    local iK   = (mND-1)
    while(iK > 0) do
      vOut = vOut + nSgn * mSta[iK] * (tSrc[iK] or 0)
      iK = iK - 1 -- Get next state
    end; return vOut
  end
    
  function putState(vX)
    local iK = mND
    while(iK > 0) do
      mSta[iK] = mSta[iK-1]
      iK = iK - 1 -- Get next state
    end; mSta[1] = vX
  end
    
  function self:getProcess(vU)
    local vU = (tonumber(vU) or 0)
    putState(vU - getValue(true)); return getValue(false)
  end
  return self
end

function newInterval(sName, nBL1, nBH1, nBL2, nBH2)
  local self = {}
  local mNam = tostring(sName or "")
  local mVal = (tonumber(nVal) or 0)
  local mBL1 = (tonumber(nBL1) or 0)
  local mBH1 = (tonumber(nBH1) or 0)
  local mBL2 = (tonumber(nBL2) or 0)
  local mBH2 = (tonumber(nBH2) or 0)
  
  function self:getName() return mNam end
  
  function self:getConv(nVal)
    if(nVal < mBL1 or mVal > mBH1) then
      return logStatus(nVal, "convInterval.valConv: Source value out of border") end
    local kf = ((nVal - mBL1) / (mBH1 - mBL1)); return (kf * (mBH2 - mBL2) + mBL2)
  end
  
  return self
end

function newTracer(sName)
  local self = {}
  local mName = tostring(sName or "")
  local mValO, mValN = 0, 0
  local mTimO, mTimN = 0, 0
  local mPntN = {x=0,y=0}
  local mPntO = {x=0,y=0}
  local mMatX, mMatY
  local enDraw = false
  
  function self:setInterval(oIntX, oIntY)
    mMatX, mMatY = oIntX, oIntY; return self end
  
  function self:getValue() return mTimN, mValN end
  function self:putValue(nTime, nVal)
    mValO, nValN = nValN, nVal
    mTimO, mTimN = mTimN, nTime
    mPntO.x, mPntO.y = mPntN.x, mPntN.y
    if(mMatX) then
      mPntN.x = mMatX:getConv(nTime)
    else
      mPntN.x = nTime
    end;
    if(mMatY) then
      mPntN.y = mMatY:getConv(nValN)
    else
      mPntN.y = nValN
    end; return self
  end
    
  function self:Draw(cCol)
    if(enDraw) then
      pncl(cCol);
      line(mPntO.x,mPntO.y,mPntN.x,mPntN.y)
      xyPlot(mPntN,cCol); updt()
    else enDraw = true end
  end

  return self
end
