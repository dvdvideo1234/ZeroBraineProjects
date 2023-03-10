local testexec = {}

local metaexec = {}
metaexec.ftime = "%H:%M:%S"
metaexec.secto = "%02d:%02d:%02d"
metaexec.outfi = "Output set to: %s"
metaexec.start = "Started %d tast cases for %d functions..."
metaexec.ffins = "Test finished all %d cases successfully!"
metaexec.ffina = "Test finished %d of %d cases successfully!"
metaexec.ffina = "Test case <%s> with fail rate: %d%"
metaexec.ffspc = {"Estimation for [%", "s]: %s"}
metaexec.nocnt = "No test card count `stCard.Cnt` for test ID # %d!"
metaexec.nocyc = "No test card cycles `stCard.Cyc` for test ID # %d!"
metaexec.nocas = "Test case name <%s> already done under ID # %s!"
metaexec.sumry = "Overall testing rank list summary:"
metaexec.tfail = "The following tests have failed. Please check!"
metaexec.ffail = "%3.3f Time: %3.3f (%5.3f[s]) %15.3f[c/s] Failed: %d"
 
local function logStatus(anyMsg, ...)
  io.write(tostring(anyMsg)); return ...
end

local function getMaxNameLength(stEstim)
  local iMax, iEnd = 0, #stEstim
  for ID = 1, #stEstim do
    local tCase = stEstim[ID]
    if(tCase and tCase.Name) then
      if(tCase.Name:len() >= iMax) then
        iMax = tCase.Name:len()
      end
    end
  end; return iMax, iEnd
end

function testexec.Case(fFunction, sName)
  return {Function = fFunction, Name = sName, Times = {}, Rolled = {}}
end

function testexec.Time(sec)
  local iH = (sec - (sec % 3600)) / 3600
  local iM = (sec - (iH * 3600))
        iM = (iM  - (iM % 60)) / 60
  local iS = (sec - iM * 60 - iH * 3600)
  return (metaexec.secto):format(iH,iM,iS)
end

function testexec.Run(stCard,stEstim)
  if(stCard.OuFile) then
    logStatus(metaexec.outfi:format(stCard.OuFile).."\n", nil)
    io.output(stCard.OuFile)
  end
  local iTime, bStar = os.clock(), true
  local iCard, tFoo, iStar, nStar = #stCard, {}
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
    if(fooCnt < 1) then logStatus(metaexec.nocnt:format(ID).."\n", nil); return end
    if(fooCyc < 1) then logStatus(metaexec.nocyc:format(ID).."\n", nil); return end
    if(tCase[tstNam]) then logStatus(metaexec.nocas:format(tstNam, tostring(tCase[tstNam])).."\n", nil); return; end
    logStatus("Testing case["..tostring(ID).."]: <"..tostring(tstNam)..">\n", nil)
    logStatus(" Input: <"..tostring(fooVal)..">\n", nil)
    logStatus("Output: <"..tostring(fooRes)..">\n", nil)
    logStatus(" Tests: {"..tostring(fooCnt)..", "..tostring(fooCyc).."}\n", nil)
    if(stCard.ExPercn) then nStar = fooCnt*iEstm; iStar = stCard.ExPercn*nStar
      logStatus("Proces: {"..tostring(stCard.ExPercn*100).."%, "..tostring(fooCnt*stCard.ExPercn).."}\n", nil)
    end
    local idx, mrkCnt = 1, 0 -- Current iteration
    for idx = 1, fooCnt do -- Repeat each test
      for cnt = 1, iEstm  do -- For all functions
        local fnc = stEstim[cnt]
        if(not fnc.Times[tstNam]) then fnc.Times[tstNam] = 0 end
        if(not fnc.Rolled[tstNam]) then
          fnc.Rolled[tstNam] = {}
          fnc.Rolled[tstNam]["PASS"] = 0
          fnc.Rolled[tstNam]["FAIL"] = 0
        end
        local tRoll = fnc.Rolled[tstNam]
        local nTime = os.clock()
        for Ind = 1, fooCyc do -- N Cycles
          local Rez = fnc.Function(fooVal)
          if(Rez == fooRes) then tRoll["PASS"] = tRoll["PASS"] + 1 else
            if(not tstFail.Hash[tstNam][1]) then
              tstFail.Hash[tstNam][1] = true
              tstFail.Cnt = tstFail.Cnt + 1
            end
            tRoll["FAIL"] = tRoll["FAIL"] + 1
          end
        end
        fnc.Times[tstNam] = fnc.Times[tstNam] + (os.clock() - nTime)
        if(stCard.ExPercn) then mrkCnt = mrkCnt + 1
          if(mrkCnt % iStar == 0) then logStatus(((mrkCnt/nStar)*100).."% ") end
        end
        if(bStar) then local iTimn = fnc.Times[tstNam]; bStar = false;
          logStatus("TimNow: {"..os.date(metaexec.ftime).."}\n", nil)
          logStatus("TimCnt: {"..testexec.Time(iTimn).."} ("..iTimn..")\n", nil)
          logStatus("TimCyc: {"..testexec.Time(iTimn * fooCnt).."} ("..(iTimn * fooCnt)..")\n", nil)
        end
        if(stCard.AcTime and (os.clock() - iTime) > stCard.AcTime) then iTime = os.clock(); logStatus(".") end
      end
    end; logStatus("Done\n")
    local nMin = stEstim[1].Times[tstNam]
    for cnt = 1, iEstm do  -- For all functions
      local fnc = stEstim[cnt]
      if(fnc.Times[tstNam] <= nMin) then nMin = fnc.Times[tstNam] end
    end
    for cnt = 1, iEstm do  -- For all functions
      local fnc = stEstim[cnt]
      local nAll = (fooCnt * fooCyc)
      local nPas = ((100 * fnc.Rolled[tstNam]["PASS"]) / nAll)
      local nFal = ((100 * fnc.Rolled[tstNam]["FAIL"]) / nAll)
      local nTim = fnc.Times[tstNam]
      local nTip =  (nMin ~= 0) and (100 * (nTim / nMin)) or 0
      local sDat = metaexec.ffail:format(nPas,nTip,nTim,(fooCnt*fooCyc/nTim),nFal)
      if(not tFoo[fnc.Name]) then tFoo[fnc.Name] = 0 end; tFoo[fnc.Name] = tFoo[fnc.Name] + nTim
      tstFail.Hash[tstNam][2] = nFal
      logStatus((metaexec.ffspc[1]..iMaxL..metaexec.ffspc[2]):format(fnc.Name, sDat).."\n", nil)
    end; tCase[tstNam] = ID;
    logStatus("\n", nil)
    ID = ID + 1
  end
  if(tstFail.Cnt == 0) then
    logStatus(metaexec.ffins:format(iCard).."\n", nil)
  else
    logStatus(metaexec.ffina:format(iCard-tstFail.Cnt, iCard).."\n", nil)
    logStatus(metaexec.tfail.."\n", nil)
    for k, v in pairs(tstFail.Hash) do
      if(v[1]) then logStatus(metaexec.ffina:format(k, v[2]).."\n", nil) end
    end
  end
  logStatus(metaexec.sumry.."\n")
  for Key, Val in pairs(tFoo) do 
    logStatus("["..("%15.3f"):format(Val).."]: "..tostring(Key).."\n") end
end

return testexec
