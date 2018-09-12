local pairs     = pairs
local tonumber  = tonumber
local tostring  = tostring
local type      = type
local io        = io
local string    = string
local common    = {}

io.stdout:setvbuf("no")

function waitSeconds(Add)
-- NOTE: SYSTEM-DEPENDENT, adjust as necessary
  if(Add > 0) then
    local i=os.clock() + Add
    while(os.clock() < i) do end
  end
end

function logStatus(anyMsg, ...)
  io.write(tostring(anyMsg).."\n"); return ...
end

function logStatusLine(anyMsg, ...)
  io.write(tostring(anyMsg)); return ...
end

function xyText(xyP)
  return "{"..tostring(xyP.x)..","..tostring(xyP.y).."}"
end

function xyLog(xyP,anyMsg)
  logStatus(tostring(anyMsg or "")..xyText(xyP))
end

function xyPlot(xyP,clDrw)
  local x = xyP.x or xyP[1] or nil
  local y = xyP.y or xyP[2] or nil
  if(clDrw) then pncl(clDrw); end
  rect(x-2,y-2,5,5)
end

function logMulty(...)
  local line = "{"
  local args, i = {...}, 1
  while(args[i]) do
    line = line..tostring(args[i])
    if(args[i+1]) then line = line..", " end
    i = i + 1
  end; io.write(line.."}\n")
end

function logTable(tT,sS,tP)
  local vS, vT, vK, sS = type(sS), type(tT), "", tostring(sS or "Data")
  if(vT ~= "table") then
    return logStatus("{"..vT.."}["..tostring(sS or "Data").."] = <"..tostring(tT)..">") end
  if(next(tT) == nil) then
    return logStatus(sS.." = {}")
  end; logStatus(sS.." = {}")
  for k,v in pairs(tT) do
    if(type(k) == "string") then
      vK = sS.."[\""..k.."\"]"
    else
      sK = tostring(k)
      if(tP and tP[k]) then sK = tostring(tP[k]) end
      vK = sS.."["..sK.."]"
    end
    if(type(v) ~= "table") then
      if(type(v) == "string") then
        logStatus(vK.." = \""..v.."\"")
      else
        sK = tostring(v)
        if(tP and tP[v]) then sK = tostring(tP[v]) end
        logStatus(vK.." = "..sK)
      end
    else
      if(v == tT) then logStatus(vK.." = "..sS)
      else logTable(v,vK,tP) end
    end
  end
end

--------------- VALUES ---------------

function borderValue(nVal,nMin,nMax)
  if(type(nVal) ~= "number") then return nil end
  local Min = nMin or 0
  local Max = nMax or 0
  if(nMax > Max) then return Min end
  if(nMax < Min) then return Max end
  return nMax
end

function rollValue(nVal,nMin,nMax)
  if(type(nVal) ~= "number") then return nil end
  local Min = nMin or 0
  local Max = nMax or 0
  local Dif = Max-Min
  if(Dif ~= 0) then
    return nVal % Dif
  end
  return nMax
end

function clampValue(nVal,nMin,nMax)
  if(type(nVal) ~= "number") then return nil end
  local Min = nMin or 0
  local Max = nMax or 0
  if(nVal >= Max) then return Max end
  if(nVal <= Min) then return Min end
  return nVal
end

function roundValue(nvExact, nFrac)
  local nExact = tonumber(nvExact)
  if(not nExact) then
    return logStatus(nil,"RoundValue: Cannot round NAN {"..type(nvExact).."}<"..tostring(nvExact)..">") end
  local nFrac = tonumber(nFrac) or 0
  if(nFrac == 0) then
    return logStatus(nil,"RoundValue: Fraction must be <> 0") end
  local q, f = math.modf(nExact/nFrac)
  return nFrac * (q + (f > 0.5 and 1 or 0))
end

function getSignAnd(anyVal)
  local nVal = (tonumber(anyVal) or 0); return ((nVal > 0 and 1) or (nVal < 0 and -1) or 0)
end

function getSignAbs(anyVal)
  local nVal = (tonumber(anyVal) or 0); return (nVal and (nVal / math.abs(nVal)) or nil)
end

function getSignCon(anyVal)
  local nVal = (tonumber(anyVal) or 0)
  if(nVal > 0) then return  1 end
  if(nVal < 0) then return -1 end
  return nVal
end

function GetSEDValues(Val,Min,Max)
  local s = (Val > 0) and Min or Max
  local e = (Val > 0) and Max or Min
  local d = getSignAnd(e - s)
  return s, e, d
end

--------------- ARRAY MANIPULATION ---------------

--[[
  * Extends an array to a given length
  * tArr > The array
  * nCnt > The new length. Positive to the right, negative to the left
]]--
function arExtend(tArr, nCnt)
  if(not tArr) then return logStatus(tArr, "arZerofilLeft: Array missing") end
  local nCnt = tonumber(nCnt) or 0
  if(nCnt == 0) then return logStatus(tArr, "arZerofilLeft: Array dimension skipped") end
  local nArl = #tArr
  if(nCnt == nArl) then return logStatus(tArr, "arZerofilLeft: Array size unchanged") end
  local vEmp = (type(tArr[1]) == "string") and "" or 0
  if(nCnt > 0) then
    local nEnd = (nArl > nCnt) and nArl or nCnt
    for iK = 1, nEnd, 1 do
      tArr[iK] = (iK <= nCnt) and (tArr[iK] or vEmp) or nil
    end
  else
    local nDif = nArl + nCnt
    if(nDif > 0) then -- Cut in the front
      for iK = 1, nArl, 1 do
        tArr[iK] = ((iK+nDif) <= nArl) and tArr[iK+nDif] or nil
      end
    else -- Extended in the front
      local aCnt = math.abs(nCnt)
      for iK = aCnt, 1, -1 do
        tArr[iK] = ((iK+nDif) >= 1) and tArr[iK+nDif] or vEmp
      end
    end
  end
end

function arMalloc2D(w,h)
  local Arr = {}
  for y=1,h do
    Arr[y] = {}
    for x=1,w do
      Arr[y][x]=0
    end
  end
  return Arr
end

function arMalloc1D(sZ)
  local s = sZ or 0
  local Arr = {}
  for x=1,s do
    Arr[x]=0
  end
  return Arr
end

function arShift2D(Arr,sX,sY,nX,nY)
  if( not( sX > 0 and sY > 0) ) then return end
  local x = math.floor(nX or 0)
  local y = math.floor(nY or 0)
  local Tmp = 0
  if(x ~= 0) then
    local sx,ex,dx = GetSEDValues(x,sX,1)
    local M
    for i = 1,sY do
      for j = sx,ex,dx do
        M = j-x
        if(M >= 1 and M <= sX) then
          Arr[i][j] = Arr[i][M]
        else
          Arr[i][j] = 0
        end
      end
    end
  end
  if(y ~= 0) then
    local sy,ey,dy = GetSEDValues(y,sY,1)
    local M
    for i = sy,ey,dy do
      for j = 1,sX do
        M = i-y
        if(M >= 1 and M <= sY) then
          Arr[i][j] = Arr[M][j]
        else
          Arr[i][j] = 0
        end
      end
    end
  end
end

function arRoll2D(Arr,sX,sY,nX,nY)
  if( not( sX > 0 and sY > 0) ) then return end
  local x = math.floor(nX or 0)
  local y = math.floor(nY or 0)
  if(y ~= 0) then
    local MaxY = (y > 0) and sY or 1
    local MinY = (y > 0) and 1 or sY
    local siY  = getSignAnd(y)
          y    = y * siY
    local arTmp = {}
    while(y > 0) do
      for i = 1,sX do
        arTmp[i] = Arr[MaxY][i]
      end
      arShift2D(Arr,sX,sY,0,siY)
      for i = 1,sX do
        Arr[MinY][i] = arTmp[i]
      end
      y = y - 1
    end
  end
  if(x ~= 0) then
    local MaxX = (x > 0) and sX or 1
    local MinX = (x > 0) and 1 or sX
    local siX  = getSignAnd(x)
          x    = x * siX
    local arTmp = {}
    while(x > 0) do
      for i = 1,sY do
        arTmp[i] = Arr[i][MaxX]
      end
      arShift2D(Arr,sX,sY,siX)
      for i = 1,sY do
        Arr[i][MinX] = arTmp[i]
      end
      x = x - 1
    end
  end
end

function arMirror2D(Arr,sX,sY,fX,fY)
  local Tmp, s
  if(fY) then
    Tmp = 0
    s   = 1
    local e = sY
    while(s < e) do
      for k = 1,sX do
        Tmp = Arr[s][k]
        Arr[s][k] = Arr[e][k]
        Arr[e][k] = Tmp
      end
      s = s + 1
      e = e - 1
    end
  end
  if(fX) then
    Tmp = 0
    s   = 1
    local e = sX
    while(s < e) do
      for k = 1,sY do
        Tmp = Arr[k][s]
        Arr[k][s] = Arr[k][e]
        Arr[k][e] = Tmp
      end
      s = s + 1
      e = e - 1
    end
  end
end

function arRotateR(Arr,sX,sY)
  local Tmp = arMalloc2D(sY,sX)
  local ii = 1
  local jj = 1
  for j = 1, sX, 1 do
    for i = sY, 1, -1  do
      if(jj > sY) then
        ii = ii + 1
        jj = 1
      end
      Tmp[ii][jj] = Arr[i][j]
      Arr[i][j]   = nil
      jj = jj + 1
    end
  end
  for i = 1, sX do
    Arr[i] = {}
    for j = 1, sY  do
      Arr[i][j] = Tmp[i][j]
    end
  end
end

function arRotateL(Arr,sX,sY)
  local Tmp = arMalloc2D(sY,sX)
  local ii = 1
  local jj = 1
  for j = sX, 1, -1 do
    for i = 1, sY, 1  do
      if(jj > sY) then
        ii = ii + 1
        jj = 1
      end
      Tmp[ii][jj] = Arr[i][j]
      Arr[i][j]   = nil
      jj = jj + 1
    end
  end
  for i = 1, sX do
    Arr[i] = {}
    for j = 1, sY  do
      Arr[i][j] = Tmp[i][j]
    end
  end
end

--------------- SORTING ---------------

local function sortQuick(Data,Lo,Hi)
  if(not (Lo and Hi and (Lo > 0) and (Lo < Hi))) then
    return logStatus("Qsort: Data dimensions mismatch", nil) end
  local Mid = mathRandom(Hi-(Lo-1))+Lo-1
  Data[Lo], Data[Mid] = Data[Mid], Data[Lo]
  local Vmid = Data[Lo].Val
        Mid  = Lo
  local Cnt  = Lo + 1
  while(Cnt <= Hi)do
    if(Data[Cnt].Val < Vmid) then
      Mid = Mid + 1
      Data[Mid], Data[Cnt] = Data[Cnt], Data[Mid]
    end
    Cnt = Cnt + 1
  end
  Data[Lo], Data[Mid] = Data[Mid], Data[Lo]
  Qsort(Data,Lo,Mid-1)
  Qsort(Data,Mid+1,Hi)
end

local function sortSelection(Data,Lo,Hi)
  if(not (Lo and Hi and (Lo > 0) and (Lo < Hi))) then
    return logStatus("Qsort: Data dimensions mismatch", nil) end
  local Ind = 1
  local Sel
  while(Data[Ind]) do
    Sel = Ind + 1
    while(Data[Sel]) do
      if(Data[Sel].Val < Data[Ind].Val) then
        Data[Ind], Data[Sel] = Data[Sel], Data[Ind]
      end
      Sel = Sel + 1
    end
    Ind = Ind + 1
  end
end

local function sortBubble(Data,Lo,Hi)
  if(not (Lo and Hi and (Lo > 0) and (Lo < Hi))) then
    return logStatus("Qsort: Data dimensions mismatch", nil) end
  local Ind, End = 1, false
  while(not End) do
    End = true
    for Ind = Lo, (Hi-1), 1 do
      if(Data[Ind].Val > Data[Ind+1].Val) then
        End = false
        Data[Ind], Data[Ind+1] = Data[Ind+1], Data[Ind]
      end
    end
  end
end

function padString(sStr,sPad,ivCnt)
  local iLen = stringLen(sStr) -- Not used just for error handling
  if(iLen == 0) then return StatusLog(sStr,"PadString: Pad too short") end
  local iCnt = tonumber(ivCnt)
  if(not IsExistent(iCnt)) then return sStr end
  local iDif = (mathAbs(iCnt) - iLen)
  if(iDif <= 0) then return sStr end
  local sCh = stringSub(sPad,1,1)
  local sPad = sCh
  iDif = iDif - 1
  while(iDif > 0) do
    sPad = sPad..sCh
    iDif = iDif - 1
  end
  if(iCnt > 0) then return (sStr..sPad) end
  return (sPad..sStr)
end

function adaptLine(xyS,xyE,nI,nK,sMeth,nDelay,nDraw)

  local function Enclose(xyPnt)
    if(xyPnt.x < sW) then return -1 end
    if(xyPnt.x > eW) then return -1 end
    if(xyPnt.y < sH) then return -1 end
    if(xyPnt.y > eH) then return -1 end
    return 1
  end

  local I = 0
  if(not (xyS and xyE)) then return false, I end
  if(not (xyS.x and xyS.y and xyE.x and xyE.y)) then return false, I end
  crcl(xyS.x,xyS.y,10,colr(255,0,0))
  crcl(xyE.x,xyE.y,10,colr(0,0,255))
  local nK = nK or 0.25
  local nI = nI or 50
        nI = math.floor(nI)
  if(sW >= eW) then return false, I end
  if(sH >= eH) then return false, I end
  if(nI < 1) then return false, I end
  if(not (nK > I and nK < 1)) then return false, I end
  local SigS = Enclose(xyS)
  local SigE = Enclose(xyE)
  if(SigS == 1 and SigE == 1) then
    return true, I
  elseif(SigS == -1 and SigE == -1) then
    return false, I
  elseif(SigS == -1 and SigE == 1) then
    xyS.x, xyE.x = xyE.x, xyS.x
    xyS.y, xyE.y = xyE.y, xyS.y
  end
  local nDelay = tonumber(nDelay) or 0
  if(not sMeth or sMeth == "" or sMeth == "BIN") then
    local DisX = xyE.x - xyS.x
    local DirX = DisX
          DisX = DisX * DisX
    local DisY = xyE.y - xyS.y
    local DirY = DisY
          DisY = DisY * DisY
    local Dis = math.sqrt(DisX + DisY)
    if(Dis == 0) then
      return false, I
    end
          DirX = DirX / Dis
          DirY = DirY / Dis
    local Pos = {x = xyS.x, y = xyS.y}
    local Mid = Dis / 2
    local Pre = 100 -- Obviously big enough
    while(I < nI) do
      Sig = Enclose(Pos)
      if(Sig == 1) then
        xyE.x = Pos.x
        xyE.y = Pos.y
      end
      Pos.x = Pos.x + DirX * Sig * Mid
      Pos.y = Pos.y + DirY * Sig * Mid
      --[[
        Estimate the distance and break
        earlier with 0.5 because of the
        math.floor call afterwards.
      ]]
      Pre = math.abs(
            math.abs(Pos.x) +
            math.abs(Pos.y) -
            math.abs(xyE.x) -
            math.abs(xyE.y))
      if(Pre < 0.5) then break end
      Mid = nK * Mid
      I = I + 1
    end
  elseif(sMeth == "ITR") then
    local V = {x = xyE.x-xyS.x, y = xyE.y-xyS.y}
    local N = math.sqrt(V.x*V.x + V.y*V.y)
    local Z = (N * (1-nK))
    if(Z == 0) then return false, I end
    local D = {x = V.x/Z , y = V.y/Z}
          V.x = xyS.x
          V.y = xyS.y
    local Sig = Enclose(V)
    while(Sig == 1) do
      xyE.x, xyE.y = V.x, V.y
      V.x = V.x + D.x
      V.y = V.y + D.y
      Sig = Enclose(V)
      I = I + 1
    end
  end
  xyS.x, xyS.y = math.floor(xyS.x), math.floor(xyS.y)
  xyE.x, xyE.y = math.floor(xyE.x), math.floor(xyE.y)
  return true, I
end

------------------- TESTING ----------------------

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

------------------- STRINGS --------------------------

function strExplode(sStr,sDel)
  local List, Ch, Idx, ID, dL = {""}, "", 1, 1, (sDel:len()-1)
  while(Ch) do
    Ch = sStr:sub(Idx,Idx+dL)
    if    (Ch ==  "" ) then return List
    elseif(Ch == sDel) then ID = ID + 1; List[ID], Idx = "", (Idx + dL)
    else List[ID] = List[ID]..Ch:sub(1,1) end; Idx = Idx + 1
  end; return List
end

function strImplode(tList,sDel)
  local ID, Str = 1, ""
  local Del = tostring(sDel or "")
  while(tList and tList[ID]) do
    Str = Str..tList[ID]; ID = ID + 1
    if(tList[ID] and sDel ~= "") then Str = Str..Del end
  end; return Str
end

function stringTrim(sStr)
  return sStr:gsub("^%s+", ""):gsub("%s+$", "")
end

--------------- CRYPTING -----------------------------------

function encNumber(arNum) -- Base 10 to base 11
  local src = table.concat(arNum, "."):reverse()
  local id, ch, re = 0, src:sub(1,1), 0
  while(ch ~= "") do
    re = re + (tonumber(ch) or 10) * 11^id
    id = id + 1; ch = src:sub(id+1,id+1)
  end; return re
end

function decNumber(nNum)
  d, m, s = math.floor(nNum/11), math.fmod(nNum,11), ""
  while(d ~= 0) do
    s = ((m == 10) and "." or tostring(m))..s
    d, m = math.floor(d / 11), math.fmod(d,11)
  end; return stringExplode(((m == 10) and "." or tostring(m))..s,".")
end


