require("turtle")
require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/pidloop")

local W, H = 500, 250
local To   = 0.04
local Intv = 194
open("PID trasition process")
size(W,H)
zero(0, 0) 
updt(false) -- disable auto updates

local PID = newControl(To, "Test"):Setup({0.1, 0.5, 8, -1000, 1000}, true):setPower(1,1,1):Dump()

logStatus(nil,"PID:"..tostring(getmetatable(PID)))

local X, Ctr = {0, 0}, {0, 0}
local PVStep = -2 -- PID must workout this value ( positive )
local Ref, PV = 50, {0, H}
local Tol = {Ref+0.05*Ref, Ref-0.05*Ref}

pncl(colr(0, 0, 255)); line(0,Ref,W,Ref); updt() 

local err = {}
local a = (-198^1.01)
local b = ( 198^1.01)
local c = ( 0^1.01)

logStatus(nil,"-------------Pow: {"..a..","..b..","..c.."}")

while(X[2] <= W) do
  Delay(0.03)
  Ctr[1] = Ctr[2]
  X[1]   = X[2]
  PV[1]  = PV[2]
  
  PV[2] = PV[2] + PVStep
  if(PV[2] < 0) then PV[2] = 0 end
  if(PV[2] > H) then PV[2] = H end
  Ctr[2] = PID:Process(Ref, PV[2]):getControl()
  err[1], err[2] = PID:getError()
  PV[2] = PV[2] + Ctr[2]
  X[2] = X[1] + (W/Intv);
  pncl(colr(255, 0, 255)); line(X[1],PV[1]+PVStep,X[2],PV[2]+PVStep); updt()
  pncl(colr(0, 255, 0)); line(X[1],Ctr[1]+Ref+PVStep,X[2],Ctr[2]+Ref+PVStep); updt()
  logStatus(nil, "Con: "..Ctr[2])
end




