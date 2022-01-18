---------------  Methods and Functions

function GetSign(num)
  return num / math.abs(num)
end

function NewPoint(X,Y)
  return {x = X, y = Y}
end

function Clamp(nNum, nMin, nMax)
  if(not nNum) then return nNum end
  if(nMin and nNum < nMin) then return nMin end
  if(nMax and nNum > nMax) then return nMax end
  return nNum
end

-- 100 - 250
-- 150 - 500
function Remap(num,iMin,iMax,oMin,oMax)
  local N = (iMin + iMax) / 2
  local V = (oMin + oMax) / 2
  local S = (oMax - oMin) / (iMax - iMin)
  return V + (N - num) * S
end

function Roll(nNum, nMin, nMax)
  if(nNum > nMax) then return nMin end
  if(nNum < nMin) then return nMax end
  return nNum
end

function NewGraph(iPoint,YInit)
  self = {}
  local Size = 2 * iPoint
  local Data = {}
  for i = 1, Size, 2 do
    Data[i]   = i - 1
    Data[i+1] = YInit
  end
  function self:Update(Val)
    for i = 2, Size, 2 do
      Data[i] = Data[i+2]
    end
    Data[Size] = Val
  end
  function self:GetData()
    return Data
  end
  return self
end

function NewPID(kP,kI,kD,iP,iI,iD)
  self = {}
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
    return mErrD / mTimD
  end
  
  function self:GetIntTerm()
    if(mPID[2].K == 0) then return 0 end
    return mErrI * mTimD
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
    if(num == 0) then return end
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

function NewSignal(vMin,vMax,nPeriod,nStep,sInfo,fScale,fFlow)
  self = {}
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

------------------ DATA
local Process      
local RefProc      
local PID  
local Ball
local Rect
local World
local Font
local Sig          = {}
local Info         = ""
local CurSignal    = 0
local MouseRef     = 150
local Mass         = 590
local PV           = {x = 0, y = 0}        
local RefY         = 150
local SignalPeriod = 100

------------------- Body

function love.keypressed(key, isrepeat)
   if(key == "right") then
      PID:SwingParam(1)
   elseif(key == "left") then
      PID:SwingParam(-1)
   elseif(key == "up" ) then
      PID:NextParam(1)
   elseif(key == "down" ) then
      PID:NextParam(-1)
   elseif (key == "space" ) then
    if (PID:IsEnable()) then
      PID:Reset()
      PID:IsEnable(false)
    else
      PID:Reset()
      PID:IsEnable(true)
    end
  end
  if(key == "]") then
    CurSignal = Roll(CurSignal + 1, 0, 9)
  end
  if(key == "[") then
    CurSignal = Roll(CurSignal - 1, 0, 9)
  end
  if(CurSignal ~= 0) then
    if(key == ".") then
      SignalPeriod = Clamp(SignalPeriod + 1, 5, 100)
    end
    if(key == ",") then
      SignalPeriod = Clamp(SignalPeriod - 1, 5, 100)
    end
  end
end


function love.update(dt)
  World:update(dt)
  PV.x, PV.y = Ball.Body:getPosition()
  if(CurSignal == 0) then -- Middle mouse
    RefY = MouseRef
    Info = "Manual"
  else
    Sig[CurSignal]:SetPeriod(SignalPeriod)
    RefY = Sig[CurSignal]:Flow()
    Info = Sig[CurSignal].mInfo
  end
  PID:Process(RefY, PV.y)
  Ball.Body:applyForce(0, PID:GetControl())
  Process:Update(Remap(PV.y,0,320,599,427))
  RefProc:Update(Remap(RefY,0,320,599,427))
end
  
function love.load()
  Process = NewGraph(400,600)
  RefProc = NewGraph(400,600)
  PID     = NewPID(5550,3500,7200,100,100,100):SetZeroCross(2) 
  VMin = {x = 0, y =  60}
  VMax = {x = 2, y = 300}
  
  Sig[1] = NewSignal(VMin,VMax,SignalPeriod,0.1,"SinWave",
    function(o) return (2 * math.pi) / o.mPeriod end,
    function(o)
      o.mValue = o.mMiddle + o.mAmplit * math.sin(o.mScale * o.mTime)
      o.mOutput = o.mValue
    end)
  Sig[2] = NewSignal(VMin,VMax,SignalPeriod,0.1,"Square",
    function(o) return 4 * o.mAmplit / ( o.mPeriod / o.mStep) end,
    function(o) o:Switch():Direct()
      o.mOutput = o.mAmplit * o.mDirect + o.mMiddle
    end)
  Sig[3] = NewSignal(VMin,VMax,SignalPeriod,0.1,"Triangle",
    function(o) return 4 * o.mAmplit / ( o.mPeriod / o.mStep) end,
    function(o) o:Switch():Direct():Pass() end)
  Sig[4] = NewSignal(VMin,VMax,SignalPeriod,0.1,"SawtoothL",
    function(o) return 2 * o.mStep * (o.mAmplit / o.mPeriod) end,
    function(o) o:MaxToMin():Direct(1):Pass() end)
  Sig[5] = NewSignal(VMin,VMax,SignalPeriod,0.1,"SawtoothR",
    function(o) return 2 * o.mStep * (o.mAmplit / o.mPeriod) end,
    function(o) o:MinToMax():Direct(-1):Pass() end)
  Sig[6] = NewSignal(VMin,VMax,SignalPeriod,0.1,"HalfCircle", nil,
    function(o) o:Reset(); local h = o:GetHalfPeriod()
      o.mValue = math.sqrt(o.mAmplit*(1-((o.mTime - (h))^2)/(h)^2))
      o.mValue = Remap(o.mValue, 0, 11, o.mMin.y, o.mMax.y)
      o.mOutput = o.mValue
    end)
  Sig[7] = NewSignal(VMin,VMax,SignalPeriod,0.1,"Trapezoidal",
    function(o) return 8 * o.mAmplit / ( o.mPeriod / o.mStep ) end,
    function(o) o:SwitchMiddle():Direct():Pass():Clamp() end)
  Sig[8] = NewSignal(VMin,VMax,SignalPeriod,0.1,"WhiteNoice", nil,
    function(o) o:Random():Pass() end)
  Sig[9] = NewSignal(VMin,VMax,SignalPeriod,0.1,"#38*(4*x^3-8*x^2+3*x+1)", nil,
    function(o) o.mValue = Remap(o.mTime, 0, o.mPeriod, o.mMax.x, o.mMin.x)
      o.mOutput = o.mMax.y - o.mFMath(o.mValue); o:Reset()
    end)

  love.window.setTitle("Ball position PID")
  love.keyboard.setKeyRepeat(true)
  local w, h = love.graphics.getDimensions()  
  World = love.physics.newWorld(0, 200, true)
  Ball = {}
  Ball.Body  = love.physics.newBody(World, 400,200, "dynamic")
  Ball.Shape = love.physics.newCircleShape(50)
  Ball.Fix   = love.physics.newFixture(Ball.Body, Ball.Shape)
  Ball.Fix:setRestitution(0.3)
  Ball.Fix:setUserData("Ball")
  Ball.Body:setMass(Mass)
  Rect = {}
  Rect.Body  = love.physics.newBody(World, 400,400, "static")
  Rect.Shape = love.physics.newRectangleShape(200,50)
  Rect.Fix   = love.physics.newFixture(Rect.Body, Rect.Shape)
  Rect.Fix:setUserData("Block")
  Font = love.graphics.newFont("consola.ttf", 15)
end

function love.draw()
    local ID =  PID:GetParamID()
    local Cur = PID:GetParamInfo()
    local Err = PID:GetError()
    love.graphics.setColor(255, 255, 255, 255)
    local Text = "BallPosY  : "..PV.y
             .."\nReference : "..RefY
             .."\nError     : "..Err
             .."\nConForce  : "..(-PID:GetControl())
             .."\nEnControl : "..tostring(PID:IsEnable())
             .."\nMass      : "..Ball.Body:getMass()
             .."\nParam ["..ID.."] : "..Cur.Name.." -> "..Cur.K
             .."\n    P     : "..PID:GetPro()
             .."\n    I     : "..PID:GetInt()
             .."\n    D     : "..PID:GetDif()
             .."\n    Z     : "..(PID:IsZeroCross() and "X" or "")
             .."\nPeriod    : "..SignalPeriod.." -> "..tostring(Info)
             .."\nSignal ID : "..tostring(CurSignal)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.circle("line", Ball.Body:getX(),Ball.Body:getY(), Ball.Shape:getRadius(), 20)
    love.graphics.setColor(150, 100, 0, 255)
    love.graphics.polygon("line", Rect.Body:getWorldPoints(Rect.Shape:getPoints()))
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(Font)
    love.graphics.print(Text, 0, 0, 0)
    local mX, mY = love.mouse.getPosition()
    love.graphics.print("X="..mX..",Y="..mY, 670, 0)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.line(Process:GetData())
    love.graphics.setColor(0, 0, 255, 255)
    love.graphics.line(RefProc:GetData())
end

function love.mousepressed(x, y, button)  
    if(button == 2) then -- Right click
      Mass = Mass + 50
    elseif(button == 1) then -- Left click
      Mass = Mass - 50
    elseif(button == 3) then -- Middle click
      MouseRef = y
    end
    if(Mass <= 10) then Mass = 10 end
    Ball.Body:setMass(Mass)
end
