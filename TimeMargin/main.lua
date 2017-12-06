require("ZeroBraineProjects/dvdlualib/common")

local getNow  = os.clock
local didTime = 1
local addTime = 2
local gsSentHash = "lady_gaga"
local varBroadCast = 5

function newTimer()
  self = {}
  function self:Init()
    self[gsSentHash] = {Rate={}, Rem = false}
    local oSent = self[gsSentHash]
    oSent.Rate.bcTot = varBroadCast -- Broadcast time sever-clients
    oSent.Rate.bcTim = varBroadCast -- Broadcast compare value
    oSent.Rate.thStO = 0 -- The time between each tick start (OLD)
    oSent.Rate.thStN = 0 -- The time between each tick start (NEW)
    oSent.Rate.thEnd = 0 -- The time when a tick exactly ends. Algorithm completion.
    oSent.Rate.thTim = 0 -- How much time does the think stuff requite (thEnd    - thSta[1]).
    oSent.Rate.thEvt = 0 -- How much time does the think event requite (thSta[1] - thSta[2]).
    oSent.Rate.thDet = 0 -- Tick duty cycle (thTim / thEvt * 100).
    oSent.Rate.isRdy = false -- Initialization flag. Dropped on the second think
    return self
  end
  function self:NotRemoved() return (not self[gsSentHash].Rem) end
  function self:Remove() self[gsSentHash].Rem = true end
  function self:Tic()
    local oSent = self[gsSentHash]
    local tmRate = oSent.Rate
    tmRate.thStO = tmRate.thStN-- The tick start time gets older [s]
    tmRate.thStN = getNow()         -- Read the new think start [s]
    if(tmRate.isRdy) then
      tmRate.thEvt = (tmRate.thStN - tmRate.thStO) -- Think event delta [s]
      tmRate.thTim = (tmRate.thEnd - tmRate.thStO) -- Think hook delta [s]
      tmRate.thDet = (tmRate.thTim / tmRate.thEvt) * 100 -- Think duty margin []
      if(tmRate.thTim >= tmRate.thEvt) then self:Remove()
        return logStatus("ENT.Tic: Duty margin fail ["..tostring(tmRate.thDet).."%]", self) end
      tmRate.bcTim = tmRate.bcTim - tmRate.thEvt         -- Update broadcast time [s]
      if(tmRate.bcTim <= 0) then tmRate.bcTim = tmRate.bcTot end
    end
  end
  function self:Toc()
    local oSent = self[gsSentHash]
    local tmRate = oSent.Rate
    tmRate.thEnd = getNow()
    if(not tmRate.isRdy) then tmRate.isRdy = true end
  end
  function self:DoStuff(T)
    waitSeconds(T)
    return self
  end
  function self:Think(T)
    self:Tic()
    self:DoStuff(T)
    self:Toc()
    return self:NotRemoved()
  end
  return self
end

local tim, id, sta, dt = newTimer():Init(), 1, true, 0

while(sta) do
  sta = tim:Think(1+dt);  waitSeconds(2-dt); logTable(tim, ("State_%d"):format(id))
  id = id + 1;
  dt = dt + 0.4;
end

print("Test complete !")

