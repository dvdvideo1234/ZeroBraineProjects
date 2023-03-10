local testexec = {}

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
  return ("%02d:%02d:%02d"):format(iH,iM,iS)
end

function testexec.Run(stCard,stEstim)
  if(stCard.OuFile) then
    logStatus("Output set to: "..stCard.OuFile.."\n", nil)
    io.output(stCard.OuFile)
  end
  local iTime, bStar = os.clock(), true
  local iCard, tFoo, iStar, nStar = #stCard, {}
  local iMaxL, iEstm = getMaxNameLength(stEstim)
  logStatus("Started "..tostring(iCard).." tast cases for "..tostring(iEstm).." functions...\n", nil)
  local ID, tCase, tstFail = 1, {}, {Cnt = 0, Hash = {}} -- No tests have hailed
  while(stCard[ID]) do -- Loop trough all the test cards
    local tstVal = stCard[ID] -- Retrieve the test card information
    local fooVal = tstVal[2] -- The test is not failed yet. Read the input value
    local fooRes = tstVal[3] -- The test is not failed yet. Read the output value
    local tstNam = tostring(tstVal[1] or ""); tstFail.Hash[tstNam] = {false, 0}
    local fooCnt = tonumber(stCard.FnCount) or 0 -- Amount of loops to be done for the test card
    local fooCyc = tonumber(stCard.FnCycle) or 0 -- Amount of loops to be done for the function tested
    if(fooCnt < 1) then logStatus("No test card count  stCard.Cnt for test ID # "..tostring(ID).."!\n", nil); return end
    if(fooCyc < 1) then logStatus("No test card cycles stCard.Cyc for test ID # "..tostring(ID).."!\n", nil); return end
    if(tCase[tstNam]) then logStatus("Test case name <"..tstNam.."> already done under ID # "..tostring(tCase[tstNam]).."!\n", nil); return; end
    logStatus("Testing case["..tostring(ID).."]: <"..tostring(tstNam)..">\n", nil)
    logStatus("   Inp: <"..tostring(fooVal)..">\n", nil)
    logStatus("   Out: <"..tostring(fooRes)..">\n", nil)
    logStatus("   Set: {"..tostring(fooCnt)..", "..tostring(fooCyc).."}\n", nil)
    if(stCard.ExPercn) then nStar = fooCnt*iEstm; iStar = stCard.ExPercn*nStar
      logStatus("   Pro: {"..tostring(stCard.ExPercn*100).."%, "..tostring(fooCnt*stCard.ExPercn).."}\n", nil)
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
          logStatus("   Now: {"..os.date('%H:%M:%S').."}\n", nil)
          logStatus("   Ttm: {"..testexec.Time(iTimn).."} ("..iTimn..")\n", nil)
          logStatus("   Atm: {"..testexec.Time(iTimn * fooCnt).."} ("..(iTimn * fooCnt)..")\n", nil)
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
      local sNam = "Estimation for ["..("%"..iMaxL.."s"):format(fnc.Name).."]: "
      local sDat = string.format("%3.3f Time: %3.3f (%5.3f[s]) %15.3f[c/s] Failed: %d",nPas,nTip,nTim,(fooCnt*fooCyc/nTim),nFal)
      if(not tFoo[fnc.Name]) then tFoo[fnc.Name] = 0 end; tFoo[fnc.Name] = tFoo[fnc.Name] + nTim
      tstFail.Hash[tstNam][2] = nFal
      logStatus(sNam..sDat.."\n", nil)
    end; tCase[tstNam] = ID;
    logStatus("\n", nil)
    ID = ID + 1
  end
  if(tstFail.Cnt == 0) then
    logStatus("Test finished all "..tostring(iCard).." cases successfully!\n", nil)
  else
    logStatus("Test finished "..tostring(iCard-tstFail.Cnt).." of "..tostring(iCard).." cases successfully!\n", nil)
    logStatus("The following tests have failed. Please check!\n", nil)
    for k, v in pairs(tstFail.Hash) do
      if(v[1]) then logStatus("Test case <"..k.."> with fail rate: "..tostring(v[2]).."%\n", nil) end
    end
  end
  logStatus("Overall testing rank list summary:\n")
  for Key, Val in pairs(tFoo) do 
    logStatus("["..("%15.3f"):format(Val).."]: "..tostring(Key).."\n") end
end

return testexec
