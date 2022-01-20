function NewPID(kP,kI,kD,iP,iI,iD)
  local self = {}
  local mCon    = 0
  local mConEnb = false
  local mParamID = 1
  local mPro = 0
  local mInt = 0
  local mDif = 0
  local mErrN = 0
  local mZeroC = nil
  local mErrO = 0
  local mTimN = 0
  local mErrD = 0
  local mErrI = 0
  local mTimO = 0
  local mTimD = 0
  local mZerB = false
  local mPID = {
     [1] = {K = kP, Name = "Pro", Step = iP},
     [2] = {K = kI, Name = "Int", Step = iI},
     [3] = {K = kD, Name = "Dif", Step = iD}
  }

  function self:GetPro() return mPro end
  function self:GetInt() return mInt end
  function self:GetDif() return mDif end
  function self:GetControl() return mCon end
  function self:GetParamID() return mParamID end
  function self:GetError() return mErrN, mErrO end
  function self:GetTime() return mTimN, mTimO end
  function self:GetParamInfo() return mPID[mParamID] end
  function self:IsZeroCross() return mZerB end
   
  function self:GetDifTerm()
    if(mPID[3].K == 0) then return 0 end 
    return (mErrD / mTimD)
  end
  
  function self:GetIntTerm()
    if(mPID[2].K == 0) then return 0 end
    return (mErrI * mTimD)
  end
  
  function self:SetZeroCross(num)
    mZeroC = (tonumber(num) or 0)
    mZeroC = ((mZeroC > 0) and mZeroC or nil)
    return self
  end
    
  function self:IsZero()
    if(not mZeroC) then return false end
    local mar = math.abs(mErrN - mErrO)
    if(mar < mZeroC) then return false end
    return (GetSign(mErrO) ~= GetSign(mErrN))
  end
  
  function self:Update(err)
    mErrO, mErrN = mErrN, err
    mTimO, mTimN = mTimN, os.clock()
    mErrD = (mErrN - mErrO)
    mErrI = (mErrN + mErrO)
    mTimD = (mTimN - mTimO)
    mZerB = self:IsZero()
    return self
  end
  
  function self:IsEnable(en)
    if(en ~= nil) then 
      mConEnb = en
    end; return mConEnb
  end

  function self:SetParmID(iD)
    mParamID = Clamp(math.floor(iD), 1, 3)
    return self
  end

  function self:NextParam(iS)
    if(iS == 0) then return end
    return self:SetParmID(Roll(mParamID + iS, 1, 3))
  end

  function self:SwingParam(num)
    if(num == 0) then return self end
    local S = (num > 0 and 1 or -1)
    local P = mPID[mParamID]
    P.K = P.K + S * P.Step
    return self
  end
  
  function self:Process(R, Y)
    self:Update(R - Y)
    if(mConEnb) then
      if(mZerB) then mInt = 0 end
      mPro = mPID[1].K * mErrN
      mInt = mInt + (mPID[2].K * self:GetIntTerm())
      mDif = mPID[3].K * self:GetDifTerm()
      mCon = mPro + mInt + mDif
    end; return self
  end
  
  function self:Reset()
    mCon     = 0
    mConEnb  = false
    mParamID = 1
    mPro     = 0
    mInt     = 0
    mDif     = 0
    mErrN    = 0
    mErrO    = 0
    return self
  end

  return self
end
