---------------  Methods and Functions

function GetSign(num)
  return num / math.abs(num)
end

function NewPoint(X,Y)
  return {x = X, y = Y}
end

-- 100 - 250
-- 150 - 500
function Remap(Num,NMin,NMax,VMin,VMax)
  local N = (NMin + NMax) / 2
  local V = (VMin + VMax) / 2
  local S = (VMax - VMin) / (NMax - NMin)
  return V + (N - Num) * S
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
  local Con    = 0
  local ConEnb = 0
  local ParamID = 1
  local Pro = 0
  local Int = 0
  local Dif = 0
  local ErrN = 0
  local ErrO = 0
  local PID = {
     [1] = {Val = kP, Name = "Pro", Step = iP},
     [2] = {Val = kI, Name = "Int", Step = iI},
     [3] = {Val = kD, Name = "Dif", Step = iD}
  }

  function self:SetEnable(en)
    ConEnb = en
  end

  function self:GetEnable()
    return ConEnb
  end

  function self:SetParmID(id)
    if(id > 3) then id = 3 end
    if(id < 1) then id = 1 end
    ParamID = id
  end

  function self:GetParamID()
    return ParamID
  end

  function self:NextParam(Val)
    local S = 0
    if(Val > 0) then S = 1 end
    if(Val < 0) then S = -1 end
    ParamID = ParamID + S
    if(ParamID > 3) then ParamID = 1 end
    if(ParamID < 1) then ParamID = 3 end
  end

  function self:SwingParam(Val)
    if(Val == 0) then return end
    local S = 0
    if(Val > 0) then S = 1 end
    if(Val < 0) then S = -1 end
    PID[ParamID].Val = PID[ParamID].Val + S * PID[ParamID].Step
  end

  function self:GetCurParamInfo()
    local Param = {
        Val  = PID[ParamID].Val,
        Name = PID[ParamID].Name,
        Step = PID[ParamID].Step
    }
    return Param
  end

  function self:GetControl()
    return Con
  end

  function self:Process(R,Y)
    if(ConEnb ~= 0) then
      ErrO = ErrN
      ErrN = R - Y
      if(GetSign(ErrO) ~= GetSign(ErrN)) then
        Int = 0
      end
      Pro = PID[1].Val * ErrN
      Int = Int + (PID[2].Val * (ErrN + ErrO))
      Dif = PID[3].Val * (ErrN - ErrO)
      Con = Pro + Int + Dif
    end
  end

  function self:Reset()
    Con    = 0
    ConEnb = 0
    Pro    = 0
    Int    = 0
    Dif    = 0
    ErrN   = 0
    ErrO   = 0
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
Info         = ""
CurSignal    = 0
MouseRef     = 150
Mass         = 590
PV           = {x = 0, y = 0}
Process      = {}
RefProc      = {}
Sig          = {}
PID          = {}
mX           = 0
mY           = 0
RefY         = 150
SignalPeriod = 100

------------------- Body

function love.keypressed(key, isrepeat)
   print(key)
   if(key == "right") then
      PID:SwingParam(1)
   elseif(key == "left") then
      PID:SwingParam(-1)
   elseif(key == "up" ) then
      PID:NextParam(1)
   elseif(key == "down" ) then
      PID:NextParam(-1)
   elseif (key == "space" ) then
      if (PID:GetEnable() == 0) then
          PID:Reset()
          PID:SetEnable(1)
      else
          PID:Reset()
          PID:SetEnable(0)
      end
  end
  if(key == "]") then
    CurSignal = CurSignal + 1
    if(CurSignal > 9) then CurSignal = 0 end
  end
  if(key == "[") then
    CurSignal = CurSignal - 1
    if(CurSignal < 0) then CurSignal = 9 end
  end
  if(CurSignal ~= 1) then
    if(key == ".") then
      SignalPeriod = SignalPeriod + 1
    end
    if(key == ",") then
      SignalPeriod = SignalPeriod - 1
      if(SignalPeriod < 10) then SignalPeriod = 10 end
    end
  end
end


function love.update(dt)
  world:update(dt)
  PV.x, PV.y = Ball.Body:getPosition()
  if(CurSignal == 0) then -- Middle mouse
    RefY = MouseRef
    Info = "Manual"
  else
    Sig[CurSignal]:SetPeriod(SignalPeriod)
    RefY = Sig[CurSignal]:Flow()
    Info = Sig[CurSignal].mInfo
  end
  PID:Process(RefY,PV.y)
  Ball.Body:applyForce(0, PID:GetControl())
  Process:Update(Remap(PV.y,0,320,599,427))
  RefProc:Update(Remap(RefY,0,320,599,427))
end

function love.load()
    Process = NewGraph(400,600)
    RefProc = NewGraph(400,600)
    PID     = NewPID(17300,14,570000,20,1,500)
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
    w, h = love.graphics.getDimensions()
    love.keyboard.setKeyRepeat(true)
    world = love.physics.newWorld(0, 200, true)
    Ball = {}
        Ball.Body  = love.physics.newBody(world, 400,200, "dynamic")
        Ball.Shape = love.physics.newCircleShape(50)
        Ball.Fix   = love.physics.newFixture(Ball.Body, Ball.Shape)
        Ball.Fix:setRestitution(0.3)
        Ball.Fix:setUserData("Ball")
        Ball.Body:setMass(Mass)
    Rect = {}
        Rect.Body  = love.physics.newBody(world, 400,400, "static")
        Rect.Shape = love.physics.newRectangleShape(200,50)
        Rect.Fix   = love.physics.newFixture(Rect.Body, Rect.Shape)
        Rect.Fix:setUserData("Block")
end

function love.draw()
    CurParam = PID:GetCurParamInfo()
    love.graphics.setColor(255, 255, 255, 255)
    Text = "BallPosY    : "..PV.y
       .."\nReference : "..RefY
       .."\nConForce  : "..(-PID:GetControl())
       .."\nControlE   : "..PID:GetEnable()
       .."\nMass        : "..Ball.Body:getMass()
       .."\nParam      : "..CurParam.Name.." -> "..CurParam.Val
       .."\nPeriod      : "..SignalPeriod.." -> "..tostring(Info)
       .."\nSignal-ID   : "..tostring(CurSignal)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.circle("line", Ball.Body:getX(),Ball.Body:getY(), Ball.Shape:getRadius(), 20)
    love.graphics.setColor(150, 100, 0, 255)
    love.graphics.polygon("line", Rect.Body:getWorldPoints(Rect.Shape:getPoints()))
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print( Text, 0, 0, 0)
    mX, mY = love.mouse.getPosition()
    love.graphics.printf( "X="..mX..",Y="..mY, 670, 0, 50)
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
