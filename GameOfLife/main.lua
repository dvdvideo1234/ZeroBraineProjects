require("turtle")
require("wx")
require("ZeroBraineProjects/dvdlualib/common")
local life = require("ZeroBraineProjects/dvdlualib/lifelib")

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
end


function getKeyboardKeyNonBlock()
  local Ch = io.read(1)
             io.write("\n\r")
  return Ch
end


local Arg = {300, 150,0,0}


open("Game Of Life")
size(Arg[1],Arg[2])
updt(true)
zero(0, 0)

life.shapesPath("GameOfLife/shapes/")

life.charAliv("O")
life.charDead(".")

local F = life.makeField(60,25)
      F:regDraw("turtle",TurtleDraw)

ggrle = "24.O11.$22.O.O11.$12.2O6.2O12.2O$11.O3.O4.2O12.2O$2O8.O5.O3.2O14.$2O8.O3.O.2O4.O.O11.$10.O5.O7.O11.$11.O3.O20.$12.2O22.!"

local ggtx = [[
........................O...........
......................O.O...........
............OO......OO............OO
...........O...O....OO............OO
OO........O.....O...OO..............
OO........O...O.OO....O.O...........
..........O.....O.......O...........
...........O...O....................
............OO......................]]
local GG = life.makeShape(ggtx,"string","txt",{"\n"})

-- Print(GG)

-- Used for mouse clicks and keys
Arg[3] = 10
Arg[4] = 57
Arg[5] = ""

F:setShape(GG,1,1)

F:drwLife("turtle",Arg)

while true do
  Arg[5] = char()
  F:drwLife("turtle",Arg)
  Delay(-0.2)
  F:evoNext()
end

