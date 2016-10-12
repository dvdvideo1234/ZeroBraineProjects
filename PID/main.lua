require("turtle")
require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/pidloop")

local W, H = 500, 250
local To   = 0.04
local Intv = 50
open("PID trasition process")
size(W,H)
zero(0, 0)
updt(false) -- disable auto updates

local PID = newControl(To, "Test"):Setup({0.15, 0.2, 0.6, -1000, 1000}, true):setPower(1.3,0.95,0.98):Dump()

logStatus(nil,"PID:"..tostring(getmetatable(PID)))

local Smp, Ctr, Err = {0, 0}, {0, 0}, {0, 0}
local PVStep = -2 -- PID must workout this value ( positive )
local Ref, PV = 50, {0, H}

pncl(colr(0, 0, 255)); line(0,Ref,W,Ref); updt()

local xyCon, xyPV = {x=0,y=0}, {x=0,y=0}

while(Smp[2] <= W) do
  Delay(0.03)
  Ctr[1] = Ctr[2]
  Smp[1]   = Smp[2]
  PV[1]  = PV[2]
  PV[2] = PV[2] + PVStep
  if(PV[2] < 0) then PV[2] = 0 end
  if(PV[2] > H) then PV[2] = H end
  Ctr[2] = PID:Process(Ref, PV[2]):getControl()
  Err.x, Err.y = PID:getError()
  PV[2] = PV[2] + Ctr[2]
  Smp[2] = Smp[1] + (W/Intv);
  xyCon.x = Smp[2]; xyPV.x = Smp[2]
  xyCon.y = Ctr[2]+Ref; xyPV.y =  PV[2]
  pncl(colr(255, 0, 255)); line(Smp[1],PV[1]+PVStep,Smp[2],PV[2]+PVStep); xyPlot(xyPV); updt()
  pncl(colr(0, 255, 0)); line(Smp[1],Ctr[1]+Ref+PVStep,Smp[2],Ctr[2]+Ref+PVStep); xyPlot(xyCon); updt()
  logStatus(nil, "Con: "..Ctr[1])
end




