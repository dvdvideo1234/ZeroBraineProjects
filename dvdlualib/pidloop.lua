local type         = type
local tonumber     = tonumber
local tostring     = tostring
local setmetatable = setmetatable
local getSign      = getSignAnd
local math         = math
local tobool       = function(bV) return (bV and true or false) end

--[[
 * newInterval: Class that maps one interval onto another
 * sName > A porper name to be identified as
 * nL1   > Lower  value first border
 * nH1   > Higher value first border
 * nL2   > Lower  value second border
 * nH2   > Higher value second border
]]--
function newInterval(sName, nL1, nH1, nL2, nH2)
  local self = {}
  local mNam = tostring(sName or "")
  local mVal = (tonumber(nVal) or 0)
  local mL1  = (tonumber(nL1) or 0)
  local mH1  = (tonumber(nH1) or 0)
  local mL2  = (tonumber(nL2) or 0)
  local mH2  = (tonumber(nH2) or 0)
  
  function self:getName() return mNam end
  
  function self:getConv(nVal)
    if(nVal < mL1 or mVal > mH1) then
      return logStatus(nVal, "convInterval.valConv: Source value <"..tostring(nVal).."> out of border") end
    local kf = ((nVal - mL1) / (mH1 - mL1)); return (kf * (mH2 - mL2) + mL2)
  end
  
  return self
end

--[[
 * newTracer: Class that plots a process variable
 * sName > A porper name to be identified as
]]--
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

--[[
* newControl: Class maglev state processing manager
* nTo   > Controller sampling time in seconds
* arPar > Parameter array {Kp, Ti, Td, satD, satU}
]]
local metaControl = {}
      metaControl.__index = metaControl
      metaControl.__type  = "Control"
function newControl(nTo, sName)
  local mTo = (tonumber(nTo) or 0); if(mTo <= 0) then -- Sampling time [s]
    return logStatus(nil, "newControl: Sampling time <"..tostring(nTo).."> invalid") end
  local self  = {}                 -- Place to store the methods
  local mfAbs = math and math.abs  -- Function used for error absolute
  local mfSgn = getSign            -- Function used for error sign
  local mErrO, mErrN  = 0, 0       -- Error state values
  local mvCon, meInt  = 0, true    -- Control value and integral enabled
  local mvP, mvI, mvD = 0, 0, 0    -- Term values
  local mkP, mkI, mkD = 0, 0, 0    -- P, I and D term gains
  local mpP, mpI, mpD = 1, 1, 1    -- Raise the error to power of that much
  local mbCmb, mbInv, mSatD, mSatU = true, false -- Saturation limits and settings
  local mName, mType, mUser = (sName and tostring(sName) or "N/A"), "", {}

  setmetatable(self, metaControl)

  local function getTerm(kV,eV,pV) return (kV*mfSgn(eV)*mfAbs(eV)^pV) end

  function self:getGains() return mkP, mkI, mkD end
  function self:setEnIntegral(bEn) meInt = tobool(bEn); return self end
  function self:getEnIntegral() return meInt end
  function self:getError() return mErrO, mErrN end
  function self:getControl() return mvCon end
  function self:getUser() return mUser end
  function self:getType() return mType end
  function self:getPeriod() return mTo end
  function self:setPower(pP, pI, pD)
    mpP, mpI, mpD = (tonumber(pP) or 0), (tonumber(pI) or 0), (tonumber(pD) or 0); return self end
  function self:setClamp(sD, sU) mSatD, mSatU = (tonumber(sD) or 0), (tonumber(sU) or 0); return self end
  function self:setStruct(bCmb, bInv) mbCmb, mbInv = tobool(bCmb), tobool(bInv); return self end

  function self:Reset()
    mErrO, mErrN  = 0, 0
    mvP, mvI, mvD = 0, 0, 0
    mvCon, meInt  = 0, true
    return self
  end

  function self:Process(vRef,vOut)
    mErrO = mErrN -- Refresh error state sample
    mErrN = (mbInv and (vOut-vRef) or (vRef-vOut))
    if(mkP > 0) then -- P-Term
      mvP = getTerm(mkP, mErrN, mpP) end
    if((mkI > 0) and (mErrN ~= 0) and meInt) then -- I-Term
      mvI = getTerm(mkI, mErrN + mErrO, mpI) + mvI end
    if((mkD > 0) and (mErrN ~= mErrO)) then -- D-Term
      mvD = getTerm(mkD, mErrN - mErrO, mpD) end
    mvCon = mvP + mvI + mvD  -- Calculate the control signal
    if(mSatD and mSatU) then -- Apply anti-windup effect
      if    (mvCon < mSatD) then mvCon, meInt = mSatD, false
      elseif(mvCon > mSatU) then mvCon, meInt = mSatU, false
      else meInt = true end
    end; return self
  end

  function self:Setup(arParam)
    if(type(arParam) ~= "table") then
      return logStatus(nil,"newControl.Setup: Params table <"..type(arParam).."> invalid") end

    if(arParam[1] and (tonumber(arParam[1] or 0) > 0)) then
      mkP = (tonumber(arParam[1] or 0))
    else return logStatus(nil,"newControl.Setup: P-gain <"..tostring(arParam[1]).."> invalid") end

    if(arParam[2] and (tonumber(arParam[2] or 0) > 0)) then
      mkI = (mTo / (2 * (tonumber(arParam[2] or 0)))) -- Discrete integral approximation
      if(mbCmb) then mkI = mkI * mkP end
    else logStatus(nil,"newControl.Setup: I-gain <"..tostring(arParam[2]).."> skipped") end

    if(arParam[3] and (tonumber(arParam[3] or 0) > 0)) then
      mkD = (tonumber(arParam[3] or 0) * mTo)  -- Discrete derivative approximation
      if(mbCmb) then mkD = mkD * mkP end
    else logStatus(nil,"newControl.Setup: D-gain <"..tostring(arParam[3]).."> skipped") end

    if(arParam[4] and arParam[5] and ((tonumber(arParam[4]) or 0) < (tonumber(arParam[5]) or 0))) then
      mSatD, mSatU = (tonumber(arParam[4]) or 0), (tonumber(arParam[5]) or 0)
    else logStatus(nil,"newControl.Setup: Saturation skipped <"..tostring(arParam[4]).."<"..tostring(arParam[5]).."> skipped") end
    mType = ((mkP > 0) and "P" or "")..((mkI > 0) and "I" or "")..((mkD > 0) and "D" or "")
    for ID = 1, 5, 1 do mUser[ID] = arParam[ID] end; return self -- Init multiple states using the table
  end

  function self:Mul(nMul)
    local nMul = (tonumber(nMul) or 0)
    if(nMul <= 0) then return self end
    for ID = 1, 5, 1 do mUser[ID] = mUser[ID] * nMul end
    self:Setup(mUser); return self -- Init multiple states using the table
  end

  function self:Dump()
    local sType = (mType ~= "") and (mType.."-") or mType
    logStatus(nil, "["..sType..metaControl.__type.."] Properties:")
    logStatus(nil, "  Name : "..mName.." ["..tostring(mTo).."]s")
    logStatus(nil, "  Param: {"..tostring(mUser[1])..", "..tostring(mUser[2])..", "
     ..tostring(mUser[3])..", "..tostring(mUser[4])..", "..tostring(mUser[5]).."}")
    logStatus(nil, "  Gains: {P="..tostring(mkP)..", I="..tostring(mkI)..", D="..tostring(mkD).."}")
    logStatus(nil, "  Power: {P="..tostring(mpP)..", I="..tostring(mpI)..", D="..tostring(mpD).."}\n")
    logStatus(nil, "  Limit: {D="..tostring(mSatD)..",U="..tostring(mSatU).."}")
    logStatus(nil, "  Error: {"..tostring(mErrO)..", "..tostring(mErrN).."}")
    logStatus(nil, "  Value: ["..tostring(mvCon).."] {P="..tostring(mvP)..", I="..tostring(mvI)..", D="..tostring(mvD).."}")
    return self
  end; return self
end

-- https://www.mathworks.com/help/simulink/slref/discretefilter.html
local metaUnit = {}
      metaUnit.__index    = metaUnit
      metaUnit.__type     = "Unit"
      metaUnit.__tostring = function(oUnit) return "["..metaUnit.__type.."]" end
function newUnit(nTo, tNum, tDen, sName)
  local mOrd = #tDen
  if(mOrd < #tNum) then
    return logStatus(nil, "Unit physically impossible") end
  if(tDen[1] == 0) then
    return logStatus(nil, "Unit denominator invalid") end
    
  local self  = {}
  local mTo   = tDen[1] -- Store (1/ao)
  local mName, mOut = sName, nil
  local mSta, mDen, mNum = {}, {}, {}
  
  for ik = 1, mOrd , 1 do mSta[ik] = 0 end
  for iK = 1, mOrd , 1 do mDen[iK] = (tonumber(tDen[iK]) or 0) / mTo end
  for iK = 1, #tNum, 1 do mNum[iK] = (tonumber(tNum[iK]) or 0) / mTo end; arExtend(mNum,-mOrd)
  
  mTo = nTo -- Refresh the sampling time
  
  function self:getOutput() return mOut end
  
  local function getBeta()
    local vOut, iK = 0, mOrd
    while(iK > 0) do
      vOut = vOut + mSta[iK] * (mNum[iK] or 0)
      iK = iK - 1 -- Get next state
    end; return vOut
  end
    
  local function getAlpha()
    local vOut, iK = 0, mOrd
    while(iK > 1) do
      vOut = vOut + mSta[iK] * (mDen[iK] or 0)
      iK = iK - 1 -- Get next state
    end; return vOut
  end
    
  local function putState(vX)
    local iK = mOrd
    while(iK > 0 and mSta[iK] and mSta[iK-1]) do
      mSta[iK] = mSta[iK-1]; iK = iK - 1 -- Get next state
    end; mSta[1] = vX
  end
  
  function self:Process(vU)
    putState(((tonumber(vU) or 0) - getAlpha()) / mDen[1])
    mOut = getBeta(false); return self
  end
  
  function self:Dump()
    logStatus(nil, metaUnit.__tostring(self).." Properties:")
    logStatus(nil, "Name       : "..mName.."^"..tostring(mOrd).." ["..tostring(mTo).."]s")
    logStatus(nil, "Numenator  : {"..strImplode(mNum,", ").."}")
    logStatus(nil, "Denumenator: {"..strImplode(mDen,", ").."}")
    logStatus(nil, "States     : {"..strImplode(mSta,", ").."}\n") 
    return self
  end
  
  return self
end
