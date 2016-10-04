local pairs     = pairs
local tonumber  = tonumber
local tostring  = tostring
local type      = type
local io        = io
local string    = string

io.stdout:setvbuf("no")

function LogLine(anyData)
  io.write(tostring(anyData).."\n")
end

function LogMulty(...)
  local line = "{"
  local args, i = {...}, 1
  while(args[i]) do
    line = line..tostring(args[i])
    if(args[i+1]) then line = line.."_" end
    i = i + 1
  end
  io.write(line.."}\n")
end

function Print(tT,sS)
  if(not tT) then
    LogLine("Print: {nil, name="..tostring(sS or "\"Data\"").."}")
    return
  end
  local S = type(sS)
  local T = type(tT)
  local Key = ""
  if    (S == "string") then S = sS
  elseif(S == "number") then S = tostring(sS)
  else                       S = "Data" end
  if(T ~= "table") then LogLine("{"..T.."}["..tostring(sS or "N/A").."] = "..tostring(tT)); return end
  T = tT
  if(next(T) == nil) then LogLine(S.." = {}"); return end
  LogLine(S)
  for k,v in pairs(T) do
    if(type(k) == "string") then
      Key = S.."[\""..k.."\"]"
    else
      Key = S.."["..tostring(k).."]"
    end
    if(type(v) ~= "table") then
      if(type(v) == "string") then
        LogLine(Key.." = \""..v.."\"")
      else
        LogLine(Key.." = "..tostring(v))
      end
    else
      Print(v,Key)
    end
  end
end

function BorderValue(nVal,nMin,nMax)
  if(type(nVal) ~= "number") then return nil end
  local Min = nMin or 0
  local Max = nMax or 0
  if(nMax > Max) then return Min end
  if(nMax < Min) then return Max end
  return nMax
end

function RollValue(nVal,nMin,nMax)
  if(type(nVal) ~= "number") then return nil end
  local Min = nMin or 0
  local Max = nMax or 0
  local Dif = Max-Min
  if(Dif ~= 0) then
    return nVal % Dif
  end
  return nMax
end

function ClampValue(nVal,nMin,nMax)
  if(type(nVal) ~= "number") then return nil end
  local Min = nMin or 0
  local Max = nMax or 0
  if(nVal >= Max) then return Max end
  if(nVal <= Min) then return Min end
  return nVal
end

function RoundValue(nvExact, nFrac)
  local nExact = tonumber(nvExact)
  if(not nExact) then
    return LogLine("RoundValue: Cannot round NAN {"..type(nvExact).."}<"..tostring(nvExact)..">") end
  local nFrac = tonumber(nFrac) or 0
  if(nFrac == 0) then
    return LogLine("RoundValue: Fraction must be <> 0") end
  local q, f = math.modf(nExact/nFrac)
  return nFrac * (q + (f > 0.5 and 1 or 0))
end

function StrTrimSpaces(sStr)
  if(not sStr)   then return nil end
  if(sStr == "") then return ""  end
  local S = 1
  local E = 1
  local Len = string.len(sStr)
  local Che
  while(S <= Len) do
    Che = string.sub(sStr,S,S)
    if(Che ~= " ") then break end
    S = S + 1
  end
  E = Len
  while(E >= 1) do
    Che = string.sub(sStr,E,E)
    if(Che ~= " ") then break end
    E = E - 1
  end 
  return string.sub(sStr,S,E)
end

function Delay(Add)
-- NOTE: SYSTEM-DEPENDENT, adjust as necessary
  if(Add > 0) then
    local i=os.clock()+Add 
    while(os.clock()<i) do end
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

function SignValAbs(Val)
  return ( Val / math.abs(Val) )
end

function SignValNil(na)
  local a = tonumber(na)
  if(a) then
    if(a > 0) then return  1 end
    if(a < 0) then return -1 end
    return a
  end  
  return nil
end

function GetSEDValues(Val,Min,Max)
  local s = (Val > 0) and Min or Max
  local e = (Val > 0) and Max or Min
  local d = SignVal(e - s)
  return s, e, d
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
    local siY  = SignVal(y)
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
    local siX  = SignVal(x)
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

local function sortQuick(Data,Lo,Hi)
  if(not (Lo and Hi and (Lo > 0) and (Lo < Hi))) then
    return StatusLog(nil,"Qsort: Data dimensions mismatch") end
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
    return StatusLog(nil,"Ssort: Data dimensions mismatch") end
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
    return StatusLog(nil,"Bsort: Data dimensions mismatch") end
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

function testPerformance(stCard,stEstim,sFile)
  if(sFile) then
    LogLine("Output set to: "..sFile)
    io.output(sFile)
  end
  local tstCas = #stCard
  local tstEst = #stEstim
  LogLine("Started "..tostring(tstCas).." tast cases for "..tostring(tstEst).." functions")
  local TestID, Cases = 1, {}
  while(stCard[TestID]) do -- All tests
    local tstVal = stCard[TestID]
    local fooVal = tstVal[1]
    local fooRes = tstVal[2]
    local tstNam = tostring(tstVal[3] or "")
    local fooCnt = tonumber(tstVal[4]) or 0
    local fooCyc = tonumber(tstVal[5]) or 0
    if(fooCnt < 1) then LogLine("No test-card count  stCard.Cnt for test ID # "..tostring(TestID)); return end
    if(fooCyc < 1) then LogLine("No test-card cycles stCard.Cyc for test ID # "..tostring(TestID)); return end
    if(Cases[tstNam]) then LogLine("Test case name <"..tstNam.."> already chosen under ID # "..tostring(Cases[tstNam])); return; end
    LogLine("Testing case["..tostring(TestID).."]: <"..tostring(tstVal[3])..">")
    LogLine("   Inp: <"..tostring(tstVal[1])..">")
    LogLine("   Out: <"..tostring(tstVal[2])..">")
    LogLine("   Set: { "..tostring(fooCnt)..", "..tostring(fooCyc).." }")
    local Itr = 1 -- Current iteration
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
          if(Rez == fooRes) then Roll["PASS"] = Roll["PASS"] + 1
          else                   Roll["FAIL"] = Roll["FAIL"] + 1 end
        end
        Foo.Times[tstNam] = Foo.Times[tstNam] + (os.clock() - Time)
      end
    end
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
      local Nam = "Passed ["..Foo.Name.."]: "
      local Dat = string.format("%3.3f Time: %3.3f (%5.3f[s]) %15.3f[c/s] Failed: %d",Pas,Tip,Tim,(fooCnt*fooCyc/Tim),Fal)
      LogLine(Nam..Dat)  
    end; Cases[tstNam] = TestID;
    LogLine("")
    TestID = TestID + 1
  end
  LogLine("Test finished all "..tostring(tstCas).." cases successfully")
end

function StrExplode(sStr,sDel)
  local sStr = string.gsub(sStr,sDel,"#")
  local List, Char, Idx, ID = {""}, "", 1, 1
  while(Char) do
    Char = string.sub(sStr,Idx,Idx)
    if    (Char ==  "") then return List
    elseif(Char == "#") then ID = ID + 1; List[ID] = ""
    else List[ID] = List[ID]..Char end
    Idx = Idx + 1
  end
  return List
end

function StrImplode(tList,sDel)
  local ID, Str = 1, ""
  local sDel = tostring(sDel or "")
  while(tList and tList[ID]) do
    Str = Str..tList[ID]; ID = ID + 1
    if(tList[ID] and sDel ~= "") then Str = Str..sDel end
  end
  return Str
end
