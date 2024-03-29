local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase()

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")
local col = require("colormap")
local crm = require("chartmap")

-------------------------------------
local tS = {Act = {}, Tim = {}, Dat = {}, Cor ={}}
local dX, dY = 1, 5
local W , H = 1000, 600
local minX, maxX = -20, 80
local minY, maxY = -5, 255
local greyLevel  = 200
local intX  = crm.New("interval","WinX", minX, maxX, 0, W)
local intY  = crm.New("interval","WinY", minY, maxY, H, 0)
local clGry = colr(greyLevel,greyLevel,greyLevel)
local clB = colr(col.getColorBlueRGB())
local clR = colr(col.getColorRedRGB())
local clBlk = colr(col.getColorBlackRGB())
local scOpe = crm.New("scope"):setInterval(intX, intY):setBorder(minX, maxX, minY, maxY)
      scOpe:setSize(W, H):setColor(clBlk, clGry, clBlk, clBlk):setDelta(dX, dY)

-------------------------------------------------------
local spd = 0.5
local tT = {}; for i = 1, 10000 do tT[i] = (i-20) * 0.5 end

local function SineBetween(from, to, speed, vtm)
    return math.Clamp(math.Remap(math.sin(vtm*speed)+0.005, -1, 1, from, to), from, to)
end

local function RampBetween(from, to, speed, vtm)
	local tim = speed * vtm 
	local frc = tim - math.floor(tim)
	local mco = math.abs(2 * (frc - 0.5))
	return math.Remap(mco, 0, 1, from, to)
end

tS.Act[1] = function(t)
  return SineBetween(0, 255, spd, t)
end

tS.Act[2] = function(t)
  return RampBetween(0, 255, spd* 0.16, t)
end

tS.Cor[1] = clB
tS.Cor[2] = clR

-------------------------------------------------------

for ifo = 1, #tS.Act do
  local now = os.clock()
  local foo = tS.Act[ifo]
  for ism = 1, #tT do
    local x = tT[ism]
    local s, y = pcall(foo, x)
    if(not s) then error("Error: ["..ifo.."]["..ism.."]: "..y) end
    if(not y) then error("Value: ["..ifo.."]["..ism.."]: Empty sample!") end
    if(not tS.Dat[ifo]) then tS.Dat[ifo] = {} end
      tS.Dat[ifo][ism] = cpx.getNew(x,y)
    if(ifo == 1) then tS.Dat.Siz = ism end
  end
  tS.Tim[ifo] = 1000 * (os.clock() - now)
  tS.Act.Siz = ifo
  com.logStatus("Finish function ["..ifo.."] registration: "..tostring(foo))
end

if(tS) then
  com.logStatus("The amount of samples registered: "..tostring(tS.Dat.Siz))
  com.logStatus("The amount of functions registered: "..tostring(tS.Act.Siz))
  com.logStatus("The distance between every grey line on X is: "..tostring(dX))
  com.logStatus("The distance between every grey line on Y is: "..tostring(dY))
  
  local function drawComplexLine(S, E, Cl)
    local x1 = intX:Convert(S:getReal()):getValue()
    local y1 = intY:Convert(S:getImag()):getValue()
    local x2 = intX:Convert(E:getReal()):getValue()
    local y2 = intY:Convert(E:getImag()):getValue()
    pncl(Cl); line(x1, y1, x2, y2)
  end; cpx.setAction("ab", drawComplexLine)

  open("Graph compare")
  size(W,H); zero(0, 0); updt(false) -- disable auto updates

  scOpe:Draw(false, false, true, true)

  for ifo = 1, tS.Act.Siz do
    com.logStatus("Function time: "..tostring(tS.Tim[ifo]).."ms")
    for ism = 1, tS.Dat.Siz-1 do
      local c = tS.Dat[ifo][ism]
      local n = tS.Dat[ifo][ism+1]
      c:Action("ab",  n, tS.Cor[ifo] or clR)
      scOpe:drawComplexPoint(c)
      updt(); wait(0.001)
    end
  end 
  
  wait()
else
  common.logStatus("Your curve parameters are invalid !")
end