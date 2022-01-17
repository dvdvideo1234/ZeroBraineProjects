---------------  Methods and Functions

function NewPoint(X,Y)
  P = {
    x = X,
    y = Y
  }
  return P
end

-- 100 - 250
-- 150 - 500
function NumScaleIt(Num,NMin,NMax,VMin,VMax)
   MiddleN = (NMin + NMax) / 2
   MiddleV = (VMin + VMax) / 2
   Scale   = (VMax - VMin) / (NMax - NMin)
   Rez = MiddleV + (MiddleN - Num) * Scale
   return Rez
end

function NewGraph(PointCntVal,YInit)
  self = {}
  local PointCnt = 2*PointCntVal
  local Data = {}
  for i = 1,PointCnt,2 do
    Data[i]  = i-1
    Data[i+1]= YInit
  end
  function self:Update(Val)
    local i = 2
    for i = 2,PointCnt,2 do
      Data[i] = Data[i+2]
    end
    Data[PointCnt] = Val
  end
  function self:GetData()
    Dat = Data
    return Dat
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

  function self:SetEnable(Val)
    ConEnb = Val
  end

  function self:GetEnable()
    local Val = ConEnb
    return Val
  end

  function self:SetParmID(Val)
    if(Val > 3) then Val = 3 end
    if(Val < 1) then Val = 1 end
    ParamID = Val
  end

  function self:GetParamID()
    local ID = ParamID
    return ID
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
    local Value = Con
    return Value
  end

  function self:Process(R,Y)
    if(ConEnb ~= 0) then
      ErrO = ErrN
      ErrN = R - Y
      Pro = PID[1].Val * ErrN
      Int = Int + (PID[2].Val * (ErrN + ErrO))
      Dif = PID[3].Val * ( ErrN - ErrO)
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

function NewSignal(ValueMin,ValueMax,Period,Step,Mode,Info)

  if(Mode < 1) then return nil end
  self = {}

  function MakeMathFunc(Y)
    local makfoo = load(" return function(x) return ("..Y..") end")
    local foo = makfoo()
    return foo
  end

  local Name   = Info
  -- Y interval for signal "Out"
  local MinY   = ValueMin.Y
  local MaxY   = ValueMax.Y
  -- X interval for a function ( when Mode = 9 )
  -- function must persist in Info
  local MinX   = ValueMin.X
  local MaxX   = ValueMax.X
  local MinF   = 0
  local MaxF   = 0
  local Stp    = math.abs(Step)
  local Perd   = math.abs(Period) * Stp
  local Time   = 0
  local Direct = 1
  local Koef   = 0
  local Mode   = Mode
  local Middle = MinY + (MaxY - MinY) / 2
  local Amplit = math.abs(Middle - MinY)
  local F      = MakeMathFunc(Name)
  local CurVal = Middle
  local Out    = CurVal


  if(Mode == 1) then -- SinWave
    Koef = (2 * math.pi) / Perd
  elseif(Mode == 2 or Mode == 3) then -- PWM or TRI
    Koef = 4 * Amplit / ( Perd / Stp)
  elseif(Mode == 4 or Mode == 5) then -- SawS
    Koef = 2 * Stp * (Amplit / Perd)
  elseif(Mode == 7) then
  -- Asume that angle is 60 deg
    Koef = 8 * Amplit / ( Perd / Stp )
  -- There is noting for the white noice
  elseif(Mode == 9) then
  -- Scale it Yerself !!
  end

  function self:GetCurValue()
    local Val = CurVal
    return Val
  end

  function self:SetPeriod(Val)
    if (Val < 10) then return end
    Perd = math.abs(Val) * Stp
    self:SetMode(Mode)
  end

  function self:SetMode(Val)
    if(Val < 1) then return nil end
    if(Val == 1) then -- SinWave
      Koef = (2 * math.pi) / Perd
    elseif(Val == 2 or Val == 3) then -- PWM or TRI
      Koef = 4 * Stp * (Amplit / Perd)
    elseif(Val == 4 or Val == 5) then -- SawS
      Koef = 2 * Stp * (Amplit / Perd)
    elseif(Mode == 7) then
      Koef = 8 * Stp * (Amplit / Perd)
    -- There is noting for the white noice
    elseif(Mode == 9) then
    -- Scale it Yerself !!
    end
  end
  function self:GetName()
    local Info = Name
    return Info
  end
  function self:Flow()
    if(Mode == 1) then -- SinWave
      CurVal = Middle + Amplit * math.sin(Koef * Time)
      Out = CurVal
    elseif(Mode == 2) then  -- Square
      if((CurVal > MaxY) or (CurVal < MinY)) then
          Direct = -Direct
      end
      CurVal = CurVal + ( Koef * Direct )
      Out = Amplit * Direct + Middle
    elseif(Mode == 3) then -- Tri
      if((CurVal > MaxY) or (CurVal < MinY)) then
          Direct = -Direct
      end
      CurVal = CurVal + ( Koef * Direct )
      Out = CurVal
    elseif(Mode == 4) then -- Saw1
      if(CurVal >= MaxY) then
          CurVal = MinY
      end
      CurVal = CurVal + Koef
      Out = CurVal
    elseif(Mode == 5) then -- Saw2
      if(Out <= MinY) then
          CurVal = MaxY
      end
      CurVal = CurVal - Koef
      Out = CurVal
    elseif(Mode == 6) then -- Circle
      if(Time > Perd) then Time = 0 end
      CurVal = math.sqrt(Amplit*(1-((Time - (Perd/2))^2)/(Perd/2)^2))
      CurVal = NumScaleIt(CurVal,0,11,MinY,MaxY)
      Out = CurVal
    elseif(Mode == 7) then
      if((CurVal > (Middle + 2 * Amplit)) or (CurVal < (Middle - 2 * Amplit))) then
          Direct = -Direct
      end
      CurVal = CurVal + Koef * Direct
      Out = CurVal
      if(CurVal > MaxY) then Out = MaxY end
      if(CurVal < MinY) then Out = MinY end
    elseif(Mode == 8) then
      CurVal = love.math.random(MinY, MaxY)
      Out = CurVal
    elseif(Mode == 9) then
      CurVal = NumScaleIt(Time,0,Perd,MaxX,MinX)
      Out = (MaxY - F(CurVal)) or 99
      if(math.abs(Time) > Perd) then Time = 0 end
    end -- Mode end .. Time is passing by ...
    Time = Time + Stp
    return Out
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
    for k, _ in pairs(Sig) do
      if(k == CurSignal) then
               Sig[k]:SetPeriod(SignalPeriod)
        RefY = Sig[k]:Flow()
        Info = Sig[k]:GetName()
        break
      end
    end
  end
  PID:Process(RefY,PV.y)
  Ball.Body:applyForce(0, PID:GetControl())
  Process:Update(NumScaleIt(PV.y,0,320,599,427))
  RefProc:Update(NumScaleIt(RefY,0,320,599,427))
end

function love.load()
    Process = NewGraph(400,600)
    RefProc = NewGraph(400,600)
    PID     = NewPID(17300,14,590000,20,1,500)
    ValueMin = {
      X = 0,
      Y = 60
    }
    ValueMax = {
      X = 2,
      Y = 300
    }
    Sig[1] = NewSignal(ValueMin,ValueMax,SignalPeriod,0.1,1,"SinWave")
    Sig[2] = NewSignal(ValueMin,ValueMax,SignalPeriod,0.1,2,"Square")
    Sig[3] = NewSignal(ValueMin,ValueMax,SignalPeriod,0.1,3,"Triangle")
    Sig[4] = NewSignal(ValueMin,ValueMax,SignalPeriod,0.1,4,"SawtoothL")
    Sig[5] = NewSignal(ValueMin,ValueMax,SignalPeriod,0.1,5,"SawtoothR")
    Sig[6] = NewSignal(ValueMin,ValueMax,SignalPeriod,0.1,6,"HalfCircle")
    Sig[7] = NewSignal(ValueMin,ValueMax,SignalPeriod,0.1,7,"Trapezoidal")
    Sig[8] = NewSignal(ValueMin,ValueMax,SignalPeriod,0.1,8,"WhiteNoice")
    Sig[9] = NewSignal(ValueMin,ValueMax,SignalPeriod,0.1,9,"38*(4*x^3-8*x^2+3*x+1)")

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
    print(button)
  
    if(button == 2) then
      Mass = Mass + 50
    elseif(button == 1) then
      Mass = Mass - 50
    elseif(button == 3) then
      MouseRef = y
    end
    if(Mass <= 10) then Mass = 10 end
    Ball.Body:setMass(Mass)
end
