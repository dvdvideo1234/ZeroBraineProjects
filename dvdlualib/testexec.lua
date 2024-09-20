local testexec = {}

local metaexec = {}
metaexec.ftime = "%H:%M:%S"
metaexec.secto = "%02d:%02d:%02d"
metaexec.outfi = "Output set to: %s"
metaexec.start = "Started %d test cases for %d functions..."
metaexec.ffins = "Test finished all %d cases successfully!"
metaexec.ffinc = "Test finished %d of %d cases successfully!"
metaexec.ffina = "Test case <%s> with fail rate: %d%%"
metaexec.ffspc = {"Estimation for [%", "s]: %s"}
metaexec.nocnt = "No test card count `stCard.%s` for test ID # %d!"
metaexec.nocyc = "No test card cycles `stCard.%s` for test ID # %d!"
metaexec.nocas = "Test case name <%s> already done under ID # %s!"
metaexec.sumry = "Overall testing rank list summary:"
metaexec.tfail = "The following tests have failed. Please check!"
metaexec.ffail = "%10.3f Time: %10.3f (%10.3f[s]) %15.3f[c/s] Failed: %d"
metaexec.upcnt = "Updating input count to `N=%d`!"
metaexec.tcase = "Testing case [%d]: <%s>"
metaexec.alsum = {"[%15.3f]: %s", " +%5.2f"}

local function logStatus(anyMsg, ...)
  io.write(tostring(anyMsg)); return ...
end

local function getMaxNameLength(stEstim)
  local iMax, iEnd = 0, #stEstim
  for ID = 1, #stEstim do
    local tCase = stEstim[ID]
    if(tCase and tCase.Na) then
      if(tCase.Na:len() >= iMax) then
        iMax = tCase.Na:len()
      end
    end
  end; return iMax, iEnd
end

function testexec.Case(fFunc, sName)
  if(type(fFunc) ~= "function") then return end
  return {Func = fFunc, Na = sName, Tm = {}, Ro = {}}
end

function testexec.Time(sec)
  local iH = (sec - (sec % 3600)) / 3600
  local iM = (sec - (iH * 3600))
        iM = (iM  - (iM % 60)) / 60
  local iS = (sec - iM * 60 - iH * 3600)
  return (metaexec.secto):format(iH,iM,iS)
end

function testexec.Run(stCard, stEstim)
  if(stCard.OuFile) then
    logStatus(metaexec.outfi:format(stCard.OuFile).."\n", nil)
    io.output(stCard.OuFile)
  end
  local iTime, bStar = os.clock(), true
  local iCard, tFoo, iStar, nStar = #stCard, {Da = {}}
  local iMaxL, iEstm = getMaxNameLength(stEstim)
  logStatus(metaexec.start:format(iCard, iEstm).."\n", nil)
  local ID, tCase, tstFail = 1, {}, {Cnt = 0, Hash = {}} -- No tests have hailed
  while(stCard[ID]) do -- Loop trough all the test cards
    local tstVal = stCard[ID] -- Retrieve the test card information
    local fooVal = tstVal[2] -- The test is not failed yet. Read the input value
    local fooRes = tstVal[3] -- The test is not failed yet. Read the output value
    local tstNam = tostring(tstVal[1] or ""); tstFail.Hash[tstNam] = {false, 0}
    local fooCnt = tonumber(stCard.FnCount) or 0 -- Amount of loops to be done for the test card
    local fooCyc = tonumber(stCard.FnCycle) or 0 -- Amount of loops to be done for the function tested
    if(fooCnt < 1) then logStatus(metaexec.nocnt:format("FnCount",ID).."\n", nil); return end
    if(fooCyc < 1) then logStatus(metaexec.nocyc:format("FnCycle",ID).."\n", nil); return end
    if(tCase[tstNam]) then logStatus(metaexec.nocas:format(tstNam, tostring(tCase[tstNam])).."\n", nil); return; end
    logStatus(metaexec.tcase:format(ID, tstNam).."\n", nil)
    if(type(fooVal) == "table") then
      local sA = ""; fooVal.N = tonumber(fooVal.N)
      if(not fooVal.N) then fooVal.N = #fooVal
        logStatus(metaexec.upcnt:format(#fooVal).."\n", nil) end
      for iV = 1, fooVal.N do sA = sA..tostring(fooVal[iV])
        if(iV ~= fooVal.N) then sA = sA.."," end
      end; logStatus(" Input: {"..sA.."}\n", nil)
    else logStatus(" Input: {"..tostring(fooVal).."}\n", nil) end    
    if(type(fooRes) == "table") then
      local sA = ""; fooRes.N = tonumber(fooRes.N)
      if(not fooRes.N) then fooRes.N = #fooRes
        logStatus(metaexec.upcnt:format(#fooRes).."\n", nil) end
      for iR = 1, fooRes.N do sA = sA..tostring(fooRes[iR])
        if(iR ~= fooRes.N) then sA = sA.."," end
      end; logStatus("Output: {"..sA.."}\n", nil)
    else logStatus("Output: {"..tostring(fooRes).."}\n", nil) end
    logStatus(" Tests: {"..tostring(fooCnt)..", "..tostring(fooCyc).."}\n", nil)
    if(stCard.ExPercn) then nStar = fooCnt*iEstm; iStar = stCard.ExPercn*nStar
      logStatus("Process: {"..tostring(stCard.ExPercn*100).."%, "..tostring(fooCnt*stCard.ExPercn).."}\n", nil)
    end
    local idx, mrkCnt = 1, 0 -- Current iteration
    for idx = 1, fooCnt do -- Repeat each test
      for cnt = 1, iEstm  do -- For all functions
        local fnc = stEstim[cnt]
        if(not fnc.Tm[tstNam]) then fnc.Tm[tstNam] = 0 end
        if(not fnc.Ro[tstNam]) then
          fnc.Ro[tstNam] = {}
          fnc.Ro[tstNam]["PASS"] = 0
          fnc.Ro[tstNam]["FAIL"] = 0
        end
        local tRoll = fnc.Ro[tstNam]
        local nTime = os.clock()
        for inx = 1, fooCyc do -- N Cycles
          local Rez = fnc.Func(fooVal)
          if(Rez == fooRes) then tRoll["PASS"] = tRoll["PASS"] + 1 else
            if(not tstFail.Hash[tstNam][1]) then
              tstFail.Hash[tstNam][1] = true
              tstFail.Cnt = tstFail.Cnt + 1
            end
            tRoll["FAIL"] = tRoll["FAIL"] + 1
          end
        end
        fnc.Tm[tstNam] = fnc.Tm[tstNam] + (os.clock() - nTime)
        if(stCard.ExPercn) then mrkCnt = mrkCnt + 1
          if(mrkCnt % iStar == 0) then logStatus(((mrkCnt/nStar)*100).."% ") end
        end
        if(bStar) then local iTimn = fnc.Tm[tstNam]; bStar = false;
          logStatus("TimNow: {"..os.date(metaexec.ftime).."}\n", nil)
          logStatus("TimCnt: {"..testexec.Time(iTimn).."} ("..iTimn..")\n", nil)
          logStatus("TimCyc: {"..testexec.Time(iTimn * fooCnt).."} ("..(iTimn * fooCnt)..")\n", nil)
        end
        if(stCard.AcTime and (os.clock() - iTime) > stCard.AcTime) then iTime = os.clock(); logStatus(".") end
      end
    end; logStatus("Done\n")
    local nMin = stEstim[1].Tm[tstNam]
    for cnt = 1, iEstm do  -- For all functions
      local fnc = stEstim[cnt]
      if(fnc.Tm[tstNam] <= nMin) then nMin = fnc.Tm[tstNam] end
    end
    for cnt = 1, iEstm do  -- For all functions
      local fnc = stEstim[cnt]
      local nTim = fnc.Tm[tstNam]
      local nAll = (fooCnt * fooCyc)
      local nPas = ((100 * fnc.Ro[tstNam]["PASS"]) / nAll)
      local nFal = ((100 * fnc.Ro[tstNam]["FAIL"]) / nAll)
      local nTip =  (nMin ~= 0) and (100 * (nTim / nMin)) or 0
      local sDat = metaexec.ffail:format(nPas,nTip,nTim,(fooCnt*fooCyc/nTim),nFal)
      if(not tFoo.Da[fnc.Na]) then tFoo.Da[fnc.Na] = 0 end
      tFoo.Da[fnc.Na] = tFoo.Da[fnc.Na] + nTim
      tstFail.Hash[tstNam][2] = nFal
      logStatus((metaexec.ffspc[1]..iMaxL..metaexec.ffspc[2]):format(fnc.Na, sDat).."\n", nil)
    end; tCase[tstNam] = ID;
    logStatus("\n", nil)
    ID = ID + 1
  end
  if(tstFail.Cnt == 0) then
    logStatus(metaexec.ffins:format(iCard).."\n", nil)
  else
    logStatus(metaexec.ffinc:format(iCard-tstFail.Cnt, iCard).."\n", nil)
    logStatus(metaexec.tfail.."\n", nil)
    for k, v in pairs(tstFail.Hash) do
      if(v[1]) then logStatus(metaexec.ffina:format(k, v[2]).."\n", nil) end
    end
  end
  logStatus(metaexec.sumry.."\n")
  for k, v in pairs(tFoo.Da) do
    if(not tFoo.Sz) then tFoo.Sz = 0 end
    if(not tFoo.Mn or tFoo.Mn > v) then tFoo.Mn = v end
    if(not tFoo.Kx or tFoo.Kx < k:len()) then tFoo.Kx = k:len() end
    tFoo.Sz = tFoo.Sz + 1; tFoo[tFoo.Sz] = k
  end
  table.sort(tFoo, function(u, v) return tFoo.Da[u] < tFoo.Da[v] end)
  for iD = 1, tFoo.Sz do
    local sK = tFoo[iD]
    local nV = tFoo.Da[sK]
    local nP = ((100 * nV / tFoo.Mn) - 100)
    if(math.abs(nP) < 1e-10) then
      logStatus(metaexec.alsum[1]:format(nV, sK).."\n")
    else
      local sP = string.rep(" ", tFoo.Kx - sK:len())
      logStatus(metaexec.alsum[1]:format(nV, sK)..sP..metaexec.alsum[2]:format(nP).."%\n")
    end
  end
end

local mtExec = {}
      mtExec.__index = mtExec
      mtExec.__defcase = "case[%d]"
      mtExec.__defcard = "card[%d]"
function testexec.New()
  local self = {}; setmetatable(self, mtExec)
  local stCard, stEstim = {}, {}
  function self:runMeasure(stC, stE)
    testexec.Run(stC or stCard, stE or stEstim)
  end
  function self:setCase(fActf, sName)
    if(type(fActf) ~= "function") then return self end
    local sName = tostring(sName or mtExec.__defcase:format(#stEstim + 1))
    table.insert(stEstim, testexec.Case(fActf, sName)); return self
  end
  function self:setCard(vIn, vOut, sName)
    local sName = tostring(sName or mtExec.__defcard:format(#stCard + 1))
    table.insert(stCard, {sName, vIn, vOut}); return self
  end
  function self:setOutput(sName)
    if(sName) then stCard.OuFile = tostring(sName) else stCard.OuFile = nil end
    return self
  end
  function self:setProgress(vAct, vPer)
    local nAct, nPer = tonumber(vAct), tonumber(vPer)
    if(nAct and nAct >= 0) then stCard.AcTime  = nAct else stCard.AcTime  = nil end
    if(nPer and nPer >= 0) then stCard.ExPercn = nPer else stCard.ExPercn = nil end
    return self
  end
  function self:setCount(vCnt, vCyc)
    local nCnt, nCyc = tonumber(vCnt), tonumber(vCyc)
    if(nCnt and nCnt > 0) then stCard.FnCount = nCnt else stCard.FnCount = nil end
    if(nCyc and nCyc > 0) then stCard.FnCycle = nCyc else stCard.FnCycle = nil end
    return self
  end
  return self 
end

return testexec
