require("funcs")
require("pid")
require("graph")
require("signal")

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

------------------- BODY

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
             .."\n    P     : "..(-PID:GetPro())
             .."\n    I     : "..(-PID:GetInt())
             .."\n    D     : "..(-PID:GetDif())
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
