require("turtle")
require("wx")
require("dvdlualib/common")
require("dvdlualib/lifelib")

io.stdout:setvbuf("no")

function TurtleDraw(F,Arg)
  local x = 0
  local y = 15
  local fx = F:getW()
  local fy = F:getH()
  local dx = math.floor((Arg[1])/(fx-1))
  local dy = math.floor((Arg[2]-y)/(fy-1))
  local i = 1
  local Arr = F:getArray()
  wipe()
  text("Generation: "..(F:getGenerations() or "N/A").." {"..Arg[3]..","..Arg[4].."} > "..tostring(Arg[5]),0,0,0)
  while(Arr[i]) do
    local v = Arr[i]
    local j = 1
          x = 0
    while(v[j]) do
      if(v[j] == 1) then
        rect(x,y,dx,dy,0)
      end
      x = x + dx
      j = j + 1
    end
    y = y + dy
    i = i + 1
  end
end


function getKeyboardKeyNonBlock()
  local Ch = io.read(1)
             io.write("\n\r")
  return Ch
end


local Arg = {500, 200,0,0}

open("Game Of Life")
size(Arg[1],Arg[2])
updt(true)
zero(0, 0)

Life.ShapesPath("GameOfLife_master/shapes/")

local F = Life.Field(100,50)
      F:RegisterDraw("turtle",TurtleDraw)

local GG = Life.Shape(Life.InitFileRle("gosperglidergun"))


Arg[3] = 10
Arg[4] = 10
Arg[5] = ""

F:Spawn(GG,X,Y)

F:Draw("turtle",Arg)

while true do
  Arg[5] = char()
  F:Draw("turtle",Arg)
  F:Evolve()
end

