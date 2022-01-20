function NewSignal(vMin,vMax,nPeriod,nStep,sInfo,fScale,fFlow)
  local self = {}
  self.mInfo = tostring(sInfo or "")
  -- Y interval for signal "Out"
  self.mMin = {x = vMin.x, y = vMin.y}
  self.mMax = {x = vMax.x, y = vMax.y}
  self.mMinF   = 0
  self.mMaxF   = 0
  self.mStep   = math.abs(nStep)
  self.mPeriod = math.abs(nPeriod) * self.mStep
  self.mTime   = 0
  self.mDirect = 1
  self.mScale  = 0
  self.mMiddle = self.mMin.y + (self.mMax.y - self.mMin.y) / 2
  self.mAmplit = math.abs(self.mMiddle - self.mMin.y)
  self.mValue  = self.mMiddle
  self.mOutput = self.mValue
  
  if(sInfo:sub(1,1) == "#") then -- Function must persist in Info
    self.mInfo = self.mInfo:sub(2,-1)
    self.mFMath = load(" return function(x) return ("..self.mInfo..") end")()
  end
  
  if(fScale) then
    self.mFScale = fScale
    self.mScale = self.mFScale(self)
  end

  if(fFlow) then
    self.mFFlow = fFlow
  else
    error("Signal ["..self.mInfo.."] does not have flow!")
  end

  function self:Pass()
    self.mOutput = self.mValue
    return self
  end
  
  function self:Switch()
    if((self.mValue > self.mMax.y) or (self.mValue < self.mMin.y)) then
      self.mDirect = -self.mDirect end; return self
  end

  function self:SwitchMiddle()
    if((self.mValue > (self.mMiddle + 2 * self.mAmplit)) or
       (self.mValue < (self.mMiddle - 2 * self.mAmplit))) then
    self.mDirect = -self.mDirect
    end; return self
  end

  function self:MaxToMin()
    if(self.mValue >= self.mMax.y) then
      self.mValue = self.mMin.y
    end; return self
  end

  function self:MinToMax()
    if(self.mValue <= self.mMin.y) then
      self.mValue = self.mMax.y
    end; return self
  end

  function self:SetPeriod(new)
    if(new < 10) then return end
    self.mPeriod = math.abs(new) * self.mStep
    if(self.mFScale) then
      self.mScale = self.mFScale(self)
    end; return self
  end
  
  function self:GetHalfPeriod()
    return (self.mPeriod / 2)
  end

  function self:Reset()
    if(self.mTime > self.mPeriod) then self.mTime = 0 end
  end
  
  function self:Direct(new)
    local num = tonumber(new) or self.mDirect
    self.mValue = self.mValue + (self.mScale * num)
    return self
  end
  
  function self:Clamp(na, nb)
    local ma = tonumber(nb) or self.mMax.y
    local mi = tonumber(na) or self.mMin.y
    if(self.mValue > ma) then self.mOutput = ma end
    if(self.mValue < mi) then self.mOutput = mi end
    return self
  end
  
  function self:Random(na, nb)
    local ma = tonumber(nb) or self.mMax.y
    local mi = tonumber(na) or self.mMin.y
    self.mValue = love.math.random(mi, ma)
    return self
  end

  function self:Flow()
    if(not self.mFFlow) then return self end
    self.mFFlow(self); self.mTime = self.mTime + self.mStep
    return self.mOutput
  end
  
  return self
end
