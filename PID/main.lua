require("turtle")
require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/pidloop")

local W, H = 500, 250

open("PID trasition process")
size(W,H)
zero(0, 0) 
updt(false) -- disable auto updates

local PID = newControl(0.01, "Test"):Setup({0.03, 1, 0.02, -5, 8}, false):Dump()

local Time, Ctr = 0, 0
local PVStep = -2 -- PID must workout this value
local Ref, PV = 50, {H, 0}
local Tol = {Ref+0.05*Ref, Ref-0.05*Ref}

pncl(colr(0, 0, 255)); line(0,Ref,W,Ref); updt() 
pncl(colr(255, 0, 0)); line(0,Ref+0.05*Ref,W,Ref+0.05*Ref); updt() 
pncl(colr(255, 0, 0)); line(0,Ref-0.05*Ref,W,Ref-0.05*Ref); updt() 

while((Ctr + PVStep) ~= 0) do
  Delay(0.03)
  PV[2] = PV[1] + PVStep
  if(PV[2] < 0) then PV[2] = 0 end
  Ctr = PID:Process(Ref, PV[2]):getControl()
  PV[1] = PV[2] + Ctr
  Time = Time + 1;
  logStatus(nil,"Process "..RoundValue(PV[1],0.01).." / "..RoundValue(PV[2],0.01).." >> "..RoundValue(Ctr,0.01))
  pncl(colr(255, 0, 255)); line(Time-1,PV[1],Time,PV[2]); updt()
end




