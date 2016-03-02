require("turtle")
require("dvdlualib/complex")
require("dvdlualib/common")
local Log = function(anyStuff)
  io.write(tostring(anyStuff).."\n")
end

function LogXY(i,a,b)
  Log(tostring(i).."{"..tostring(a)..","..tostring(b).."}")
end

function plot(xyP,cl)
  pncl(cl)
  rect(xyP.x-2,xyP.y-2,5,5)
end

function xyText(xyP)
  return "{"..tostring(xyP.x)..","..tostring(xyP.y).."}"
end

io.stdout:setvbuf("no")

open("Borderline Test")

size(400,400)
updt(true) 
zero(0, 0) 

local sW = 100
local sH = 100
local eW = 300
local eH = 300

function adaptLine(xyS,xyE,nI,nK,sMeth,nDelay,nDraw)
  
  local function Enclose(xyPnt)
    if(xyPnt.x < sW) then return -1 end
    if(xyPnt.x > eW) then return -1 end
    if(xyPnt.y < sH) then return -1 end
    if(xyPnt.y > eH) then return -1 end
    return 1
  end
    
  local I = 0
  if(not (xyS and xyE)) then return false, I end
  if(not (xyS.x and xyS.y and xyE.x and xyE.y)) then return false, I end
  crcl(xyS.x,xyS.y,10,colr(255,0,0))
  crcl(xyE.x,xyE.y,10,colr(0,0,255))
  local nK = nK or 0.25
  local nI = nI or 50
        nI = math.floor(nI)
  if(sW >= eW) then return false, I end
  if(sH >= eH) then return false, I end
  if(nI < 1) then return false, I end
  if(not (nK > I and nK < 1)) then return false, I end
  local SigS = Enclose(xyS)
  local SigE = Enclose(xyE)
  if(SigS == 1 and SigE == 1) then
    return true, I
  elseif(SigS == -1 and SigE == -1) then
    return false, I
  elseif(SigS == -1 and SigE == 1) then
    xyS.x, xyE.x = xyE.x, xyS.x
    xyS.y, xyE.y = xyE.y, xyS.y
  end
  local nDelay = tonumber(nDelay) or 0
  if(not sMeth or sMeth == "" or sMeth == "BIN") then
    local DisX = xyE.x - xyS.x
    local DirX = DisX
          DisX = DisX * DisX
    local DisY = xyE.y - xyS.y
    local DirY = DisY
          DisY = DisY * DisY
    local Dis = math.sqrt(DisX + DisY)
    if(Dis == 0) then
      return false, I
    end
          DirX = DirX / Dis
          DirY = DirY / Dis
    local Pos = {x = xyS.x, y = xyS.y}
    local Mid = Dis / 2
    local Pre = 100 -- Obviously big enough
    while(I < nI) do
      Sig = Enclose(Pos)
      if(Sig == 1) then
        xyE.x = Pos.x
        xyE.y = Pos.y
      end
      Pos.x = Pos.x + DirX * Sig * Mid
      Pos.y = Pos.y + DirY * Sig * Mid
      --[[
        Estimate the distance and break
        earlier with 0.5 because of the 
        math.floor call afterwards. 
      ]]
      Pre = math.abs(
            math.abs(Pos.x) + 
            math.abs(Pos.y) -
            math.abs(xyE.x) -
            math.abs(xyE.y))      
      if(Pre < 0.5) then break end
      Mid = nK * Mid
      I = I + 1
    end
  elseif(sMeth == "ITR") then
    local V = {x = xyE.x-xyS.x, y = xyE.y-xyS.y}
    local N = math.sqrt(V.x*V.x + V.y*V.y)
    local Z = (N * (1-nK))
    if(Z == 0) then return false, I end
    local D = {x = V.x/Z , y = V.y/Z}
          V.x = xyS.x
          V.y = xyS.y
    local Sig = Enclose(V)
    while(Sig == 1) do
      xyE.x, xyE.y = V.x, V.y
      V.x = V.x + D.x
      V.y = V.y + D.y
      Sig = Enclose(V)
      I = I + 1
    end
  end
  xyS.x, xyS.y = math.floor(xyS.x), math.floor(xyS.y)
  xyE.x, xyE.y = math.floor(xyE.x), math.floor(xyE.y)
  return true, I
end


pncl(colr(0,0,0))
rect(sW,sH,eW-sW,eH-sH,0)

local bE = {x = 350, y = 310}
local iE = {x = bE.x, y = 50}

local S = {x = 200, y = 180}
local s,i = adaptLine(S,iE,500,0.2,"ITR",0.01)
Log("Iterat status: "..tostring(s))
text("Iter: "..i.." "..xyText(S).." >  "..xyText(iE).." ("..tostring(s)..")",0,sW,sH-21)
plot(iE,colr(0,255,0))

local S = {x = 200, y = 220}
local s,i = adaptLine(S,bE,9999,0.5,"BIN",1)
Log("Binary status: "..tostring(s))
text("Iter: "..i.." "..xyText(S).." >  "..xyText(bE).." ("..tostring(s)..")",0,sW,eH+2)
plot(bE,colr(0,255,0))


