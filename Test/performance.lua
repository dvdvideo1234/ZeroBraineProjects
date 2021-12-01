local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

local com = require("common")

function logStatus(anyMsg, ...)
  io.write(tostring(anyMsg).."\n"); return ...
end

function logStatusLine(anyMsg, ...)
  io.write(tostring(anyMsg)); return ...
end

function addEstim(fFunction, sName)
  return {Function = fFunction, Name = sName, Times = {}, Rolled = {}}
end

function testPerformance(stCard,stEstim,sFile,nMrkP)
  if(sFile) then
    logStatus("Output set to: "..sFile, nil)
    io.output(sFile)
  end
  local tstCas, tstEst, rnkFoo = #stCard, #stEstim, {}
  logStatus("Started "..tostring(tstCas).." tast cases for "..tostring(tstEst).." functions", nil)
  local TestID, Cases, tstFail = 1, {}, {Cnt = 0, Hash = {}} -- No tests have hailed
  while(stCard[TestID]) do -- All tests
    local tstVal = stCard[TestID]
    local fooVal = tstVal[1]
    local fooRes = tstVal[2] -- The test is not failed yet
    local tstNam = tostring(tstVal[3] or ""); tstFail.Hash[tstNam] = {false, 0}
    local fooCnt = tonumber(tstVal[4]) or 0  -- Repeat each test
    local fooCyc = tonumber(tstVal[5]) or 0
    local mrkFoo = (tonumber(nMrkP) or 0); mrkFoo = (((mrkFoo > 0) and (mrkFoo < 1)) and mrkFoo or nil)
    local mrkCyc = (mrkFoo and (fooCnt * mrkFoo * tstEst) or nil)
    if(fooCnt < 1) then logStatus("No test-card count  stCard.Cnt for test ID # "..tostring(TestID), nil); return end
    if(fooCyc < 1) then logStatus("No test-card cycles stCard.Cyc for test ID # "..tostring(TestID), nil); return end
    if(Cases[tstNam]) then logStatus("Test case name <"..tstNam.."> already chosen under ID # "..tostring(Cases[tstNam]), nil); return; end
    logStatus("Testing case["..tostring(TestID).."]: <"..tostring(tstVal[3])..">", nil)
    logStatus("   Inp: <"..tostring(tstVal[1])..">", nil)
    logStatus("   Out: <"..tostring(tstVal[2])..">", nil)
    logStatus("   Set: { "..tostring(fooCnt)..", "..tostring(fooCyc).." }", nil)
    if(mrkFoo) then
      logStatus("   Pro: { "..tostring(mrkFoo*100).."%, "..tostring(fooCnt*tstEst).."} ", nil) end
    local Itr, mrkCnt = 1, 0 -- Current iteration
    for Itr = 1, fooCnt, 1 do -- Repeat each test
      for Est = 1, tstEst  do -- For all functions
        local Foo = stEstim[Est]
        if(not Foo.Times[tstNam]) then Foo.Times[tstNam] = 0 end
        if(not Foo.Rolled[tstNam]) then
          Foo.Rolled[tstNam] = {}
          Foo.Rolled[tstNam]["PASS"] = 0
          Foo.Rolled[tstNam]["FAIL"] = 0
        end
        local Roll = Foo.Rolled[tstNam]
        local Time = os.clock()
        for Ind = 1, fooCyc do -- N Cycles
          local Rez = Foo.Function(fooVal)
          if(Rez == fooRes) then Roll["PASS"] = Roll["PASS"] + 1 else
            if(not tstFail.Hash[tstNam][1]) then
              tstFail.Hash[tstNam][1] = true
              tstFail.Cnt = tstFail.Cnt + 1
            end
            Roll["FAIL"] = Roll["FAIL"] + 1
          end
        end
        Foo.Times[tstNam] = Foo.Times[tstNam] + (os.clock() - Time)
        -- logStatus("{"..tostring(mrkFoo)..","..tostring(mrkCyc)..","..tostring(mrkCnt).."}")
        mrkCnt = mrkCnt + 1; if(mrkCyc and (mrkCnt % mrkCyc == 0)) then logStatusLine((mrkCnt/(fooCnt*tstEst)*100).."% ") end
      end
    end; logStatus("Done")
    local Min = stEstim[1].Times[tstNam]
    for Est = 1, tstEst do  -- For all functions
      local Foo = stEstim[Est]
      if(Foo.Times[tstNam] <= Min) then Min = Foo.Times[tstNam] end
    end
    for Est = 1, tstEst do  -- For all functions
      local Foo = stEstim[Est]
      local All = (fooCnt * fooCyc)
      local Pas = ((100 * Foo.Rolled[tstNam]["PASS"]) / All)
      local Fal = ((100 * Foo.Rolled[tstNam]["FAIL"]) / All)
      local Tim = Foo.Times[tstNam]
      local Tip =  (Min ~= 0) and (100 * (Tim / Min)) or 0
      local Nam = "Estimation for ["..Foo.Name.."]: "
      local Dat = string.format("%3.3f Time: %3.3f (%5.3f[s]) %15.3f[c/s] Failed: %d",Pas,Tip,Tim,(fooCnt*fooCyc/Tim),Fal)
      if(not rnkFoo[Foo.Name]) then rnkFoo[Foo.Name] = 0 end; rnkFoo[Foo.Name] = rnkFoo[Foo.Name] + Tim
      tstFail.Hash[tstNam][2] = Fal
      logStatus(Nam..Dat, nil)
    end; Cases[tstNam] = TestID;
    logStatus("", nil)
    TestID = TestID + 1
  end
  if(tstFail.Cnt == 0) then
    logStatus("Test finished all "..tostring(tstCas).." cases successfully", nil)
  else
    logStatus("Test finished "..tostring(tstCas-tstFail.Cnt).." of "..tostring(tstCas).." cases successfully", nil)
    logStatus("The following tests have failed. Please check", nil)
    for k, v in pairs(tstFail.Hash) do
      if(v[1]) then logStatus("Test case <"..k.."> with fail rate: "..tostring(v[2]).."%", nil) end
    end
  end
  logStatus("Overall testing rank list summary:")
  for Key, Val in pairs(rnkFoo) do 
    logStatus("["..("%15.3f"):format(Val).."]: "..tostring(Key)) end
end

local idx, bri = 5, true

local function f1(a)
  for cnt = (bri and idx or 1), 10 do
  
  end
end

local function f2(a)
  local i = (bri and idx or 1)
  for cnt = i, 10 do
  
  end
end

local function f3(a)
  idx = (bri and idx or 1)
  for cnt = idx, 10 do
  
  end
end

local stEstim = {
  addEstim(f1, "old"),
  addEstim(f2, "new"),
  addEstim(f2, "idx")
}

local stCard = {
  {{1, 2}, 3 , "Number", 10000, 10000, .2},
}

 testPerformance(stCard,stEstim,nil,0.1)
