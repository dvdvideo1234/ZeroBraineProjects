require("turtle")
require("wx")
require("dvdlualib/common")
local life = require("dvdlualib/lifelib")

io.stdout:setvbuf("no")

function TurtleDraw(F,Arg)
  local sx = 0
  local sy = 18
  local fx = F:getW()
  local fy = F:getH()
  local dx = (Arg[1]-sx)/fx
  local dy = (Arg[2]-sy)/fy
  local x,y = 0,0
  local i = 1
  local Arr = F:getArray()
  wipe()
  text("Generation: "..(F:getGenerations() or "N/A").." {"..tostring(Arg[3])..
        ","..tostring(Arg[4]).."} > "..tostring(Arg[5]),0,0,0)
  while(Arr[i]) do
    local v = Arr[i]
    local j = 1
          x = 0
    while(v[j]) do
      if(v[j] == 1) then
        rect(x+sx,y+sy,dx,dy,0)
      end
      x = x + dx
      j = j + 1
    end
    y = y + dy
    i = i + 1
  end
          rect(sx,sy,x,y,0)
end


function getKeyboardKeyNonBlock()
  local Ch = io.read(1)
             io.write("\n\r")
  return Ch
end


local Arg = {200, 100,0,0}

open("Game Of Life")
size(Arg[1],Arg[2])
updt(true)
zero(0, 0)

life.shapesPath("GameOfLife/shapes/")

local F = life.makeField(60,25)
      F:RegisterDraw("turtle",TurtleDraw)

local GG = life.makeShape(life.initFileRle("gosperglidergun"))

io.write(tostring(GG))

-- For click detect
Arg[3] = 10
Arg[4] = 57
Arg[5] = ""

F:Spawn(GG,X,Y)

F:Draw("turtle",Arg)

while true do
  Arg[5] = char()
  F:Draw("turtle",Arg)
  F:Evolve()
end

