require("turtle")
require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/pidloop")

local minC, maxC = -200, 200
local W, H  = 500, 250
local To    = 0.015
local endTm = 2
local intX  = newInterval("WinX",  0,endTm, 0, W)
local intY  = newInterval("WinY",minC,maxC , H, 0)
local APR   = newUnit({1},{2, 1})
local PID   = newControl(To, "Test"):Setup({0.240, 0.143, 55.6, minC, maxC}, true):setPower(1.275,0.69,0.95):Dump()

local trRec = newTracer("Ref"):setInterval(intX, intY)
local trCon = newTracer("Con"):setInterval(intX, intY)
local trPV  = newTracer("PV" ):setInterval(intX, intY)

open("PID trasition process")
size(W,H)
zero(0, 0)
updt(false) -- disable auto updates

local clRed = colr(255,0,0)
local clGrn = colr(0,255,0)
local clBlu = colr(0,0,255)

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
  con = PID:Process(ref,pvv):getControl()
  trCon:putValue(curTm,con):Draw(clGrn)
       pvv = pvv + con
  trPV:putValue(curTm, pvv):Draw(clRed)
  curTm = curTm + To
end

