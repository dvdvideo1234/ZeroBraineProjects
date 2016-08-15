--- Vector Component indexes ---
local cvX -- Vector X component
local cvY -- Vector Y component
local cvZ -- Vector Z component

--- Angle Component indexes ---
local caP -- Angle Pitch component
local caY -- Angle Yaw   component
local caR -- Angle Roll  component

--- Component Status indexes ---
local csX -- Sign of the first component
local csY -- Sign of the second component
local csZ -- Sign of the third component
local csD -- Flag for disabling the point

local next                 = next
local type                 = type
local Angle                = Angle
local Color                = Color
local pairs                = pairs
local print                = print
local tobool               = tobool
local Vector               = Vector
local include              = include
local IsValid              = IsValid
local require              = require
local Time                 = SysTime
local tonumber             = tonumber
local tostring             = tostring
local GetConVar            = GetConVar
local LocalPlayer          = LocalPlayer
local CreateConVar         = CreateConVar
local getmetatable         = getmetatable
local setmetatable         = setmetatable
local collectgarbage       = collectgarbage
local io                   = io
local osClock              = os and os.clock
local osDate               = os and os.date
local sqlQuery             = sql and sql.Query
local sqlLastError         = sql and sql.LastError
local sqlTableExists       = sql and sql.TableExists
local utilTraceLine        = util and util.TraceLine
local utilIsInWorld        = util and util.IsInWorld
local utilIsValidModel     = util and util.IsValidModel
local utilGetPlayerTrace   = util and util.GetPlayerTrace
local entsCreate           = ents and ents.Create
local fileOpen             = file and file.Open
local fileExists           = file and file.Exists
local fileAppend           = file and file.Append
local fileDelete           = file and file.Delete
local fileCreateDir        = file and file.CreateDir
local mathAbs              = math and math.abs
local mathCeil             = math and math.ceil
local mathModf             = math and math.modf
local mathSqrt             = math and math.sqrt
local mathFloor            = math and math.floor
local mathClamp            = math and math.Clamp
local mathRandom           = math and math.random
local timerStop            = timer and timer.Stop
local timerStart           = timer and timer.Start
local timerExists          = timer and timer.Exists
local timerCreate          = timer and timer.Create
local timerDestroy         = timer and timer.Destroy
local tableEmpty           = table and table.Empty
local debugGetinfo         = debug and debug.getinfo
local stringLen            = string and string.len
local stringSub            = string and string.sub
local stringFind           = string and string.find
local stringGsub           = string and string.gsub
local stringUpper          = string and string.upper
local stringLower          = string and string.lower
local stringFormat         = string and string.format
local surfaceSetFont       = surface and surface.SetFont
local surfaceDrawLine      = surface and surface.DrawLine
local surfaceDrawText      = surface and surface.DrawText
local surfaceDrawCircle    = surface and surface.DrawCircle
local surfaceSetTexture    = surface and surface.SetTexture
local surfaceSetTextPos    = surface and surface.SetTextPos
local surfaceGetTextSize   = surface and surface.GetTextSize
local surfaceGetTextureID  = surface and surface.GetTextureID
local surfaceSetDrawColor  = surface and surface.SetDrawColor
local surfaceSetTextColor  = surface and surface.SetTextColor
local constructSetPhysProp = construct and construct.SetPhysProp
local constraintWeld       = constraint and constraint.Weld
local constraintNoCollide  = constraint and constraint.NoCollide
local surfaceDrawTexturedRect = surface and surface.DrawTexturedRect
local duplicatorStoreEntityModifier = duplicator and duplicator.StoreEntityModifier
local libCache  = {} -- Used to cache stuff in a Pool
local libAction = {} -- Used to attach external function to the lib
local libOpVars = {} -- Used to Store operational Variable Values

module("asmlib")

function stringToFileName(sName)
  if(not sName) then return "" end
  local Name = tostring(sName)
  local N, Ch = -1, Name:sub(-1,-1)
  while(Ch ~= "/" and Ch ~= "\\") do N = N - 1; Ch = Name:sub(N,N) end
  return Name:sub(N+1,-1)
end

function GetIndexes(sType)
  if(sType == "V") then
    return cvX, cvY, cvZ
  elseif(sType == "A") then
    return caP, caY, caR
  elseif(sType == "S") then
    return csX, csY, csZ, csD
  end
  return nil
end

function SetIndexes(sType,I1,I2,I3,I4)
  if(sType == "V") then
    cvX = I1
    cvY = I2
    cvZ = I3
  elseif(sType == "A") then
    caP = I1
    caY = I2
    caR = I3
  elseif(sType == "S") then
    csX = I1
    csY = I2
    csZ = I3
    csD = I4
  end
  return nil
end

function GetCache(anyKey)
  if(anyKey) then
    return libCache[sKey]
  end
  return libCache
end

function mathClamp( _in, low, high )
	if (_in < low ) then return low end
	if (_in > high ) then return high end
	return _in
end

function AddVectorXYZ(vBase, nX, nY, nZ)
  vBase[cvX] = vBase[cvX] + (nX or 0)
  vBase[cvY] = vBase[cvY] + (nY or 0)
  vBase[cvZ] = vBase[cvZ] + (nZ or 0)
end

function LogInstance(anyValue)
 -- print(tostring(anyValue))
end

function GetOpVar(sName)
  return libOpVars[sName]
end

function SetOpVar(sName, anyValue)
  libOpVars[sName] = anyValue
end

function PrintArrLine(aTable,sName)
  local Line = (sName or "Data").."{"
  local Cnt  = 1
  while(aTable[Cnt]) do
    Line = Line..tostring(aTable[Cnt])
    if(aTable[Cnt + 1]) then
      Line = Line..", "
    end
    Cnt = Cnt + 1
  end
  print(Line.."}")
end

function PrintPush(aTable,sName)
  local Line = (sName or "Data").."{"
  local Cnt  = 1
  while(aTable[Cnt]) do
    Line = Line..tostring(aTable[Cnt].Value)
    if(aTable[Cnt + 1]) then
      Line = Line..", "
    end
    Cnt = Cnt + 1
  end
  print(Line.."}")
end

function Print(tT,sS)
  if(not tT) then
    print(nil,"Print: No Data: Print( table, string = \"Data\" )!")
    return
  end
  local S = type(sS)
  local T = type(tT)
  local Key  = ""
  if(S == "string") then
    S = sS
  elseif(S == "number") then
    S = tostring(sS)
  else
    S = "Data"
  end
  if(T ~= "table") then
    print("{"..T.."}["..tostring(sS or "N/A").."] = "..tostring(tT))
    return
  end
  T = tT
  if(next(T) == nil) then
    print(S.." = {}")
    return
  end
  print(S)
  for k,v in pairs(T) do
    if(type(k) == "string") then
      Key = S.."[\""..k.."\"]"
    else
      Key = S.."["..tostring(k).."]"
    end
    if(type(v) ~= "table") then
      if(type(v) == "string") then
        print(Key.." = \""..v.."\"")
      else
        print(Key.." = "..tostring(v))
      end
    else
      Print(v,Key)
    end
  end
end

function PrintInstance(anyStuff)
  local sModeDB = tostring(GetOpVar("MODE_DATABASE"))
  if(SERVER) then
    print("SERVER > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..tostring(anyStuff))
  elseif(CLIENT) then
    print("CLIENT > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..tostring(anyStuff))
  else
    print("NOINST > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..tostring(anyStuff))
  end
end

function StatusPrint(anyStatus,sError)
  PrintInstance(sError)
  return anyStatus
end

function StatusLog(anyStatus,sError)
  local inf = debugGetinfo(2) or {}
  local src = ""

  print("LOG "..src.." >> "..tostring(GetOpVar("MODE_DATABASE")).." # "..tostring(sError))
  return anyStatus
end

function IsString(anyValue)
  if(getmetatable(anyValue) == getmetatable("TYPEMT_STRING")) then return true end
  return false
end

function IsEmptyString(anyValue)
  if(not IsString(anyValue)) then return false end
  return (anyValue == "")
end

local function SQLSetBuildErr(sArg)
  print(tostring(sArg))
  return nil
end

function GsubModelToName(tGsub)
  if(not IsExistent(tGsub)) then
    return GetOpVar("TABLE_GSUB_MODEL") or ""
  end
  SetOpVar("TABLE_GSUB_MODEL",tGsub)
end

function GcutModelToName(tGcut)
  if(not IsExistent(tGcut)) then
    return GetOpVar("TABLE_GCUT_MODEL") or ""
  end
  SetOpVar("TABLE_GCUT_MODEL",tGcut)
end

function GappModelToName(tGapp)
  if(not IsExistent(tGapp)) then
    return GetOpVar("TABLE_GAPP_MODEL") or ""
  end
  SetOpVar("TABLE_GAPP_MODEL",tGapp)
end

function SetAction(sKey,fAct,tDat)
  if(not (sKey)) then return false end
  if(not (fAct and type(fAct) == "function")) then return false end
  if(not libAction[sKey]) then
    libAction[sKey] = {}
  end
  libAction[sKey].Act = fAct
  libAction[sKey].Dat = tDat
  return true
end

function GetAction(sKey)
  if(not (sKey)) then return nil end
  if(not (libAction and libAction[sKey])) then return nil end
  return libAction[sKey]
end

function DoAction(sKey,A1,A2,A3)
  if(not (sKey)) then return false end
  if(not (libAction and libAction[sKey])) then return false end
  return libAction[sKey].Act(A1,A2,A3,libAction[sKey].Dat)
end

function IsExistent(anyValue)
  if(anyValue ~= nil) then return true end
  return false
end

local function SQLBuildErr(anyError)
  if(not IsExistent(anyError)) then
    return GetOpVar("SQL_BUILD_ERR") or ""
  end
  SetOpVar("SQL_BUILD_ERR", tostring(anyError))
  return false
end

function SettingsModelToName(sMode, gCut, gSub, gApp)
  if(not IsString(sMode)) then return StatusLog(false,"SettingsModelToName: Wrong mode type "..type(sMode)) end
  if(sMode == "SET") then
    if(gCut and gCut[1]) then SetOpVar("TABLE_GCUT_MODEL",gCut) else SetOpVar("TABLE_GCUT_MODEL",{}) end
    if(gSub and gSub[1]) then SetOpVar("TABLE_GSUB_MODEL",gSub) else SetOpVar("TABLE_GSUB_MODEL",{}) end
    if(gApp and gApp[1]) then SetOpVar("TABLE_GAPP_MODEL",gApp) else SetOpVar("TABLE_GAPP_MODEL",{}) end
  elseif(sMode == "GET") then
    return GetOpVar("TABLE_GCUT_MODEL"), GetOpVar("TABLE_GSUB_MODEL"), GetOpVar("TABLE_GAPP_MODEL")
  elseif(sMode == "CLR") then
    SetOpVar("TABLE_GCUT_MODEL",{})
    SetOpVar("TABLE_GSUB_MODEL",{})
    SetOpVar("TABLE_GAPP_MODEL",{})
  else
    return StatusLog(false,"SettingsModelToName: Wrong mode name "..sMode)
  end
end

function DefaultType(anyType)
  if(not IsExistent(anyType)) then
    return GetOpVar("DEFAULT_TYPE") or ""
  end
  SetOpVar("DEFAULT_TYPE",tostring(anyType))
  SettingsModelToName("CLR")
end

function DefaultTable(anyTable)
  if(not IsExistent(anyTable)) then
    return GetOpVar("DEFAULT_TABLE") or ""
  end
  SetOpVar("DEFAULT_TABLE",anyTable)
  SettingsModelToName("CLR")
end

function ModelToName(sModel,bNoSettings)
  if(not IsString(sModel)) then
    return StatusLog("","ModelToName: Argument {"..type(sModel).."}<"..tostring(sModel)..">") end
  if(IsEmptyString(sModel)) then return StatusLog("","ModelToName: Empty string") end
  local fCh, bCh, Cnt = "", "", 1
  local sSymDiv, sSymDir = GetOpVar("OPSYM_DIVIDER"), GetOpVar("OPSYM_DIRECTORY")
  local sModel = (stringSub(sModel,1, 1) ~= sSymDir) and (sSymDir..sModel) or sModel
        sModel =  stringGsub(stringToFileName(sModel),GetOpVar("FILE_MODEL"),"")
  local gModel =  stringSub(sModel,1,-1) -- Create a copy so we can select cut-off parts later on
  if(not bNoSettings) then
    local tCut, tSub, tApp = SettingsModelToName("GET")
    if(tCut and tCut[1]) then
      while(tCut[Cnt] and tCut[Cnt+1]) do
        fCh = tonumber(tCut[Cnt])
        bCh = tonumber(tCut[Cnt+1])
        if(not (IsExistent(fCh) and IsExistent(bCh))) then
          return StatusLog("","ModelToName: Cannot cut the model in {"
                   ..tostring(tCut[Cnt])..","..tostring(tCut[Cnt+1]).."} for "..sModel)
        end
        LogInstance("ModelToName[CUT]: {"..tostring(tCut[Cnt])..", "..tostring(tCut[Cnt+1]).."} << "..gModel)
        gModel = stringGsub(gModel,stringSub(sModel,fCh,bCh),"")
        LogInstance("ModelToName[CUT]: {"..tostring(tCut[Cnt])..", "..tostring(tCut[Cnt+1]).."} >> "..gModel)
        Cnt = Cnt + 2
      end
      Cnt = 1
    end
    -- Replace the unneeded parts by finding an in-string gModel
    if(tSub and tSub[1]) then
      while(tSub[Cnt]) do
        fCh = tostring(tSub[Cnt]   or "")
        bCh = tostring(tSub[Cnt+1] or "")
        LogInstance("ModelToName[SUB]: {"..tostring(tSub[Cnt])..", "..tostring(tSub[Cnt+1]).."} << "..gModel)
        gModel = stringGsub(gModel,fCh,bCh)
        LogInstance("ModelToName[SUB]: {"..tostring(tSub[Cnt])..", "..tostring(tSub[Cnt+1]).."} >> "..gModel)
        Cnt = Cnt + 2
      end
      Cnt = 1
    end
    -- Append something if needed
    if(tApp and tApp[1]) then
      LogInstance("ModelToName[APP]: {"..tostring(tApp[Cnt])..", "..tostring(tApp[Cnt+1]).."} << "..gModel)
      gModel = tostring(tApp[1] or "")..gModel..tostring(tApp[2] or "")
      LogInstance("ModelToName[APP]: {"..tostring(tSub[Cnt])..", "..tostring(tSub[Cnt+1]).."} >> "..gModel)
    end
  end
  -- Trigger the capital-space using the divider
  if(stringSub(gModel,1,1) ~= sSymDiv) then gModel = sSymDiv..gModel end
  -- Here in gModel we have: _aaaaa_bbbb_ccccc
  fCh, bCh, sModel = stringFind(gModel,sSymDiv,1), 1, ""
  while(fCh) do
    if(fCh > bCh) then
      sModel = sModel..stringSub(gModel,bCh+2,fCh-1)
    end
    if(not IsEmptyString(sModel)) then sModel = sModel.." " end
    sModel = sModel..stringUpper(stringSub(gModel,fCh+1,fCh+1))
    bCh = fCh
    fCh = stringFind(gModel,sSymDiv,fCh+1)
  end
  return sModel..stringSub(gModel,bCh+2,-1)
end

function StringDisable(sBase, anyDisable, anyDefault)
  if(IsString(sBase)) then
    if(stringLen(sBase) > 0 and
       stringSub(sBase,1,1) ~= GetOpVar("OPSYM_DISABLE")
    ) then
      return sBase
    elseif(stringSub(sBase,1,1) == GetOpVar("OPSYM_DISABLE")) then
      return anyDisable
    end
  end
  return anyDefault
end

function StringDefault(sBase, sDefault)
  if(IsString(sBase)) then
    if(stringLen(sBase) > 0) then return sBase end
  end
  if(IsString(sDefault)) then return sDefault end
  return ""
end

local function IsEqualPOA(stOffsetA,stOffsetB)
  if(not IsExistent(stOffsetA)) then return StatusLog(nil,"EqualPOA: Missing OffsetA") end
  if(not IsExistent(stOffsetB)) then return StatusLog(nil,"EqualPOA: Missing OffsetB") end
  for Ind, Comp in pairs(stOffsetA) do
    if(Ind ~= csD and stOffsetB[Ind] ~= Comp) then return false end
  end
  return true
end

local function StringPOA(arOffs,iID,sOffs)
  if(not IsExistent(arOffs)) then return StatusLog(nil,"StringPOA: Missing Offsets") end
  local iID = tonumber(iID)
  if(not IsExistent(iID))    then return StatusLog(nil,"StringPOA: Missing PointID") end
  local Offset = arOffs[iID]
  if(not IsExistent(Offset)) then return StatusLog(nil,"StringPOA: No PointID") end
  local sEmpty
  local sResult = ""
  local sOffset = tostring(sOffs)
  local symRevs = GetOpVar("OPSYM_REVSIGN")
  local symDisa = GetOpVar("OPSYM_DISABLE")
  local sOffs
  local sModeDB = tostring(GetOpVar("MODE_DATABASE"))
  if    (sModeDB == "SQL") then sEmpty = "NULL"
  elseif(sModeDB == "LUA") then sEmpty = ""
  else return StatusLog("","StringPOA: Missed database mode "..sModeDB)
  end
  if(sOffset == "P") then
    if(not Offset.P[csD]) then
      if(IsEqualPOA(Offset.P,Offset.O)) then
        sResult = sEmpty
      else
        sResult = ((Offset.P[csX] == -1) and symRevs or "")..tostring(Offset.P[cvX])..","
                ..((Offset.P[csY] == -1) and symRevs or "")..tostring(Offset.P[cvY])..","
                ..((Offset.P[csZ] == -1) and symRevs or "")..tostring(Offset.P[cvZ])
      end
    else
      sResult = symDisa
    end
  elseif(sOffset == "O") then
    sResult = ((Offset.O[csX] == -1) and symRevs or "")..tostring(Offset.O[cvX])..","
            ..((Offset.O[csY] == -1) and symRevs or "")..tostring(Offset.O[cvY])..","
            ..((Offset.O[csZ] == -1) and symRevs or "")..tostring(Offset.O[cvZ])
  elseif(sOffset == "A") then
    if(Offset.A[caP] == 0 and Offset.A[caY] == 0 and Offset.A[caR] == 0) then
      sResult = sEmpty
    else
      sResult = ((Offset.A[csX] == -1) and symRevs or "")..tostring(Offset.A[caP])..","
              ..((Offset.A[csY] == -1) and symRevs or "")..tostring(Offset.A[caY])..","
              ..((Offset.A[csZ] == -1) and symRevs or "")..tostring(Offset.A[caR])
    end
  else
    return StatusLog("","StringPOA: Missed offset mode "..sOffset)
  end
  return sResult
end

function TransferPOA(stOffset,sMode)
  if(not IsExistent(stOffset)) then return StatusLog(nil,"TransferPOA(): Destination needed") end
  if(not IsString(sMode)) then return StatusLog(nil,"TransferPOA(): Mode must be string") end
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
  if(sMode == "POS") then
    stOffset[cvX] = arPOA[1]
    stOffset[cvY] = arPOA[2]
    stOffset[cvZ] = arPOA[3]
  elseif(sMode == "ANG") then
    stOffset[caP] = arPOA[1]
    stOffset[caY] = arPOA[2]
    stOffset[caR] = arPOA[3]
  end
  stOffset[csX] = arPOA[4]
  stOffset[csY] = arPOA[5]
  stOffset[csZ] = arPOA[6]
  stOffset[csD] = arPOA[7]
  return arPOA
end

function DecodePOA(sStr)
  if(not IsString(sStr)) then return StatusLog(nil,"DecodePOA(): Argument must be string") end
  local DatInd = 1
  local ComCnt = 0
  local Len = string.len(sStr)
  local SymOff = GetOpVar("OPSYM_DISABLE")
  local SymRev = GetOpVar("OPSYM_REVSIGN")
  local arPOA  = GetOpVar("ARRAY_DECODEPOA")
  local Ch = ""
  local S = 1
  local E = 1
  local Cnt = 1
  ReloadPOA()
  if(string.sub(sStr,Cnt,Cnt) == SymOff) then
    arPOA[7] = true
    Cnt = Cnt + 1
    S   = S   + 1
  end
  while(Cnt <= Len) do
    Ch = string.sub(sStr,Cnt,Cnt)
    if(Ch == SymRev) then
      arPOA[3+DatInd] = -arPOA[3+DatInd]
      S   = S + 1
    elseif(Ch == ",") then
      ComCnt = ComCnt + 1
      E = Cnt - 1
      if(ComCnt > 2) then break end
      arPOA[DatInd] = tonumber(string.sub(sStr,S,E)) or 0
      DatInd = DatInd + 1
      S = Cnt + 1
      E = S
    else
      E = E + 1
    end
    Cnt = Cnt + 1
  end
  arPOA[DatInd] = tonumber(string.sub(sStr,S,E)) or 0
  return arPOA
end

function PushSortValues(tTable,snCnt,nsValue,tData)
  local Cnt = math.floor(tonumber(snCnt) or 0)
  if(not (tTable and (type(tTable) == "table") and (Cnt > 0))) then return 0 end
  local Ind  = 1
  if(not tTable[Ind]) then
    tTable[Ind] = {Value = nsValue, Table = tData }
    return Ind
  else
    while(tTable[Ind] and (tTable[Ind].Value > nsValue)) do
      Ind = Ind + 1
    end
    if(Ind > Cnt) then return Ind end
    while(Ind < Cnt) do
      tTable[Cnt] = tTable[Cnt - 1]
      Cnt = Cnt - 1
    end
    tTable[Ind] = { Value = nsValue, Table = tData }
    return Ind
  end
end

function StringMakeSQL(sStr)
  if(not IsString(sStr)) then
    return StatusLog(nil,"StringMakeSQL: Only strings can be revised")
  end
  local Cnt = 1
  local Out = ""
  local Chr = string.sub(sStr,Cnt,Cnt)
  while(Chr ~= "") do
    Out = Out..Chr
    if(Chr == "'") then
      Out = Out..Chr
    end
    Cnt = Cnt + 1
    Chr = string.sub(sStr,Cnt,Cnt)
  end
  return Out
end

function ArrayDrop(arArr,nDir)
  if(not arArr and arArr[1]) then return arArr end
  local nDir = tonumber(nDir) or 0
  if(not nDir) then return arArr end
  if(nDir == 0) then return arArr end
  local nLen = my.ArrayCount(arArr)
  if(nLen <= 0) then return arArr end
  if(math.abs(nDir) > nLen) then return arArr end
  local nS   = 1
  local nD   = nS + math.abs(nDir)
  local nSig = (nDir > 0) and 1    or -1
  while(arArr[nD]) do
    if(nSig == 1) then
      arArr[nS] = arArr[nD]
    end
    nS = nS + 1
    nD = nD + 1
  end
  while(arArr[nS]) do
    arArr[nS] = nil
    nS = nS + 1
  end
  return arArr
end

function ArrayOrIndex(arArr,iEnd)
  if(not IsExistent(arArr)) then return StatusLog(nil,"ArrayCount: Array missing") end
  if(not (type(arArr) == "table")) then return StatusLog(nil,"ArrayCount: Array is "..type(arArr)) end
  local iEnd = tonumber(iEnd)
  if(not IsExistent(iEnd)) then return StatusLog(nil,"ArrayCount: End index not a number") end
  local iCnt, bFlg = 1, false
  while(iCnt <= iEnd) do
    bFlg = bFlg or (arArr[iCnt] and true or false)
    iCnt = iCnt + 1
  end return bFlg
end

function ArrayAndIndex(arArr,iEnd)
  if(not IsExistent(arArr)) then return StatusLog(nil,"ArrayCount: Array missing") end
  if(not (type(arArr) == "table")) then return StatusLog(nil,"ArrayCount: Array is "..type(arArr)) end
  local iEnd = tonumber(iEnd)
  if(not IsExistent(iEnd)) then return StatusLog(nil,"ArrayCount: End index not a number") end
  local iCnt, bFlg = 1, true
  while(iCnt <= iEnd) do
    bFlg = bFlg and (arArr[iCnt] and true or false)
    iCnt = iCnt + 1
  end return bFlg
end

function MakeContainer(sInfo,sDefKey)
  local Info = tostring(sInfo or "Store Container")
  local Curs = 0
  local Data = {}
  local Sel  = ""
  local Ins  = ""
  local Del  = ""
  local Met  = ""
  local Key  = sDefKey or "(!_+*#-$@DEFKEY@$-#*+_!)"
  local self = {}
  function self:GetInfo()
    return Info
  end
  function self:GetSize()
    return Curs
  end
  function self:GetData()
    return Data
  end
  function self:Insert(nsKey,anyValue)
    Ins = nsKey or Key
    Met = "I"
    if(not IsExistent(Data[Ins])) then
      Curs = Curs + 1
    end
    Data[Ins] = anyValue
    collectgarbage()
  end
  function self:Select(nsKey)
    Sel = nsKey or Key
    return Data[Sel]
  end
  function self:Delete(nsKey)
    Del = nsKey or Key
    Met = "D"
    if(IsExistent(Data[Del])) then
      Data[Del] = nil
      Curs = Curs - 1
      collectgarbage()
    end
  end
  function self:GetHistory()
    return tostring(Met)..GetOpVar("OPSYM_REVSIGN")..
           tostring(Sel)..GetOpVar("OPSYM_DIRECTORY")..
           tostring(Ins)..GetOpVar("OPSYM_DIRECTORY")..
           tostring(Del)
  end
  setmetatable(self,GetOpVar("TYPEMT_CONTAINER"))
  return self
end

function BorderValue(nVal,sName)
  if(not IsString(sName)) then return nVal end
  local Border = GetOpVar("TABLE_BORDERS")
        Border = Border[sName]
  if(IsExistent(Border)) then
    if    (nVal < Border[1]) then return Border[1]
    elseif(nVal > Border[2]) then return Border[2]
    else                          return nVal end
  end
  return nVal
end

function StringPad(sStr,sPad,nCnt)
  if(not IsString(sStr)) then return StatusLog("","StringPad(): String missing") end
  if(not IsString(sPad)) then return StatusLog(sStr,"StringPad(): Pad missing") end
  local Len = string.len(sStr)
  if(Len == 0) then return StatusLog(sStr,"StringPad(): Pad too short") end
  local Cnt = tonumber(nCnt)
  if(not Cnt) then return StatusLog(sStr,"StringPad(): Count missing") end
  local Dif = (math.abs(Cnt) - Len)
  if(Dif <= 0) then return StatusLog(sStr,"StringPad(): Padding Ignored") end
  local Ch = string.sub(sPad,1,1)
  local Pad = Ch
  Dif = Dif - 1
  while(Dif > 0) do
    Pad = Pad..Ch
    Dif = Dif - 1
  end
  if(Cnt > 0) then return (sStr..Pad) end
  return (Pad..sStr)
end

function ArrayPrint(arArr,sName,nCol)
  if(not IsExistent(arArr)) then return StatusLog(0,"ArrayPrint: Array missing") end
  if(not (type(arArr) == "table")) then return StatusLog(0,"ArrayPrint: Array is "..type(arArr)) end
  if(not (arArr and arArr[1])) then return StatusLog(0,"ArrayPrint: Array elements missing") end
  local Cnt  = 1
  local Col  = 0
  local Max  = 0
  local Cols = 0
  local Line = (sName or "Data").." = { \n"
  local Pad  = StringPad(" "," ",string.len(Line)-1)
  local Next
  while(arArr[Cnt]) do
    Col = string.len(tostring(arArr[Cnt]))
    if(Col > Max) then
      Max = Col
    end
    Cnt = Cnt + 1
  end
  Col  = math.Clamp((tonumber(nCol) or 1),1,100)
  Cols = Col-1
  Cnt  = 1
  while(arArr[Cnt]) do
    Next = arArr[Cnt + 1]
    if(nCol and Cols == Col-1) then
      Line = Line..Pad
    end
    Line = Line..StringPad(tostring(arArr[Cnt])," ",-Max-1)
    if(Next) then
      Line = Line..","
    end
    if(nCol and Cols == 0) then
      Cols = Col - 1
      if(Next) then
        Line = Line.."\n"
      end
    elseif(nCol and Cols > 0) then
      Cols = Cols - 1
    end
    Cnt = Cnt + 1
  end
  LogInstance(Line.."\n}")
end

function StringExplode(sStr,sDelim)
  print("asdfafd")
  if(not (IsString(sStr) and IsString(sDelim))) then
    return StatusLog(nil,"StringExplode: All parameters should be strings")
  end
  if(string.len(sDelim) <= 0) then -- Use less or equal as it is faster
    return StatusLog(nil,"StringExplode: Missing string exploding delimiter")
  end
  local sStr   = sStr
  local sDelim = string.sub(sDelim,1,1) -- Get the first character
  if(string.sub(sStr,-1,-1) ~= sDelim) then -- Triggers on the delimiter
    sStr = sStr..sDelim
  end
  local Data = {}
  local lenStr = string.len(sStr)
  local S, E, I, V = 1, 1, 1, ""
  while(E <= lenStr) do
    local Ch = string.sub(sStr,E,E)
    if(Ch == sDelim) then
      V = string.sub(sStr,S,E-1)
      S = E + 1
      Data[I] = V or ""
      I = I + 1
    end
    E = E + 1
  end
  return Data
end

function ArrayCount(arArr)
  if(not IsExistent(arArr)) then return StatusLog(0,"ArrayCount(): Array missing") end
  if(not (type(arArr) == "table")) then return StatusLog(0,"ArrayCount: Array is "..type(arArr)) end
  if(not (arArr and arArr[1])) then return StatusLog(0,"ArrayCount: Array empty") end
  local Count = 1
  while(arArr[Count]) do Count = Count + 1 end
  return (Count - 1)
end

function InitAssembly(sName)
  SetOpVar("TYPEMT_STRING",getmetatable("TYPEMT_STRING"))
  SetOpVar("TYPEMT_SCREEN",{})
  SetOpVar("TYPEMT_CONTAINER",{})
  if(not IsString(sName)) then
    return StatusPrint(false,"trackasmlib.lua: Error initializing. Expecting string argument")
  end
  if(stringLen(sName) < 1 and
     tonumber(stringSub(sName,1,1))) then return end
  sName = sName.."assembly"
  SetOpVar("TOOLNAME_NL",stringLower(sName))
  SetOpVar("TOOLNAME_NU",stringUpper(sName))
  SetOpVar("TOOLNAME_PL",GetOpVar("TOOLNAME_NL").."_")
  SetOpVar("TOOLNAME_PU",GetOpVar("TOOLNAME_NU").."_")
  SetOpVar("ARRAY_DECODEPOA",{0,0,0,1,1,1,false})
  SetOpVar("TABLE_FREQUENT_MODELS",{})
  SetOpVar("TABLE_BORDERS",{})
  SetOpVar("TABLE_LOCALIFY",{})
  SetOpVar("MISS_NOID","N")    -- No ID selected
  SetOpVar("MISS_NOAV","N/A")  -- Not Available
  SetOpVar("MISS_NOMD","X")    -- No model
  SetOpVar("HASH_USER_PANEL",GetOpVar("TOOLNAME_PU").."USER_PANEL")
  SetOpVar("HASH_QUERY_STORE",GetOpVar("TOOLNAME_PU").."QHASH_QUERY")
  SetOpVar("HASH_PLAYER_KEYDOWN","PLAYER_KEYDOWN")
  SetOpVar("HASH_PROPERTY_NAMES","PROPERTY_NAMES")
  SetOpVar("HASH_PROPERTY_TYPES","PROPERTY_TYPES")
  SetOpVar("FILE_MODEL","%.mdl")
  SetOpVar("OPSYM_DISABLE","#")
  SetOpVar("OPSYM_REVSIGN","@")
  SetOpVar("OPSYM_DIVIDER","_")
  SetOpVar("OPSYM_DIRECTORY","/")
  SetOpVar("DIRPATH_BAS",GetOpVar("TOOLNAME_NL")..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_EXP","export"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_DSV","dsvbase"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_LOG","")
  return true
end

--SQL---------------------------------

function SetDefaultType(sType)
  if(not IsString(sType)) then
    return StatusLog(nil,"SetDefaultType: Type name is not a string")
  end
  SetOpVar("DEFAULT_TYPE",sType)
end

function SetDefaultTable(sTable)
  if(not IsString(sTable)) then
    return StatusLog(nil,"SetDefaultTable: Table name is not a string")
  end
  SetOpVar("DEFAULT_TABLE",sTable)
end

function SQLGetBuildErr()
  return GetOpVar("SQL_BUILD_ERR") or ""
end

function SQLSetBuildErr(sError)
  if(not IsString(sError)) then
    return StatusLog(false,"SQLSetBuildErr: Build error message must be string")
  end
  SetOpVar("SQL_BUILD_ERR", sError)
  return false
end

local function MatchType(defTable,snValue,nIndex,bQuoted,sQuote)
  if(not defTable) then
    return StatusLog(nil,"MatchType: Missing: Table definition")
  end
  local nIndex = tonumber(nIndex)
  if(not nIndex) then
    return StatusLog(nil,"MatchType: Invalid: Field ID #"..tostring(nIndex).." on table "..defTable.Name)
  end
  local defField = defTable[nIndex]
  if(not defField) then
    return StatusLog(nil,"MatchType: Invalid: Field #"..tostring(nIndex).." on table "..defTable.Name)
  end
  local snOut
  local tipField = tostring(defField[2])
  local sModeDB  = tostring(GetOpVar("MODE_DATABASE"))
  if(tipField == "TEXT") then
    snOut = tostring(snValue)
    if(snOut == "nil" or snOut == "") then
      if(sModeDB == "SQL") then
        snOut = "NULL"
      elseif(sModeDB == "LUA") then
        snOut = ""
      else
        return StatusLog(nil,"MatchType: Wrong database mode")
      end
    end
    if(defField[3] == "LOW") then
      snOut = stringLower(snOut)
    elseif(defField[3] == "CAP") then
      snOut = stringUpper(snOut)
    end
    if(defField[4] == "QMK" and sModeDB == "SQL") then
      snOut = StringMakeSQL(snOut)
    end
    local sqChar
    if(bQuoted) then
      if(sQuote) then
        sqChar = stringSub(tostring(sQuote),1,1)
      else
        if(sModeDB == "SQL") then
          sqChar = "'"
        elseif(sModeDB == "LUA") then
          sqChar = "\""
        end
      end
      snOut = sqChar..snOut..sqChar
    end
  elseif(tipField == "REAL" or tipField == "INTEGER") then
    snOut = tonumber(snValue)
    if(not snOut) then
      return StatusLog(nil,"MatchType: Failed converting >"
               ..tostring(snValue).."< "..type(snValue)
               .." to NUMBER for table "..defTable.Name.." field #"..nIndex)
    end
    if(tipField == "INTEGER") then
      if(defField[3] == "FLR") then
        snOut = mathFloor(snOut)
      elseif(defField[3] == "CEL") then
        snOut = mathCeil(snOut)
      end
    end
  else
    return StatusLog(nil,"MatchType: Invalid: Field type >"..tipField
                                     .."< on table "..defTable.Name)
  end
  return snOut
end

function SQLBuildCreate(defTable)
  if(not defTable) then
    return SQLSetBuildErr("SQLBuildCreate: Missing: Table definition")
  end
  local TableName  = defTable.Name
  local TableIndex = defTable.Index
  if(not defTable[1]) then
    return SQLSetBuildErr("SQLBuildCreate: Missing: Table definition is empty for "..TableName)
  end
  if(not (defTable[1][1] and
          defTable[1][2])
  ) then
    return SQLSetBuildErr("SQLBuildCreate: Missing: Table "..TableName.." field definitions")
  end
  local Ind = 1
  local Command  = {}
  Command.Drop   = "DROP TABLE "..TableName..";"
  Command.Delete = "DELETE FROM "..TableName..";"
  Command.Create = "CREATE TABLE "..TableName.." ( "
  while(defTable[Ind]) do
    local v = defTable[Ind]
    if(not v[1]) then
      return SQLSetBuildErr("SQLBuildCreate: Missing Table "..TableName
                          .."'s field #"..tostring(Ind))
    end
    if(not v[2]) then
      return SQLSetBuildErr("SQLBuildCreate: Missing Table "..TableName
                                  .."'s field type #"..tostring(Ind))
    end
    Command.Create = Command.Create..string.upper(v[1]).." "..string.upper(v[2])
    if(defTable[Ind+1]) then
      Command.Create = Command.Create ..", "
    end
    Ind = Ind + 1
  end
  Command.Create = Command.Create.." );"
  if(TableIndex and
     TableIndex[1] and
     type(TableIndex[1]) == "table" and
     TableIndex[1][1] and
     type(TableIndex[1][1]) == "number"
   ) then
    Command.Index = {}
    Ind = 1
    Cnt = 1
    while(TableIndex[Ind]) do
      local vI = TableIndex[Ind]
      if(type(vI) ~= "table") then
        return SQLSetBuildErr("SQLBuildCreate: Index creator mismatch on "
          ..TableName.." value "..vI.." is not a table for index ["..tostring(Ind).."]")
      end
      local FieldsU = ""
      local FieldsC = ""
      Command.Index[Ind] = "CREATE INDEX IND_"..TableName
      Cnt = 1
      while(vI[Cnt]) do
        local vF = vI[Cnt]
        if(type(vF) ~= "number") then
          return SQLSetBuildErr("SQLBuildCreate: Index creator mismatch on "
            ..TableName.." value "..vF.." is not a number for index ["
            ..tostring(Ind).."]["..tostring(Cnt).."]")
        end
        if(not defTable[vF]) then
          return SQLSetBuildErr("SQLBuildCreate: Index creator mismatch on "
            ..TableName..". The table does not have field index #"
            ..vF..", max is #"..Table.Size)
        end
        FieldsU = FieldsU.."_" ..string.upper(defTable[vF][1])
        FieldsC = FieldsC..string.upper(defTable[vF][1])
        if(vI[Cnt+1]) then
          FieldsC = FieldsC ..", "
        end
        Cnt = Cnt + 1
      end
      Command.Index[Ind] = Command.Index[Ind]..FieldsU.." ON "..TableName.." ( "..FieldsC.." );"
      Ind = Ind + 1
    end
  end
  SetOpVar("SQL_BUILD_ERR", "")
  return Command
end

local function SQLStoreQuery(defTable,tFields,tWhere,tOrderBy,sQuery)
  if(not GetOpVar("EN_QUERY_STORE")) then return sQuery end
  local Val
  local Base
  if(not defTable) then
    return StatusLog(nil,"SQLStoreQuery: Missing: Table definition")
  end
  local Field = 1
  local Where = 1
  local Order = 1
  local CacheKey = GetOpVar("HASH_QUERY_STORE")
  local Cache    = libCache[CacheKey]
  local namTable = defTable.Name
  if(not IsExistent(Cache)) then
    libCache[CacheKey] = {}
    Cache = libCache[CacheKey]
  end
  local Place = Cache[namTable]
  if(not IsExistent(Place)) then
    Cache[namTable] = {}
    Place = Cache[namTable]
  end
  if(tFields) then
    while(tFields[Field]) do
      Val = defTable[tFields[Field]][1]
      if(not IsExistent(Val)) then
        return StatusLog(nil,"SQLStoreQuery: Missing: Field key for #"..tostring(Field))
      end
      if(Place[Val]) then
        Place = Place[Val]
      elseif(sQuery) then
        Base = Place
        Place[Val] = {}
        Place = Place[Val]
      else
        return nil
      end
      if(not Place) then return nil end
      Field = Field + 1
    end
  else
    Val = "ALL_FIELDS"
    if(Place[Val]) then
      Place = Place[Val]
    elseif(sQuery) then
      Base = Place
      Place[Val] = {}
      Place = Place[Val]
    else
      return nil
    end
  end
  if(tOrderBy) then
    while(tOrderBy[Order]) do
      Val = tOrderBy[Order]
      if(Place[Val]) then
        Base = Place
        Place = Place[Val]
      elseif(sQuery) then
        Base = Place
        Place[Val] = {}
        Place = Place[Val]
      else
        return StatusLog(nil,"SQLStoreQuery: Missing: Order field key for #"..tostring(Order))
      end
      Order = Order + 1
    end
  end
  if(tWhere) then
    while(tWhere[Where]) do
      Val = defTable[tWhere[Where][1]][1]
      if(not IsExistent(Val)) then
        return StatusLog(nil,"SQLStoreQuery: Missing: Where field key for #"..tostring(Where))
      end
      if(Place[Val]) then
        Base = Place
        Place = Place[Val]
      elseif(sQuery) then
        Base = Place
        Place[Val] = {}
        Place = Place[Val]
      else
        return nil
      end
      Val = tWhere[Where][2]
      if(not IsExistent(Val)) then
        return StatusLog(nil,"SQLStoreQuery: Missing: Where value key for #"..tostring(Where))
      end
      if(Place[Val]) then
        Base = Place
        Place = Place[Val]
      elseif(sQuery) then
        Base = Place
        Place[Val] = {}
        Place = Place[Val]
      end
      Where = Where + 1
    end
  end
  if(sQuery) then
    Base[Val] = sQuery
  end
  return Base[Val]
end

function SQLBuildSelect(defTable,tFields,tWhere,tOrderBy)
  if(not defTable) then
    return SQLSetBuildErr("SQLBuildSelect: Missing: Table definition")
  end
  local namTable = defTable.Name
  if(not (defTable[1][1] and
          defTable[1][2])
  ) then
    return SQLSetBuildErr("SQLBuildSelect: Missing: Table "..namTable.." field definitions")
  end
  local Command = SQLStoreQuery(defTable,tFields,tWhere,tOrderBy)
  if(Command) then
    print("Retrieve query")
    return Command
  end
  local Cnt = 1
  Command = "SELECT "
  if(tFields) then
    while(tFields[Cnt]) do
      local v = tonumber(tFields[Cnt])
      if(not v) then
        return SQLSetBuildErr("SQLBuildSelect: Select index #"
          ..tostring(tFields[Cnt])
          .." type mismatch in "..namTable)
      end
      if(defTable[v]) then
        if(defTable[v][1]) then
          Command = Command..defTable[v][1]
        else
          return SQLSetBuildErr("SQLBuildSelect: Select no such field name by index #"
            ..v.." in the table "..namTable)
        end
      end
      if(tFields[Cnt+1]) then
        Command = Command ..", "
      end
      Cnt = Cnt + 1
    end
  else
    Command = Command.."*"
  end
  Command = Command .." FROM "..namTable
  if(tWhere and
     type(tWhere == "table") and
     type(tWhere[1]) == "table" and
     tWhere[1][1] and
     tWhere[1][2] and
     type(tWhere[1][1]) == "number" and
     (type(tWhere[1][2]) == "string" or type(tWhere[1][2]) == "number")
  ) then
    Cnt = 1
    while(tWhere[Cnt]) do
      k = tonumber(tWhere[Cnt][1])
      v = tWhere[Cnt][2]
      t = defTable[k][2]
      if(not (k and v and t) ) then
        return SQLSetBuildErr("SQLBuildSelect: Where clause inconsistent on "
          ..namTable.." field index, {"..tostring(k)..", "..tostring(v)..", "..tostring(t)
          .."} value or type in the table definition")
      end
      v = MatchType(defTable,v,k,true)
      if(not IsExistent(v)) then
        return SQLSetBuildErr("SQLBuildSelect: Data matching failed on "
          ..namTable.." field index #"..Cnt.." value >"..tostring(v).."<")
      end
      if(Cnt == 1) then
        Command = Command.." WHERE "..defTable[k][1].." = "..v
      else
        Command = Command.." AND "..defTable[k][1].." = "..v
      end
      Cnt = Cnt + 1
    end
  end
  if(tOrderBy and (type(tOrderBy) == "table")) then
    local Dire = ""
    Command = Command.." ORDER BY "
    Cnt = 1
    while(tOrderBy[Cnt]) do
      local v = tOrderBy[Cnt]
      if(v ~= 0) then
        if(v > 0) then
          Dire = " ASC"
        else
          Dire = " DESC"
          v = -v
        end
      else
        return SQLSetBuildErr("SQLBuildSelect: Order wrong for "..namTable
                              .." field index #"..Cnt)
      end
        Command = Command..defTable[v][1]..Dire
        if(tOrderBy[Cnt+1]) then
          Command = Command..", "
        end
      Cnt = Cnt + 1
    end
  end
  SetOpVar("SQL_BUILD_ERR", "")
  return SQLStoreQuery(defTable,tFields,tWhere,tOrderBy,Command..";")
end

function SQLBuildInsert(defTable,tInsert,tValues)
  if(not (defTable and tValues)) then
    return SQLSetBuildErr("SQLBuildInsert: Missing Table definition or value fields")
  end
  local namTable = defTable.Name
  if(not defTable[1]) then
    return SQLSetBuildErr("SQLBuildInsert: The table and the chosen fields must not be empty")
  end
  if(not (defTable[1][1] and
          defTable[1][2])
  ) then
    return SQLSetBuildErr("SQLBuildInsert: Missing: Table "..namTable.." field definition")
  end
  local tInsert = tInsert or {}
  if(not tInsert[1]) then
    local iCnt = 1
    while(defTable[iCnt]) do
      tInsert[iCnt] = iCnt
      iCnt = iCnt + 1
    end
  end
  local iCnt = 1
  local qVal = " VALUES ( "
  local qIns = "INSERT INTO "..namTable.." ( "
  local Val, Ind, Fld
  while(tInsert[iCnt]) do
    Ind = tInsert[iCnt]
    Fld = defTable[Ind]
    if(not IsExistent(Fld)) then
      return SQLSetBuildErr("SQLBuildInsert: No such field #"..Ind.." on table "..namTable)
    end
    Val = MatchType(defTable,tValues[iCnt],Ind,true)
    if(not IsExistent(Val)) then
      return SQLSetBuildErr("SQLBuildInsert: Cannot match value >"..tostring(tValues[iCnt]).."< #"..Ind.." on table "..namTable)
    end
    qIns = qIns..Fld[1]
    qVal = qVal..Val
    if(tInsert[iCnt+1]) then
      qIns = qIns ..", "
      qVal = qVal ..", "
    else
      qIns = qIns .." ) "
      qVal = qVal .." );"
    end
    iCnt = iCnt + 1
  end
  SetOpVar("SQL_BUILD_ERR", "")
  return qIns..qVal
end

function CreateTable(sTable,defTable,bDelete,bReload)
  if(not IsString(sTable)) then return StatusLog(false,"CreateTable: Table key is not a string") end
  if(not (type(defTable) == "table")) then return StatusLog(false,"CreateTable: Table definition missing for "..sTable) end
  defTable.Size = ArrayCount(defTable)
  if(defTable.Size <= 0) then return StatusLog(false,"CreateTable: Record definition empty for "..sTable) end
  local sModeDB = GetOpVar("MODE_DATABASE")
  local sTable  = stringUpper(sTable)
  defTable.Name = GetOpVar("TOOLNAME_PU")..sTable
  SetOpVar("DEFTABLE_"..sTable,defTable)
  local sDisable = GetOpVar("OPSYM_DISABLE")
  local namTable = defTable.Name
  local Cnt, defField = 1, nil
  while(defTable[Cnt]) do
    defField    = defTable[Cnt]
    defField[3] = StringDefault(tostring(defField[3] or sDisable), sDisable)
    defField[4] = StringDefault(tostring(defField[4] or sDisable), sDisable)
    Cnt = Cnt + 1
  end
  libCache[namTable] = {}
  if(sModeDB == "SQL") then
    defTable.Life = tonumber(defTable.Life) or 0
    local tQ = SQLBuildCreate(defTable)
    if(not IsExistent(tQ)) then return StatusLog(false,"CreateTable: "..SQLBuildError()) end
    if(bDelete and sqlTableExists(namTable)) then
      local qRez = sqlQuery(tQ.Delete)
      if(not qRez and IsBool(qRez)) then
        LogInstance("CreateTable: Table "..sTable
          .." is not present. Skipping delete !")
      else
        LogInstance("CreateTable: Table "..sTable.." deleted !")
      end
    end
    if(bReload) then
      local qRez = sqlQuery(tQ.Drop)
      if(not qRez and IsBool(qRez)) then
        LogInstance("CreateTable: Table "..sTable
          .." is not present. Skipping drop !")
      else
        LogInstance("CreateTable: Table "..sTable.." dropped !")
      end
    end
    if(sqlTableExists(namTable)) then
      LogInstance("CreateTable: Table "..sTable.." exists!")
      return true
    else
      local qRez = sqlQuery(tQ.Create)
      if(not qRez and IsBool(qRez)) then
        return StatusLog(false,"CreateTable: Table "..sTable
          .." failed to create because of "..tostring(sqlLastError()))
      end
      if(sqlTableExists(namTable)) then
        for k, v in pairs(tQ.Index) do
          qRez = sqlQuery(v)
          if(not qRez and IsBool(qRez)) then
            return StatusLog(false,"CreateTable: Table "..sTable
              .." failed to create index ["..k.."] > "..v .." > because of "
              ..tostring(sqlLastError()))
          end
        end
        return StatusLog(true,"CreateTable: Indexed Table "..sTable.." created !")
      else
        return StatusLog(false,"CreateTable: Table "..sTable
          .." failed to create because of "..tostring(sqlLastError())
          .." Query ran > "..tQ.Create)
      end
    end
  elseif(sModeDB == "LUA") then
    sModeDB = "LUA" -- Gust to do something here.
  else
    return StatusLog(false,"CreateTable: Wrong database mode <"..sModeDB..">")
  end
end

function InsertRecord(sTable,tData)
  if(not IsExistent(sTable)) then
    return StatusLog(false,"InsertRecord: Missing: Table name/values")
  end
  if(type(sTable) == "table") then
    tData  = sTable
    sTable = DefaultTable()
    if(not (IsExistent(sTable) and sTable ~= "")) then
      return StatusLog(false,"InsertRecord: Missing: Table default name for "..sTable)
    end
  end
  if(not IsString(sTable)) then
    return StatusLog(false,"InsertRecord: Missing: Table definition name "..tostring(sTable).." ("..type(sTable)..")")
  end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"InsertRecord: Missing: Table definition for "..sTable)
  end
  if(not defTable[1])  then
    return StatusLog(false,"InsertRecord: Missing: Table definition is empty for "..sTable)
  end
  if(not tData)      then
    return StatusLog(false,"InsertRecord: Missing: Data table for "..sTable)
  end
  if(not tData[1])   then
    return StatusLog(false,"InsertRecord: Missing: Data table is empty for "..sTable)
  end
  local namTable = defTable.Name

  if(sTable == "PIECES") then
    tData[2] = StringDisable(tData[2],DefaultType(),"TYPE")
    tData[3] = StringDisable(tData[3],ModelToName(tData[1]),"MODEL")
  elseif(sTable == "PHYSPROPERTIES") then
    tData[1] = StringDisable(tData[1],DefaultType(),"TYPE")
  end

  local sModeDB = GetOpVar("MODE_DATABASE")
  if(sModeDB == "SQL") then
    local Q = SQLBuildInsert(defTable,nil,tData)
    if(not IsExistent(Q)) then return StatusLog(false,"InsertRecord: Build error: "..SQLBuildError()) end
    local qRez = sql.Query(Q)
    if(not qRez and IsBool(qRez)) then
       return StatusLog(false,"InsertRecord: Failed to insert a record because of "
              ..tostring(sql.LastError()).." Query ran <"..Q..">")
    end
    return true
  elseif(sModeDB == "LUA") then
    local snPrimayKey = MatchType(defTable,tData[1],1)
    if(not IsExistent(snPrimayKey)) then -- If primary key becomes a number
      return StatusLog(nil,"InsertRecord: Cannot match "
                          ..sTable.." <"..tostring(tData[1]).."> to "
                          ..defTable[1][1].." for "..tostring(snPrimayKey))
    end
    local Cache = libCache[namTable]
    if(not IsExistent(Cache)) then return StatusLog(false,"InsertRecord: Cache not allocated for "..namTable) end
    if(sTable == "PIECES") then
      local tLine = Cache[snPrimayKey]
      if(not tLine) then
        Cache[snPrimayKey] = {}
        tLine = Cache[snPrimayKey]
      end
      if(not IsExistent(tLine.Type)) then tLine.Type = tData[2] end
      if(not IsExistent(tLine.Name)) then tLine.Name = tData[3] end
      if(not IsExistent(tLine.Kept)) then tLine.Kept = 0        end
      local nOffsID = MatchType(defTable,tData[4],4) -- LineID has to be set properly
      if(not IsExistent(nOffsID)) then
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(tData[4]).."> to "
                            ..defTable[4][1].." for "..tostring(snPrimayKey))
      end
      local stRezul = RegisterPOA(tLine,nOffsID,tData[5],tData[6],tData[7])
      if(not IsExistent(stRezul)) then
        return StatusLog(nil,"InsertRecord: Cannot process offset #"..tostring(nOffsID).." for "..tostring(snPrimayKey))
      end
      if(nOffsID > tLine.Kept) then tLine.Kept = nOffsID else
        return StatusLog(nil,"InsertRecord: Offset #"..tostring(nOffsID).." sequentiality mismatch")
      end
    elseif(sTable == "ADDITIONS") then
      local tLine = Cache[snPrimayKey]
      if(not tLine) then
        Cache[snPrimayKey] = {}
        tLine = Cache[snPrimayKey]
      end
      if(not IsExistent(tLine.Kept)) then tLine.Kept = 0 end
      local nCnt, sFld, nAddID = 2, "", MatchType(defTable,tData[4],4)
      if(not IsExistent(nAddID)) then -- LineID has to be set properly
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(tData[4]).."> to "
                            ..defTable[4][1].." for "..tostring(snPrimayKey))
      end
      tLine[nAddID] = {}
      while(nCnt <= defTable.Size) do
        sFld = defTable[nCnt][1]
        tLine[nAddID][sFld] = MatchType(defTable,tData[nCnt],nCnt)
        if(not IsExistent(tLine[nAddID][sFld])) then  -- ADDITIONS is full of numbers
          return StatusLog(nil,"InsertRecord: Cannot match "
                    ..sTable.." <"..tostring(tData[nCnt]).."> to "
                    ..defTable[nCnt][1].." for "..tostring(snPrimayKey))
        end
        nCnt = nCnt + 1
      end
      tLine.Kept = nAddID
    elseif(sTable == "PHYSPROPERTIES") then
      local sKeyName = GetOpVar("HASH_PROPERTY_NAMES")
      local sKeyType = GetOpVar("HASH_PROPERTY_TYPES")
      local tTypes   = Cache[sKeyType]
      local tNames   = Cache[sKeyName]
      -- Handle the Type
      if(not tTypes) then
        Cache[sKeyType] = {}
        tTypes = Cache[sKeyType]
        tTypes.Kept = 0
      end
      if(not tNames) then
        Cache[sKeyName] = {}
        tNames = Cache[sKeyName]
      end
      local iNameID = MatchType(defTable,tData[2],2)
      if(not IsExistent(iNameID)) then -- LineID has to be set properly
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(tData[2]).."> to "
                            ..defTable[2][1].." for "..tostring(snPrimayKey))
      end
      if(not IsExistent(tNames[snPrimayKey])) then
        -- If a new type is inserted
        tTypes.Kept = tTypes.Kept + 1
        tTypes[tTypes.Kept] = snPrimayKey
        tNames[snPrimayKey] = {}
        tNames[snPrimayKey].Kept = 0
      end -- MatchType crashes only on numbers
      tNames[snPrimayKey][iNameID] = MatchType(defTable,tData[3],3)
      tNames[snPrimayKey].Kept = iNameID
    else
      return StatusLog(false,"InsertRecord: No settings for table "..sTable)
    end
  end
end

local function Qsort(Data,Lo,Hi)
  if(Lo and Hi and Lo > 0 and Lo < Hi) then
    local Mid = math.random(Hi-(Lo-1))+Lo-1
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
end

local function Ssort(Data,Lo,Hi)
  if(Lo and Hi and Lo > 0 and Lo < Hi) then
    local Ind = 1
    local Sel
    while(Data[Ind]) do
      Sel = Ind + 1
      while(Data[Sel]) do
        if(Data[Sel].Val <= Data[Ind].Val) then
          Data[Ind], Data[Sel] = Data[Sel], Data[Ind]
        end
        Sel = Sel + 1
      end
      Ind = Ind + 1
    end
  end
end

local function Bsort(Data,Lo,Hi)
  local Ind
  local End = false
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

function Sort(tTable,tKeys,tFields,sMethod)
  local Match = {}
  local tKeys = tKeys or {}
  local tFields = tFields or {}
  local Cnt, Ind, Key, Val, Fld = 1, nil, nil, nil, nil
  if(not tKeys[1]) then
    for k,v in pairs(tTable) do
      tKeys[Cnt] = k
      Cnt = Cnt + 1
    end
    Cnt = 1
  end
  while(tKeys[Cnt]) do
    Key = tKeys[Cnt]
    Val = tTable[Key]
    if(not Val) then
      return StatusLog(nil,"Sort: Key <"..Key.."> does not exist in the primary table")
    end
    Match[Cnt] = {}
    Match[Cnt].Key = Key
    if(type(Val) == "table") then
      Match[Cnt].Val = ""
      Ind = 1
      while(tFields[Ind]) do
        Fld = tFields[Ind]
        if(not IsExistent(Val[Fld])) then
          return StatusLog(nil,"Sort: Field <"..Fld.."> not found on the current record")
        end
        Match[Cnt].Val = Match[Cnt].Val..tostring(Val[Fld])
        Ind = Ind + 1
      end
    else
      Match[Cnt].Val = Val
    end
    Cnt = Cnt + 1
  end
  local sMethod = tostring(sMethod or "QIK")
  if(sMethod == "QIK") then
    Qsort(Match,1,Cnt-1)
  elseif(sMethod == "SEL") then
    Ssort(Match,1,Cnt-1)
  elseif(sMethod == "BBL") then
    Bsort(Match,1,Cnt-1)
  else
    return StatusLog(nil,"Sort: Method <"..sMethod.."> not found")
  end
  return Match
end

function InsertRecord(sTable,tData)
  if(not IsExistent(sTable)) then
    return StatusLog(false,"InsertRecord: Missing: Table name/values")
  end
  if(type(sTable) == "table") then
    tData  = sTable
    sTable = DefaultTable()
    if(not (IsExistent(sTable) and sTable ~= "")) then
      return StatusLog(false,"InsertRecord: Missing: Table default name for "..sTable)
    end
  end
  if(not IsString(sTable)) then
    return StatusLog(false,"InsertRecord: Missing: Table definition name "..tostring(sTable).." ("..type(sTable)..")")
  end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"InsertRecord: Missing: Table definition for "..sTable)
  end
  if(not defTable[1])  then
    return StatusLog(false,"InsertRecord: Missing: Table definition is empty for "..sTable)
  end
  if(not tData)      then
    return StatusLog(false,"InsertRecord: Missing: Data table for "..sTable)
  end
  if(not tData[1])   then
    return StatusLog(false,"InsertRecord: Missing: Data table is empty for "..sTable)
  end
  local namTable = defTable.Name

  if(sTable == "PIECES") then
    tData[2] = StringDisable(tData[2],DefaultType(),"TYPE")
    tData[3] = StringDisable(tData[3],ModelToName(tData[1]),"MODEL")
  elseif(sTable == "PHYSPROPERTIES") then
    tData[1] = StringDisable(tData[1],DefaultType(),"TYPE")
  end

  local sModeDB = GetOpVar("MODE_DATABASE")
  if(sModeDB == "SQL") then
    local Q = SQLBuildInsert(defTable,nil,tData)
    if(not IsExistent(Q)) then return StatusLog(false,"InsertRecord: Build error: "..SQLBuildError()) end
    local qRez = sql.Query(Q)
    if(not qRez and IsBool(qRez)) then
       return StatusLog(false,"InsertRecord: Failed to insert a record because of "
              ..tostring(sql.LastError()).." Query ran <"..Q..">")
    end
    return true
  elseif(sModeDB == "LUA") then
    local snPrimayKey = MatchType(defTable,tData[1],1)
    if(not IsExistent(snPrimayKey)) then -- If primary key becomes a number
      return StatusLog(nil,"InsertRecord: Cannot match "
                          ..sTable.." <"..tostring(tData[1]).."> to "
                          ..defTable[1][1].." for "..tostring(snPrimayKey))
    end
    local Cache = libCache[namTable]
    if(not IsExistent(Cache)) then return StatusLog(false,"InsertRecord: Cache not allocated for "..namTable) end
    if(sTable == "PIECES") then
      local tLine = Cache[snPrimayKey]
      if(not tLine) then
        Cache[snPrimayKey] = {}
        tLine = Cache[snPrimayKey]
      end
      if(not IsExistent(tLine.Type)) then tLine.Type = tData[2] end
      if(not IsExistent(tLine.Name)) then tLine.Name = tData[3] end
      if(not IsExistent(tLine.Kept)) then tLine.Kept = 0        end
      local nOffsID = MatchType(defTable,tData[4],4) -- LineID has to be set properly
      if(not IsExistent(nOffsID)) then
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(tData[4]).."> to "
                            ..defTable[4][1].." for "..tostring(snPrimayKey))
      end
      local stRezul = RegisterPOA(tLine,nOffsID,tData[5],tData[6],tData[7])
      if(not IsExistent(stRezul)) then
        return StatusLog(nil,"InsertRecord: Cannot process offset #"..tostring(nOffsID).." for "..tostring(snPrimayKey)) end
      if(nOffsID > tLine.Kept) then tLine.Kept = nOffsID else
        return StatusLog(nil,"InsertRecord: Offset #"..tostring(nOffsID).." sequentiality mismatch")
      end
    elseif(sTable == "ADDITIONS") then
      local tLine = Cache[snPrimayKey]
      if(not tLine) then
        Cache[snPrimayKey] = {}
        tLine = Cache[snPrimayKey]
      end
      if(not IsExistent(tLine.Kept)) then tLine.Kept = 0 end
      local nCnt, sFld, nAddID = 2, "", MatchType(defTable,tData[4],4)
      if(not IsExistent(nAddID)) then -- LineID has to be set properly
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(tData[4]).."> to "
                            ..defTable[4][1].." for "..tostring(snPrimayKey))
      end
      tLine[nAddID] = {}
      while(nCnt <= defTable.Size) do
        sFld = defTable[nCnt][1]
        tLine[nAddID][sFld] = MatchType(defTable,tData[nCnt],nCnt)
        if(not IsExistent(tLine[nAddID][sFld])) then  -- ADDITIONS is full of numbers
          return StatusLog(nil,"InsertRecord: Cannot match "
                    ..sTable.." <"..tostring(tData[nCnt]).."> to "
                    ..defTable[nCnt][1].." for "..tostring(snPrimayKey))
        end
        nCnt = nCnt + 1
      end
      tLine.Kept = nAddID
    elseif(sTable == "PHYSPROPERTIES") then
      local sKeyName = GetOpVar("HASH_PROPERTY_NAMES")
      local sKeyType = GetOpVar("HASH_PROPERTY_TYPES")
      local tTypes   = Cache[sKeyType]
      local tNames   = Cache[sKeyName]
      -- Handle the Type
      if(not tTypes) then
        Cache[sKeyType] = {}
        tTypes = Cache[sKeyType]
        tTypes.Kept = 0
      end
      if(not tNames) then
        Cache[sKeyName] = {}
        tNames = Cache[sKeyName]
      end
      local iNameID = MatchType(defTable,tData[2],2)
      if(not IsExistent(iNameID)) then -- LineID has to be set properly
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(tData[2]).."> to "
                            ..defTable[2][1].." for "..tostring(snPrimayKey))
      end
      if(not IsExistent(tNames[snPrimayKey])) then
        -- If a new type is inserted
        tTypes.Kept = tTypes.Kept + 1
        tTypes[tTypes.Kept] = snPrimayKey
        tNames[snPrimayKey] = {}
        tNames[snPrimayKey].Kept = 0
      end -- MatchType crashes only on numbers
      tNames[snPrimayKey][iNameID] = MatchType(defTable,tData[3],3)
      tNames[snPrimayKey].Kept = iNameID
    else
      return StatusLog(false,"InsertRecord: No settings for table "..sTable)
    end
  end
end

local function NavigateTable(oLocation,tKeys)
  if(not IsExistent(oLocation)) then return StatusLog(nil,"NavigateTable: Location missing") end
  if(not IsExistent(tKeys)) then return StatusLog(nil,"NavigateTable: Key table missing") end
  if(not IsExistent(tKeys[1])) then return StatusLog(nil,"NavigateTable: First key missing") end
  local Place, Key, Cnt = oLocation, tKeys[1], 1
  while(tKeys[Cnt]) do
    Key = tKeys[Cnt]
    if(tKeys[Cnt+1]) then
      Place = Place[Key]
      LogInstance("NavigateTable: Step ["..Key.."]")
      if(not IsExistent(Place)) then return StatusLog(nil,"NavigateTable: Key #"..tostring(Key).." irrelevant to location") end
    end
    Cnt = Cnt + 1
  end
  return Place, Key
end

function TimerSetting(sTimerSet) -- Generates a timer settings table and keeps the defaults
  if(not IsExistent(sTimerSet)) then return StatusLog(nil,"TimerSetting: Timer set missing for setup") end
  if(not IsString(sTimerSet)) then return StatusLog(nil,"TimerSetting: Timer set not a string but "..type(sTimerSet)) end
  local tBoom = StringExplode(sTimerSet,GetOpVar("OPSYM_REVSIGN"))
  tBoom[1] =   tostring(tBoom[1]  or "CQT")
  tBoom[2] =  (tonumber(tBoom[2]) or 0)
  tBoom[3] = ((tonumber(tBoom[3]) or 0) ~= 0) and true or false
  tBoom[4] = ((tonumber(tBoom[4]) or 0) ~= 0) and true or false
  return tBoom
end

local function TimerAttach(oLocation,tKeys,defTable,anyMessage)
  if(not defTable) then return StatusLog(nil,"TimerAttach: Missing table definition") end
  local Place, Key = NavigateTable(oLocation,tKeys)
  if(not (IsExistent(Place) and IsExistent(Key))) then return StatusLog(nil,"TimerAttach: Navigation failed") end
  if(not IsExistent(Place[Key])) then return StatusLog(nil,"TimerAttach: Data not found") end
  local sModeDB = GetOpVar("MODE_DATABASE")
  LogInstance("TimerAttach: Called by <"..anyMessage.."> for Place["..tostring(Key).."]")
  if(sModeDB == "SQL") then
    if(IsExistent(Place[Key].Kept)) then Place[Key].Kept = Place[Key].Kept - 1 end -- Get the proper line count
    local tTimer = defTable.Timer -- If we have a timer, and it does speak, we advise you send your regards..
    if(not IsExistent(tTimer)) then return StatusLog(Place[Key],"TimerAttach: Missing timer settings") end
    local nLifeTM = tTimer[2]
    if(nLifeTM <= 0) then return StatusLog(Place[Key],"TimerAttach: Timer attachment ignored") end
    local sModeTM = tTimer[1]
    local bKillRC = tTimer[3]
    local bCollGB = tTimer[4]
    LogInstance("TimerAttach: ["..sModeTM.."] ("..tostring(nLifeTM)..") "..tostring(bKillRC)..", "..tostring(bCollGB))
    if(sModeTM == "CQT") then
      Place[Key].Load = Time()
      for k, v in pairs(Place) do
        if(IsExistent(v.Used) and IsExistent(v.Load) and ((v.Used - v.Load) > nLifeTM)) then
          LogInstance("TimerAttach: ("..tostring(v.Used - v.Load).." > "..tostring(nLifeTM)..") > Dead")
          if(bKillRC) then
            LogInstance("TimerAttach: Killed: Place["..tostring(k).."]")
            Place[k] = nil
          end
        end
      end
      if(bCollGB) then
        collectgarbage()
        LogInstance("TimerAttach: Garbage collected")
      end
      return StatusLog(Place[Key],"TimerAttach: Place["..tostring(Key).."].Load = "..tostring(Place[Key].Load))
    elseif(sModeTM == "OBJ") then
      local TimerID = StringImplode(tKeys,"_")
      LogInstance("TimerAttach: TimID: <"..TimerID..">")
      if(timer.Exists(TimerID)) then return StatusLog(Place[Key],"TimerAttach: Timer exists") end
      timer.Create(TimerID, nLifeTM, 1, function()
        LogInstance("TimerAttach["..TimerID.."]("..nLifeTM..") > Dead")
        if(bKillRC) then
          LogInstance("TimerAttach: Killed: Place["..Key.."]")
          Place[Key] = nil
        end
        timer.Stop(TimerID)
        timer.Destroy(TimerID)
        if(bCollGB) then
          collectgarbage()
          LogInstance("TimerAttach: Garbage collected")
        end
      end)
      timer.Start(TimerID)
      return Place[Key]
    else
      return StatusLog(Place[Key],"TimerAttach: Timer mode not found: "..sModeTM)
    end
  elseif(sModeDB == "LUA") then
    return StatusLog(Place[Key],"TimerAttach: Memory manager not available")
  else
    return StatusLog(nil,"TimerAttach: Wrong database mode")
  end
end

local function TimerRestart(oLocation,tKeys,defTable,anyMessage)
  if(not defTable) then return StatusLog(nil,"TimerRestart: Missing table definition") end
  local Place, Key = NavigateTable(oLocation,tKeys)
  if(not (IsExistent(Place) and IsExistent(Key))) then return StatusLog(nil,"TimerRestart: Navigation failed") end
  if(not IsExistent(Place[Key])) then return StatusLog(nil,"TimerRestart: Place not found") end
  local sModeDB = GetOpVar("MODE_DATABASE")
  if(sModeDB == "SQL") then
    local tTimer = defTable.Timer
    if(not IsExistent(tTimer)) then return StatusLog(Place[Key],"TimerRestart: Missing timer settings") end
    Place[Key].Used = Time()
    local nLifeTM = tTimer[2]
    if(nLifeTM <= 0) then return StatusLog(Place[Key],"TimerRestart: Timer life ignored") end
    local sModeTM = tTimer[1]
    if(sModeTM == "CQT") then
      sModeTM = "CQT" -- Just for something to do here and to be known that this is mode CQT
    elseif(sModeTM == "OBJ") then
      local keyTimerID = StringImplode(tKeys,GetOpVar("OPSYM_DIVIDER"))
      if(not timer.Exists(keyTimerID)) then return StatusLog(nil,"TimerRestart: Timer missing: "..keyTimerID) end
      timer.Start(keyTimerID)
    else
      return StatusLog(nil,"TimerRestart: Timer mode not found: "..sModeTM)
    end
  elseif(sModeDB == "LUA") then
    Place[Key].Used = Time()
  else
    return StatusLog(nil,"TimerRestart: Wrong database mode")
  end
  return Place[Key]
end

-- Cashing the selected Piece Result
function CacheQueryPiece(sModel)
  if(not sModel) then return nil end
  if(not IsString(sModel)) then return nil end
  if(sModel == "") then return nil end
  local defTable = GetOpVar("DEFTABLE_PIECES")
  if(not defTable) then return StatusLog(nil,"CacheQueryPiece: Missing: Table definition") end
  local namTable = defTable.Name
  local Cache    = libCache[namTable]
  if(not IsExistent(Cache)) then return StatusLog(nil,"CacheQueryPiece: Cache not allocated for "..namTable) end
  local caInd    = {namTable,sModel}
  local stPiece  = Cache[sModel]
  if(IsExistent(stPiece) and IsExistent(stPiece.Kept)) then
    if(stPiece.Kept > 0) then
      return TimerRestart(libCache,caInd,defTable,"CacheQueryPiece")
    end
    return nil
  else
    local sModeDB = GetOpVar("MODE_DATABASE")
    local sModel  = MatchType(defTable,sModel,1,false,"",true,true)
    if(sModeDB == "SQL") then
      LogInstance("CacheQueryPiece: Model >> Pool: "..GetModelFileName(sModel))
      Cache[sModel] = {}
      stPiece = Cache[sModel]
      stPiece.Kept = 0
      local Q = SQLBuildSelect(defTable,nil,{{1,sModel}},{4})
      if(not IsExistent(Q)) then return StatusLog(nil,"CacheQueryPiece: Build error: "..SQLBuildError()) end
      local qData = sql.Query(Q)
      if(not qData and IsBool(qData)) then return StatusLog(nil,"CacheQueryPiece: SQL exec error "..sql.LastError()) end
      if(not (qData and qData[1])) then return StatusLog(nil,"CacheQueryPiece: No data found <"..Q..">") end
      stPiece.Kept = 1 --- Found at least one record
      stPiece.Type = qData[1][defTable[2][1]]
      stPiece.Name = qData[1][defTable[3][1]]
      local qRec, qRez
      while(qData[stPiece.Kept]) do
        qRec = qData[stPiece.Kept]
        qRez = RegisterPOA(stPiece,
                           stPiece.Kept,
                           qRec[defTable[5][1]],
                           qRec[defTable[6][1]],
                           qRec[defTable[7][1]])
        if(not IsExistent(qRez)) then
          return StatusLog(nil,"CacheQueryPiece: Cannot process offset #"..tostring(stPiece.Kept).." for "..sModel)
        end
        stPiece.Kept = stPiece.Kept + 1
      end
      return TimerAttach(libCache,caInd,defTable,"CacheQueryPiece")
    elseif(sModeDB == "LUA") then
      return StatusLog(nil,"CacheQueryPiece: Record not located")
    else
      return StatusLog(nil,"CacheQueryPiece: Wrong database mode <"..sModeDB..">")
    end
  end
end

function CacheQueryPanel()
  local defTable = GetOpVar("TABLEDEF_PIECES")
  if(not defTable) then
    return StatusLog(false,"CacheQueryPanel: Missing: Table definition")
  end
  local namTable = defTable.Name
  local CacheKey = GetOpVar("HASH_USER_PANEL")
  local Cache = libCache[namTable]
  if(not IsExistent(Cache)) then
    return StatusLog(nil,"CacheQueryPanel: Cache not allocated for "..namTable)
  end
  local Panel = Cache[CacheKey]
  if(IsExistent(Panel)) then
    LogInstance("CacheQueryPanel: From Pool")
    return Panel
  else
    local sModeDB = tostring(GetOpVar("MODE_DATABASE"))
    if(sModeDB == "SQL") then
      local Q = SQLBuildSelect(defTable,{1,2,3},{{4,1}},{2,3})
      if(Q) then
        local qData = sql.Query(Q)
        if(qData and qData[1]) then
          Cache[CacheKey] = qData
          LogInstance("CacheQueryPanel: To Pool")
          return qData
        end
        return StatusLog(nil,"CacheQueryPanel: No data found >"..Q.."<")
      end
      return StatusLog(nil,"CacheQueryPanel: "..SQLGetBuildErr())
    elseif(sModeDB == "LUA") then
      if(not Cache[CacheKey]) then
        Cache[CacheKey] = {}
      end
      local tData = {}
      local iNdex = 0
      for sModel, tRecord in pairs(Cache) do
        iNdex = stringLen(sModel)
        if(stringSub(sModel,iNdex-3,iNdex) == ".mdl") then
          tData[sModel] = { [defTable[1][1]] = sModel, [defTable[2][1]] = tRecord.Type, [defTable[3][1]] = tRecord.Name }
        end
      end
      local tSorted = Sort(tData,nil,{defTable[1][1],defTable[2][1],defTable[3][1]})
      if(not tSorted) then
        return StatusLog(nil,"CacheQueryPanel: Cannot sort cache data")
      end
      iNdex = 1
      while(tSorted[iNdex]) do
        Cache[CacheKey][iNdex] = tData[tSorted[iNdex].Key]
        iNdex = iNdex + 1
      end
      LogInstance("CacheQueryPanel: To Pool")
      return Cache[CacheKey]
    else
      return StatusLog(nil,"CacheQueryPanel: Wrong database mode")
    end
  end
end

local function GetFieldsName(defTable,sDelim)
  if(not IsExistent(sDelim)) then return "" end
  if(not IsString(sDelim)) then return "" end
  local sDelim  = stringSub(sDelim,1,1)
  local sResult = ""
  local iCount  = 1
  local namField
  while(defTable[iCount]) do
    namField = defTable[iCount][1]
    if(not IsString(namField)) then
      return StatusLog("","GetFieldsName: Invalid field #"..iCount.." for "..defTable.Name)
    end
    sResult = sResult..namField
    if(defTable[iCount + 1]) then sResult = sResult..sDelim end
    iCount = iCount + 1
  end
  return sResult
end

function ExportDB(sTable,sDelim,sPrefix,sMethod)
  Print(debug.getinfo(1),"Info")
  local dbFunc = debug.getinfo(1) and debug.getinfo(1).name or ""
  print(dbFunc)
  if(not IsString(sTable)) then
    return StatusLog(false,"ExportIntoDSV: Table name should be string but "..type(sTable))
  end
  local defTable = GetOpVar("TABLEDEF_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ExportIntoDSV: Missing: Table definition for "..sTable)
  end
  local namTable = defTable.Name
  local Bas = GetOpVar("DIRPATH_BAS")
  local Dsv = GetOpVar("DIRPATH_DSV")
  local BasDsv = Bas..Dsv
  local Cache = libCache[namTable]
  if(not IsExistent(Cache)) then
    return StatusLog(false,"ExportIntoDSV: Cache not allocated for "..namTable)
  end
  local F = io.open("E:/Documents/Lua-Projs/Lua/Projects/TempTest/data.txt","w+")
            io.output(F)

  local sModeDB  = tostring(GetOpVar("MODE_DATABASE"))
  local sMethod = tostring(sMethod)
  io.write("# Exported on: "..os.date().." [ "..sModeDB.." ]".."\n")
  io.write("# Table info: "..namTable..sDelim..GetFieldsName(defTable,sDelim).."\n")
  if(sModeDB == "SQL") then
    local Q = ""
    local sData = ""
    local sTemp = ""
    if(sTable == "PIECES") then
      Q = SQLBuildSelect(defTable,nil,nil,{2,3,1,4})
    elseif(sTable == "ADDITIONS") then
      Q = SQLBuildSelect(defTable,nil,nil,{1,2,3})
    elseif(sTable == "PHYSPROPERTIES") then
      Q = SQLBuildSelect(defTable,nil,nil,{1,2})
    else
      Q = SQLBuildSelect(defTable,nil,nil,nil)
    end
    if(Q) then
      io.write("# Query ran: >"..Q.."<\n")
      --OLD-- local qData = sql.Query(Q)
      -------- Just for the test
      local qData = GetOpVar("TEST_QUERY_DATA")
      --------
      if(qData and qData[1]) then
        local qRec
        local iCnt, iInd = 1, 1
        if(sMethod == "DSV") then
          sData = namTable..sDelim
        elseif(sMethod == "INS") then
          sData = "  asmlib.InsertRecord(\""..sTable.."\", {"
        else
          return StatusLog(false,"ExportDB: Missed export method "..sMethod)
        end
        while(qData[iCnt]) do
          iInd = 1
          sTemp = sData
          qRec = qData[iCnt]
          while(defTable[iInd]) do
            sTemp = sTemp..MatchType(defTable,qRec[defTable[iInd][1]],iInd,true,"\"")
            if(defTable[iInd + 1]) then sTemp = sTemp..sDelim end
            iInd = iInd + 1
          end
          if(sMethod == "DSV") then
            sTemp = sTemp.."\n"
          elseif(sMethod == "INS") then
            sTemp = sTemp.."})\n"
          end
          io.write(sTemp)
          iCnt = iCnt + 1
        end
        return true
      end
      return StatusLog(false,"ExportIntoDSV: No data found >"..Q.."<")
    end
    return StatusLog(false,"ExportIntoDSV: "..SQLGetBuildErr())
  elseif(sModeDB == "LUA") then
    local sData = ""
    local sTemp = ""
    local extModel = GetOpVar("FILE_EXTENSION_MODEL")
    if(sTable == "PIECES") then
      local tData = {}
      local iInd iNdex = 1,1
      for sModel, tRecord in pairs(Cache) do
        iNdex = stringLen(sModel)
        if(stringSub(sModel,iNdex-3,iNdex) == extModel) then
          sData = tRecord.Type..tRecord.Name..sModel
          tData[sModel] = {[defTable[1][1]] = sData}
        end
      end
      local tSorted = Sort(tData,nil,{defTable[1][1]})
      if(not tSorted) then
        return StatusLog(false,"ExportDB: Cannot sort cache data")
      end
      iNdex = 1
      while(tSorted[iNdex]) do
        iInd = 1
        tData = Cache[tSorted[iNdex].Key]
        if(sMethod == "DSV") then
          sData = namTable..sDelim
        elseif(sMethod == "INS") then
          sData = "  asmlib.InsertRecord(\""..sTable.."\", {"
        else
          return StatusLog(false,"ExportDB: Missed export method "..sMethod)
        end
        sData = sData..MatchType(defTable,tSorted[iNdex].Key,1,true,"\"")..sDelim..
                       MatchType(defTable,tData.Type,2,true,"\"")..sDelim..
                       MatchType(defTable,tData.Name,3,true,"\"")..sDelim

        while(tData.Offs[iInd]) do
            sTemp = sData..MatchType(defTable,tostring(iInd),4,true,"\"")..sDelim..
                          "\""..StringPOA(tData.Offs,iInd,"P").."\""..sDelim..
                          "\""..StringPOA(tData.Offs,iInd,"O").."\""..sDelim..
                          "\""..StringPOA(tData.Offs,iInd,"A").."\""
          if(sMethod == "DSV") then
            sTemp = sTemp.."\n"
          elseif(sMethod == "INS") then
            sTemp = sTemp.."})\n"
          end
          io.write(sTemp)
          iInd = iInd  + 1
        end
        iNdex = iNdex + 1
      end
    elseif(sTable == "ADDITIONS") then
      local iNdex, tData
      for sModel, tRecord in pairs(Cache) do
        iNdex = stringLen(sModel)
        if(stringSub(sModel,iNdex-3,iNdex) == extModel) then
          if(sMethod == "DSV") then
            sData = namTable..sDelim..sModel..sDelim
          elseif(sMethod == "INS") then
            sData = "  asmlib.InsertRecord(\""..sTable.."\", {"
          else
            return StatusLog(false,"ExportDB: Missed export method "..sMethod)
          end
          iNdex = 1
          while(tRecord[iNdex]) do
            tData = tRecord[iNdex]
            sTemp = sData..MatchType(defTable,tData[defTable[2 ][1]],2 ,true,"\"")..sDelim..
                           MatchType(defTable,tData[defTable[3 ][1]],3 ,true,"\"")..sDelim..
                           MatchType(defTable,tData[defTable[4 ][1]],4 ,true,"\"")..sDelim..
                           MatchType(defTable,tData[defTable[5 ][1]],5 ,true,"\"")..sDelim..
                           MatchType(defTable,tData[defTable[6 ][1]],6 ,true,"\"")..sDelim..
                           MatchType(defTable,tData[defTable[7 ][1]],7 ,true,"\"")..sDelim..
                           MatchType(defTable,tData[defTable[8 ][1]],8 ,true,"\"")..sDelim..
                           MatchType(defTable,tData[defTable[9 ][1]],9 ,true,"\"")..sDelim..
                           MatchType(defTable,tData[defTable[10][1]],10,true,"\"")..sDelim..
                           MatchType(defTable,tData[defTable[11][1]],11,true,"\"")
            if(sMethod == "DSV") then
              sTemp = sTemp.."\n"
            elseif(sMethod == "INS") then
              sTemp = sTemp.."})\n"
            end
            io.write(sTemp)
            iNdex = iNdex + 1
          end
        end
      end
    elseif(sTable == "PHYSPROPERTIES") then
      local tTypes = Cache[GetOpVar("HASH_PROPERTY_TYPES")]
      local tNames = Cache[GetOpVar("HASH_PROPERTY_NAMES")]
      if(not (tTypes or tNames)) then return StatusLog(false,"ExportIntoDSV: No data found") end
      local iInd, iCnt = 1, 1
      local sType, sName = "", ""
      local tType
      while(tTypes[iInd]) do
        sType = tTypes[iInd]
        tType = tNames[sType]
        if(not tType) then return StatusLog(false,"ExportIntoDSV: Missing index #"..iInd.." on type "..sType) end
        if(sMethod == "DSV") then
          sData = namTable..sDelim
        elseif(sMethod == "INS") then
          sData = "  asmlib.InsertRecord(\""..sTable.."\", {"
        else
          return StatusLog(false,"ExportDB: Missed export method "..sMethod)
        end
        iCnt = 1
        while(tType[iCnt]) do
          sTemp = sData..MatchType(defTable,sType      ,1,true,"\"")..sDelim..
                         MatchType(defTable,iCnt       ,2,true,"\"")..sDelim..
                         MatchType(defTable,tType[iCnt],3,true,"\"")
          if(sMethod == "DSV") then
            sTemp = sTemp.."\n"
          elseif(sMethod == "INS") then
            sTemp = sTemp.."})\n"
          end
          io.write(sTemp)
          iCnt = iCnt + 1
        end
        iInd = iInd + 1
      end
    end
  end
end

SetOpVar("TIME_EPOCH",osClock())

local function ReloadPOA(nXP,nYY,nZR,nSX,nSY,nSZ,nSD)
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
        arPOA[1] = tonumber(nXP) or 0
        arPOA[2] = tonumber(nYY) or 0
        arPOA[3] = tonumber(nZR) or 0
        arPOA[4] = tonumber(nSX) or 1
        arPOA[5] = tonumber(nSY) or 1
        arPOA[6] = tonumber(nSZ) or 1
        arPOA[7] = (tonumber(nSD) and (nSD ~= 0)) and true or false
  return arPOA
end

local function IsEqualPOA(stOffsetA,stOffsetB)
  if(not IsExistent(stOffsetA)) then return StatusLog(nil,"EqualPOA: Missing OffsetA") end
  if(not IsExistent(stOffsetB)) then return StatusLog(nil,"EqualPOA: Missing OffsetB") end
  for Ind, Comp in pairs(stOffsetA) do
    if(Ind ~= csD and stOffsetB[Ind] ~= Comp) then return false end
  end
  return true
end

local function StringPOA(arOffs,iID,sOffs)
  if(not IsExistent(arOffs)) then return StatusLog(nil,"StringPOA: Missing Offsets") end
  local iID = tonumber(iID)
  if(not IsExistent(iID))    then return StatusLog(nil,"StringPOA: Missing PointID") end
  local Offset = arOffs[iID]
  if(not IsExistent(Offset)) then return StatusLog(nil,"StringPOA: No PointID") end
  local sEmpty
  local sResult = ""
  local sOffset = tostring(sOffs)
  local symRevs = GetOpVar("OPSYM_REVSIGN")
  local symDisa = GetOpVar("OPSYM_DISABLE")
  local sModeDB = GetOpVar("MODE_DATABASE")
  if    (sModeDB == "SQL") then sEmpty = "NULL"
  elseif(sModeDB == "LUA") then sEmpty = "NULL"
  else return StatusLog("","StringPOA: Missed database mode "..sModeDB)
  end
  if(sOffset == "P") then
    if(not Offset.P[csD]) then
      if(IsEqualPOA(Offset.P,Offset.O)) then
        sResult = sEmpty
      else
        sResult = ((Offset.P[csX] == -1) and symRevs or "")..tostring(Offset.P[cvX])..","
                ..((Offset.P[csY] == -1) and symRevs or "")..tostring(Offset.P[cvY])..","
                ..((Offset.P[csZ] == -1) and symRevs or "")..tostring(Offset.P[cvZ])
      end
    else
      sResult = symDisa
    end
  elseif(sOffset == "O") then
    sResult = ((Offset.O[csX] == -1) and symRevs or "")..tostring(Offset.O[cvX])..","
            ..((Offset.O[csY] == -1) and symRevs or "")..tostring(Offset.O[cvY])..","
            ..((Offset.O[csZ] == -1) and symRevs or "")..tostring(Offset.O[cvZ])
  elseif(sOffset == "A") then
    if(Offset.A[caP] == 0 and Offset.A[caY] == 0 and Offset.A[caR] == 0) then
      sResult = sEmpty
    else
      sResult = ((Offset.A[csX] == -1) and symRevs or "")..tostring(Offset.A[caP])..","
              ..((Offset.A[csY] == -1) and symRevs or "")..tostring(Offset.A[caY])..","
              ..((Offset.A[csZ] == -1) and symRevs or "")..tostring(Offset.A[caR])
    end
  else
    return StatusLog("","StringPOA: Missed offset mode "..sOffset)
  end
  return stringGsub(sResult," ","") -- Get rid of the spaces
end

local function TransferPOA(stOffset,sMode)
  if(not IsExistent(stOffset)) then return StatusLog(nil,"TransferPOA: Destination needed") end
  if(not IsString(sMode)) then return StatusLog(nil,"TransferPOA: Mode must be string") end
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
  if(sMode == "POS") then
    stOffset[cvX] = arPOA[1]
    stOffset[cvY] = arPOA[2]
    stOffset[cvZ] = arPOA[3]
  elseif(sMode == "ANG") then
    stOffset[caP] = arPOA[1]
    stOffset[caY] = arPOA[2]
    stOffset[caR] = arPOA[3]
  end
  stOffset[csX] = arPOA[4]
  stOffset[csY] = arPOA[5]
  stOffset[csZ] = arPOA[6]
  stOffset[csD] = arPOA[7]
  return arPOA
end

local function DecodePOA(sStr)
  if(not IsString(sStr)) then return StatusLog(nil,"DecodePOA: Argument must be string") end
  local DatInd = 1
  local ComCnt = 0
  local Len    = stringLen(sStr)
  local SymOff = GetOpVar("OPSYM_DISABLE")
  local SymRev = GetOpVar("OPSYM_REVSIGN")
  local arPOA  = GetOpVar("ARRAY_DECODEPOA")
  local Ch = ""
  local S = 1
  local E = 1
  local Cnt = 1
  ReloadPOA()
  if(stringSub(sStr,Cnt,Cnt) == SymOff) then
    arPOA[7] = true
    Cnt = Cnt + 1
    S   = S   + 1
  end
  while(Cnt <= Len) do
    Ch = stringSub(sStr,Cnt,Cnt)
    if(Ch == SymRev) then
      arPOA[3+DatInd] = -arPOA[3+DatInd]
      S   = S + 1
    elseif(Ch == ",") then
      ComCnt = ComCnt + 1
      E = Cnt - 1
      if(ComCnt > 2) then break end
      arPOA[DatInd] = tonumber(stringSub(sStr,S,E)) or 0
      DatInd = DatInd + 1
      S = Cnt + 1
      E = S
    else
      E = E + 1
    end
    Cnt = Cnt + 1
  end
  arPOA[DatInd] = tonumber(stringSub(sStr,S,E)) or 0
  return arPOA
end

function RegisterPOA(stPiece, nID, sP, sO, sA)
  if(not stPiece) then return StatusLog(nil,"RegisterPOA: Cache record invalid") end
  local nID = tonumber(nID)
  if(not nID) then return StatusLog(nil,"RegisterPOA: OffsetID is not a number") end
  local sP = sP or "NULL"
  local sO = sO or "NULL"
  local sA = sA or "NULL"
  if(not IsString(sP)) then return StatusLog(nil,"RegisterPOA: Point is not a string") end
  if(not IsString(sO)) then return StatusLog(nil,"RegisterPOA: Origin is not a string") end
  if(not IsString(sA)) then return StatusLog(nil,"RegisterPOA: Angle is not a string") end
  if(not stPiece.Offs) then
    if(nID > 1) then return StatusLog(nil,"RegisterPOA: First ID cannot be "..tostring(nID)) end
    stPiece.Offs = {}
  end
  local tOffs = stPiece.Offs
  if(tOffs[nID]) then
    return StatusLog(nil,"RegisterPOA: Exists ID #"..tostring(nID))
  else
    if((nID > 1) and (not tOffs[nID - 1])) then return StatusLog(nil,"RegisterPOA: Not sequential ID #"..tostring(nID - 1)) end
    tOffs[nID]   = {}
    tOffs[nID].P = {}
    tOffs[nID].O = {}
    tOffs[nID].A = {}
    tOffs        = tOffs[nID]
  end
  if((sO ~= "") and (sO ~= "NULL")) then DecodePOA(sO)
  else ReloadPOA() end TransferPOA(tOffs.O,"POS")
  if((sP ~= "") and (sP ~= "NULL")) then DecodePOA(sP) end
  TransferPOA(tOffs.P,"POS") -- in the POA array still persists the decoded Origin
  if(stringSub(sP,1,1) == GetOpVar("OPSYM_DISABLE")) then tOffs.P[csD] = true end
  if((sA ~= "") and (sA ~= "NULL")) then DecodePOA(sA)
  else ReloadPOA() end TransferPOA(tOffs.A,"ANG")
  return tOffs
end

function RoundValue(nvExact, nFrac)
  local nExact = tonumber(nvExact)
  if(not IsExistent(nExact)) then
    return StatusLog(nil,"RoundValue: Cannot round NAN {"..type(nvExact).."}<"..tostring(nvExact)..">") end
  local nFrac = tonumber(nFrac) or 0
  if(nFrac == 0) then
    return StatusLog(nil,"RoundValue: Fraction must be <> 0") end
  local q, f = mathModf(nExact/nFrac)
  return nFrac * (q + (f > 0.5 and 1 or 0))
end

function makeEntity()
  local self = {}
  function self:GetPos()
    local P = {}
          P[cvX] = 10
          P[cvY] = 10
          P[cvZ] = 10
    return P
  end
  function self:GetAngles()
    local A = {}
          A[caP] = 30
          A[caY] = 30
          A[caR] = 30
    return A
  end
  function self:GetModel()
    return "props/models/some_track.mdl"
  end
  function self:IsValid()
    return true
  end
  return self
end

function StringToBack(sPath)
  if(not IsString(sPath)) then
    return StatusLog(GetOpVar("MISS_NOAV"),"StringToFile: Path must be string") end
  if(IsEmptyString(sPath)) then
    return StatusLog(GetOpVar("MISS_NOAV"),"StringToFile: Path is empty") end
  local sSymDir = GetOpVar("OPSYM_DIRECTORY")
  local nCnt = -1
  local sCh  = stringSub(sPath,nCnt,nCnt)
  while(not IsEmptyString(sCh) and sCh ~= sSymDir) do
    nCnt = nCnt - 1
    sCh  = stringSub(sPath,nCnt,nCnt)
  end
  return stringSub(sPath,nCnt+1,-1)
end

function StringToFile(sPath)
  if(not IsString(sPath)) then
    return StatusLog(GetOpVar("MISS_NOAV"),"StringToFile: Path must be string") end
  if(IsEmptyString(sPath)) then
    return StatusLog(GetOpVar("MISS_NOAV"),"StringToFile: Path is empty") end
  local sSymDir = GetOpVar("OPSYM_DIRECTORY")
  local nLen = stringLen(sPath)
  local nCnt = nLen
  local sCh  = stringSub(sPath,nCnt,nCnt)
  while(sCh ~= sSymDir and nCnt > 0) do
    nCnt = nCnt - 1
    sCh  = stringSub(sPath,nCnt,nCnt)
  end
  return stringSub(sPath,nCnt+1,Len)
end

function SetLocalify(sCode, sPhrase, sDetail)
  if(not IsString(sCode)) then
    return StatusLog(nil,"SetLocalify: Language code <"..tostring(sCode).."> invalid") end
  if(not IsString(sPhrase)) then
    return StatusLog(nil,"SetLocalify: Phrase words <"..tostring(sPhrase).."> invalid") end
  local Localify = GetOpVar("TABLE_LOCALIFY")
  if(not IsExistent(Localify[sCode])) then Localify[sCode] = {}; end
  Localify[sCode][sPhrase] = sDetail
end

function InitLocalify(sCode) -- https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
  if(not IsString(sCode)) then -- https://en.wikipedia.org/wiki/ISO_639-2
    return StatusLog(nil,"InitLocalify: Laguage code <"..tostring(sCode).."> invalid") end
  local Localify = GetOpVar("TABLE_LOCALIFY")
  if(not IsExistent(Localify[sCode])) then
    return StatusLog(nil,"GetLocalify: Language not found for <"..sCode..">") end
  for phrase, detail in pairs(Localify[sCode]) do
    print(phrase, detail)
  end
end
