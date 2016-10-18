require("turtle")
require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/pidloop")
require("ZeroBraineProjects/dvdlualib/colormap")

local W, H  = 500, 250

local minC, maxC = -5000, 5000
local To    = 0.0001
local endTm = 0.02
local intX  = newInterval("WinX",  0,endTm, 0, W)
local intY  = newInterval("WinY",-200,200 , H, 0)
local APR   = newUnit(To,{0.904},{1.00, -0.569},"Aperiodic plant"):Dump()
local PID   = newControl(To, "Test"):Setup({0.229, 0.0013, 93.0, minC, maxC}, fase):Dump()

local trRec = newTracer("Ref"):setInterval(intX, intY)
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
  trRec:putValue(curTm, ref):Draw(clBlu)
  logStatus(nil,ref.." > "..pvv.." > "..con)
  con = PID:Process(ref,pvv):getControl()
  trCon:putValue(curTm,con):Draw(clGrn)
  pvv = APR:Process(con):getOutput()
  trPV:putValue(curTm, pvv):Draw(clRed)
  curTm = curTm + To
end

