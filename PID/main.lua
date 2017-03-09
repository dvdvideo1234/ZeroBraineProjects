require("turtle")
require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/pidloop")
require("ZeroBraineProjects/dvdlualib/colormap")

local W, H  = 1024, 464

local minC, maxC = -50000, 50000
local To    = 0.0006
local endTm = 0.2
local intX  = newInterval("WinX",  0,endTm, 0, W)
local intY  = newInterval("WinY",-200,200 , H, 0)
local APR   = newUnit(To,{0.904},{1.00, -0.569},"Aperiodic plant"):Dump()
local PID   = newControl(To, "Test"):Setup({0.653, 0.005, 43.3, minC, maxC}):setStruct(true,false):Dump()

local trRef = newTracer("Ref"):setInterval(intX, intY)
local trCon = newTracer("Con"):setInterval(intX, intY)
local trPV  = newTracer("PV" ):setInterval(intX, intY)

open("Trasition processes")
size(W,H)
zero(0, 0)
updt(false) -- disable auto updates

local clRed = colr(getColorRedRGB())
local clGrn = colr(getColorGreenRGB())
local clBlu = colr(getColorBlueRGB())
local clBlk = colr(getColorBlackRGB())

local pvv, con, ref = 0, 0, 100

local curTm = 0
while(curTm <= endTm) do
  waitSeconds(To)
  ----------------------
  if(curTm > 0.3*endTm and curTm <= 0.6*endTm) then
    ref = -100
  elseif(curTm > 0.6*endTm) then
    ref = 100
  end
  trRef:putValue(curTm, ref):Draw(clBlu)
  logStatus(nil,ref.." > "..pvv.." > "..con)
  con = PID:Process(ref,pvv):getControl()
  trCon:putValue(curTm,con):Draw(clGrn)
  pvv = APR:Process(con):getOutput()
  trPV:putValue(curTm, pvv):Draw(clRed)
  curTm = curTm + To
end

