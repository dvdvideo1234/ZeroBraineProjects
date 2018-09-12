--- Because Vec[1] is actually faster than Vec.X

--- Vector Component indexes ---
local cvX -- Vector X component
local cvY -- Vector Y component
local cvZ -- Vector Z component

--- Angle Component indexes ---
local caP -- Angle Pitch component
local caY -- Angle Yaw   component
local caR -- Angle Roll  component

--- Component Status indexes ---
local csA -- Sign of the first component
local csB -- Sign of the second component
local csC -- Sign of the third component
local csD -- Flag for disabling the point

---------------- Localizing instances ------------------
local SERVER = SERVER
local CLIENT = CLIENT

---------------- Localizing Player keys ----------------
local IN_ALT1      = IN_ALT1
local IN_ALT2      = IN_ALT2
local IN_ATTACK    = IN_ATTACK
local IN_ATTACK2   = IN_ATTACK2
local IN_BACK      = IN_BACK
local IN_DUCK      = IN_DUCK
local IN_FORWARD   = IN_FORWARD
local IN_JUMP      = IN_JUMP
local IN_LEFT      = IN_LEFT
local IN_MOVELEFT  = IN_MOVELEFT
local IN_MOVERIGHT = IN_MOVERIGHT
local IN_RELOAD    = IN_RELOAD
local IN_RIGHT     = IN_RIGHT
local IN_SCORE     = IN_SCORE
local IN_SPEED     = IN_SPEED
local IN_USE       = IN_USE
local IN_WALK      = IN_WALK
local IN_ZOOM      = IN_ZOOM

---------------- Localizing ENT Properties ----------------
local MASK_SOLID            = MASK_SOLID
local SOLID_VPHYSICS        = SOLID_VPHYSICS
local MOVETYPE_VPHYSICS     = MOVETYPE_VPHYSICS
local COLLISION_GROUP_NONE  = COLLISION_GROUP_NONE
local RENDERMODE_TRANSALPHA = RENDERMODE_TRANSALPHA

---------------- Localizing needed functions ----------------
local next                    = next
local type                    = type
local pcall                   = pcall
local Angle                   = Angle
local Color                   = Color
local pairs                   = pairs
local print                   = print
local tobool                  = tobool
local Vector                  = Vector
local unpack                  = unpack
local include                 = include
local IsValid                 = IsValid
local Material                = Material
local require                 = require
local Time                    = os.clock
local tonumber                = tonumber
local tostring                = tostring
local GetConVar               = GetConVar
local LocalPlayer             = LocalPlayer
local CreateConVar            = CreateConVar
local SetClipboardText        = SetClipboardText
local CompileString           = CompileString
local getmetatable            = getmetatable
local setmetatable            = setmetatable
local collectgarbage          = collectgarbage
local osClock                 = os and os.clock
local osDate                  = os and os.date
local bitBand                 = bit and bit.band
local sqlQuery                = sql and sql.Query
local sqlLastError            = sql and sql.LastError
local sqlTableExists          = sql and sql.TableExists
local gameSinglePlayer        = game and game.SinglePlayer
local utilTraceLine           = util and util.TraceLine
local utilIsInWorld           = util and util.IsInWorld
local utilIsValidModel        = util and util.IsValidModel
local utilGetPlayerTrace      = util and util.GetPlayerTrace
local entsCreate              = ents and ents.Create
local fileOpen                = fileOpen
local fileExists              = fileExists
local fileAppend              = fileAppend
local fileDelete              = fileDelete
local fileCreateDir           = fileCreateDir
local mathPi                  = math and math.pi
local mathAbs                 = math and math.abs
local mathSin                 = math and math.sin
local mathCos                 = math and math.cos
local mathCeil                = math and math.ceil
local mathModf                = math and math.modf
local mathSqrt                = math and math.sqrt
local mathFloor               = math and math.floor
local mathClamp               = math and math.Clamp
local mathRandom              = math and math.random
local undoCreate              = undo and undo.Create
local undoFinish              = undo and undo.Finish
local undoAddEntity           = undo and undo.AddEntity
local undoSetPlayer           = undo and undo.SetPlayer
local undoSetCustomUndoText   = undo and undo.SetCustomUndoText
local timerStop               = timer and timer.Stop
local timerStart              = timer and timer.Start
local timerSimple             = timer and timer.Simple
local timerExists             = timer and timer.Exists
local timerCreate             = timer and timer.Create
local timerDestroy            = timer and timer.Destroy
local tableEmpty              = table and table.Empty
local tableMaxn               = table and table.maxn
local tableGetKeys            = table and table.GetKeys
local tableInsert             = table and table.insert
local tableSort               = table and table.sort
local debugGetinfo            = debug and debug.getinfo
local stringUpper             = string and string.Explode
local stringExplode           = string and string.Explode
local stringImplode           = string and string.Implode
local stringToFileName        = string and string.GetFileFromFilename
local renderDrawLine          = render and render.DrawLine
local renderDrawSphere        = render and render.DrawSphere
local renderSetMaterial       = render and render.SetMaterial
local surfaceSetFont          = surface and surface.SetFont
local surfaceDrawLine         = surface and surface.DrawLine
local surfaceDrawText         = surface and surface.DrawText
local surfaceDrawCircle       = surface and surface.DrawCircle
local surfaceSetTexture       = surface and surface.SetTexture
local surfaceSetTextPos       = surface and surface.SetTextPos
local surfaceGetTextSize      = surface and surface.GetTextSize
local surfaceGetTextureID     = surface and surface.GetTextureID
local surfaceSetDrawColor     = surface and surface.SetDrawColor
local surfaceSetTextColor     = surface and surface.SetTextColor
local surfaceDrawTexturedRect = surface and surface.DrawTexturedRect
local languageAdd             = language and language.Add
local constructSetPhysProp    = construct and construct.SetPhysProp
local constraintWeld          = constraint and constraint.Weld
local constraintNoCollide     = constraint and constraint.NoCollide
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
  if(not IsString(sType)) then
    return StatusLog(nil,"GetIndexes: Type {"..type(sType).."}<"..tostring(sType).."> not string") end
  if    (sType == "V") then return cvX, cvY, cvZ
  elseif(sType == "A") then return caP, caY, caR
  elseif(sType == "S") then return csA, csB, csC, csD
  else return StatusLog(nil,"GetIndexes: Type <"..sType.."> not found") end
end

function IsString(anyValue)
  return (getmetatable(anyValue) == GetOpVar("TYPEMT_STRING"))
end

function SetIndexes(sType,...)
  if(not IsString(sType)) then
    return StatusLog(false,"SetIndexes: Type {"..type(sType).."}<"..tostring(sType).."> not string") end
  if    (sType == "V") then cvX, cvY, cvZ      = ...
  elseif(sType == "A") then caP, caY, caR      = ...
  elseif(sType == "S") then csA, csB, csC, csD = ...
  else return StatusLog(false,"SetIndexes: Type <"..sType.."> not found") end
  return StatusLog(true,"SetIndexes["..sType.."]: Success")
end

function GetCache(anyKey)
  if(anyKey) then
    return libCache[anyKey]
  end
  return libCache
end

function GetInstPref()
  if    (CLIENT) then return "cl_"
  elseif(SERVER) then return "sv_" end
  return "na_"
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

function NegVector(vBase, bX, bY, bZ)
  if(not vBase) then return StatusLog(nil,"NegVector: Base invalid") end
  local X = (tonumber(vBase[cvX]) or 0); X = (IsExistent(bX) and (bX and -X or X) or -X)
  local Y = (tonumber(vBase[cvY]) or 0); Y = (IsExistent(bY) and (bY and -Y or Y) or -Y)
  local Z = (tonumber(vBase[cvZ]) or 0); Z = (IsExistent(bZ) and (bZ and -Z or Z) or -Z)
  vBase[cvX], vBase[cvY], vBase[cvZ] = X, Y, Z
end

function NegAngle(vBase, bP, bY, bR)
  if(not vBase) then return StatusLog(nil,"NegVector: Base invalid") end
  local P = (tonumber(vBase[caP]) or 0); P = (IsExistent(bP) and (bP and -P or P) or -P)
  local Y = (tonumber(vBase[caY]) or 0); Y = (IsExistent(bY) and (bY and -Y or Y) or -Y)
  local R = (tonumber(vBase[caR]) or 0); R = (IsExistent(bR) and (bR and -R or R) or -R)
  vBase[caP], vBase[caY], vBase[caR] = P, Y, R
end

function LogInstance(anyValue)
  print(tostring(anyValue))
end

function GetOpVar(sName)
  return libOpVars[sName]
end

function SetOpVar(sName, anyValue)
  libOpVars[sName] = anyValue
end

function GetDate()
  return (osDate(GetOpVar("DATE_FORMAT"))
   .." "..osDate(GetOpVar("TIME_FORMAT")))
end

function gameSinglePlayer() return GetOpVar("GAME_SINGLE") and true or false end
function isClient() return GetOpVar("GAME_CLIENT") and true or false end

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

function DisableString(sBase, vDsb, vDef)
  if(IsString(sBase)) then 
    local sF, sD = sBase:sub(1,1), GetOpVar("OPSYM_DISABLE")
    if(sF ~= sD and not IsEmptyString(sBase)) then
      return sBase -- Not disabled or empty
    elseif(sF == sD) then return vDsb end
  end; return vDef
end

function DefaultString(sBase, sDef)
  if(IsString(sBase)) then
    if(not IsEmptyString(sBase)) then return sBase end end
  if(IsString(sDef)) then return sDef end; return ""
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
  local vS, vT, vK, cK = type(sS), type(tT), tostring(sS or "Data"), ""
  if(vT ~= "table") then
    LogInstance("{"..vT.."}["..vK.."] = <"..tostring(tT)..">"); return end
  LogInstance(vK.." = {}")
  if(next(tT) == nil) then return end
  for k, v in pairs(tT) do
    if(type(k) == "string") then
      cK = vK.."[\""..k.."\"]"
    else cK = vK.."["..tostring(k).."]" end
    if(type(v) ~= "table") then
      if(type(v) == "string") then
        LogInstance(cK.." = \""..v.."\"")
      else LogInstance(cK.." = "..tostring(v)) end
    else Print(v, cK) end
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
  print("LOG ["..tostring(GetOpVar("MODE_DATABASE")).."] >> "..tostring(sError))
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
  if(not (sKey and IsString(sKey))) then
    return StatusLog(nil,"SetAction: Key {"..type(sKey).."}<"..tostring(sKey).."> not string") end
  if(not (fAct and type(fAct) == "function")) then
    return StatusLog(nil,"SetAction: Act {"..type(fAct).."}<"..tostring(fAct).."> not function") end
  if(not libAction[sKey]) then libAction[sKey] = {} end
  libAction[sKey].Act = fAct
  libAction[sKey].Dat = tDat
  return true
end

function GetActionCode(sKey)
  if(not (sKey and IsString(sKey))) then
    return StatusLog(nil,"GetActionCode: Key {"..type(sKey).."}<"..tostring(sKey).."> not string") end
  if(not (libAction and libAction[sKey])) then
    return StatusLog(nil,"GetActionCode: Key not located") end
  return libAction[sKey].Act
end

function GetActionData(sKey)
  if(not (sKey and IsString(sKey))) then
    return StatusLog(nil,"GetActionData: Key {"..type(sKey).."}<"..tostring(sKey).."> not string") end
  if(not (libAction and libAction[sKey])) then
    return StatusLog(nil,"GetActionData: Key not located") end
  return libAction[sKey].Dat
end

function CallAction(sKey,...)
  if(not (sKey and IsString(sKey))) then
    return StatusLog(nil,"CallAction: Key {"..type(sKey).."}<"..tostring(sKey).."> not string") end
  if(not (libAction and libAction[sKey])) then
    return StatusLog(nil,"CallAction: Key not located") end
  return libAction[sKey].Act(libAction[sKey].Dat,...)
end

function IsExistent(anyValue)
  if(anyValue ~= nil) then return true end
  return false
end

local function SQLBuildError(anyError)
  if(not IsExistent(anyError)) then
    return GetOpVar("SQL_BUILD_ERR") or "" end
  SetOpVar("SQL_BUILD_ERR", tostring(anyError))
  return StatusLog(nil, GetOpVar("SQL_BUILD_ERR"))
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

function DefaultType(anyType,fCat)
  if(not IsExistent(anyType)) then
    local sTyp = tostring(GetOpVar("DEFAULT_TYPE") or "")
    local tCat = GetOpVar("TABLE_CATEGORIES")
          tCat = tCat and tCat[sTyp] or nil
    return sTyp, (tCat and tCat.Txt), (tCat and tCat.Cmp)
  end; SettingsModelToName("CLR")
  SetOpVar("DEFAULT_TYPE", tostring(anyType))
  if(isClient()) then
    local sTyp = GetOpVar("DEFAULT_TYPE")
    if(IsString(fCat)) then -- Categories for the panel
      local tCat = GetOpVar("TABLE_CATEGORIES")
      tCat[sTyp] = {}; tCat[sTyp].Txt = fCat
      tCat[sTyp].Cmp = CompileString("return ("..fCat..")", sTyp)
      local suc, out = pcall(tCat[sTyp].Cmp)
      if(not suc) then
        return StatusLog(nil, "DefaultType: Compilation failed <"..fCat.."> ["..sTyp.."]") end
      tCat[sTyp].Cmp = out
    else return StatusLog(nil,"DefaultType: Avoided "..type(fCat).." <"..tostring(fCat).."> ["..sTyp.."]") end
  end
end

function DefaultTable(anyTable)
  if(not IsExistent(anyTable)) then
    return (GetOpVar("DEFAULT_TABLE") or "") end
  SetOpVar("DEFAULT_TABLE",anyTable)
  SettingsModelToName("CLR")
end


function ModelToName(sModel,bNoSettings)
  if(not IsString(sModel)) then
    return StatusLog("","ModelToName: Argument {"..type(sModel).."}<"..tostring(sModel)..">") end
  if(IsEmptyString(sModel)) then return StatusLog("","ModelToName: Empty string") end
  local sSymDiv, sSymDir = GetOpVar("OPSYM_DIVIDER"), GetOpVar("OPSYM_DIRECTORY")
  local sModel = (sModel:sub(1, 1) ~= sSymDir) and (sSymDir..sModel) or sModel
        sModel =  stringToFileName(sModel):gsub(GetOpVar("MODELNAM_FILE"),"")
  local gModel =  sModel:sub(1,-1) -- Create a copy so we can select cut-off parts later on
  if(not bNoSettings) then
    local tCut, Cnt, tSub, tApp = SettingsModelToName("GET"), 1
    if(tCut and tCut[1]) then
      while(tCut[Cnt] and tCut[Cnt+1]) do
        local fCh = tonumber(tCut[Cnt])
        local bCh = tonumber(tCut[Cnt+1])
        if(not (IsExistent(fCh) and IsExistent(bCh))) then
          return StatusLog("","ModelToName: Cannot cut the model in {"
                   ..tostring(tCut[Cnt])..","..tostring(tCut[Cnt+1]).."} for "..sModel)
        end
        LogInstance("ModelToName[CUT]: {"..tostring(tCut[Cnt])..", "..tostring(tCut[Cnt+1]).."} << "..gModel)
        gModel = gModel:gsub(sModel:sub(fCh,bCh),"")
        LogInstance("ModelToName[CUT]: {"..tostring(tCut[Cnt])..", "..tostring(tCut[Cnt+1]).."} >> "..gModel)
        Cnt = Cnt + 2
      end
      Cnt = 1
    end
    -- Replace the unneeded parts by finding an in-string gModel
    if(tSub and tSub[1]) then
      while(tSub[Cnt]) do
        local fCh = tostring(tSub[Cnt]   or "")
        local bCh = tostring(tSub[Cnt+1] or "")
        LogInstance("ModelToName[SUB]: {"..tostring(tSub[Cnt])..", "..tostring(tSub[Cnt+1]).."} << "..gModel)
        gModel = gModel:gsub(fCh,bCh)
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
  if(gModel:sub(1,1) ~= sSymDiv) then gModel = sSymDiv..gModel end
  -- Here in gModel we have: _aaaaa_bbbb_ccccc
  return gModel:gsub("_%w",GetOpVar("MODELNAM_FUNC")):sub(2,-1)
end

function StringDisable(sBase, anyDisable, anyDefault)
  if(IsString(sBase)) then
    if(sBase:len() > 0 and sBase:sub(1,1) ~= GetOpVar("OPSYM_DISABLE")
    ) then
      return sBase
    elseif(sBase:sub(1,1) == GetOpVar("OPSYM_DISABLE")) then
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

local function IsZeroPOA(stPOA,sOffs)
  if(not IsString(sOffs)) then
    return StatusLog(nil,"IsZeroPOA: Mode {"..type(sOffs).."}<"..tostring(sOffs).."> not string") end
  if(not IsExistent(stPOA)) then
    return StatusLog(nil,"IsZeroPOA: Missing offset") end
  local ctA, ctB, ctC
  if    (sOffs == "V") then ctA, ctB, ctC = cvX, cvY, cvZ
  elseif(sOffs == "A") then ctA, ctB, ctC = caP, caY, caR
  else return StatusLog(nil,"IsZeroPOA: Missed offset mode "..sOffs) end
  if(stPOA[ctA] == 0 and stPOA[ctB] == 0 and stPOA[ctC] == 0) then return true end
  return false
end

local function IsEqualPOA(stOffsetA,stOffsetB)
  if(not IsExistent(stOffsetA)) then return StatusLog(nil,"EqualPOA: Missing OffsetA") end
  if(not IsExistent(stOffsetB)) then return StatusLog(nil,"EqualPOA: Missing OffsetB") end
  for Ind, Comp in pairs(stOffsetA) do
    if(Ind ~= csD and stOffsetB[Ind] ~= Comp) then return false end
  end
  return true
end

local function StringPOA(stPOA,sOffs)
  if(not IsString(sOffs)) then
    return StatusLog(nil,"StringPOA: Mode {"..type(sOffs).."}<"..tostring(sOffs).."> not string") end
  if(not IsExistent(stPOA)) then
    return StatusLog(nil,"StringPOA: Missing Offsets") end
  local symRevs = GetOpVar("OPSYM_REVSIGN")
  local symDisa = GetOpVar("OPSYM_DISABLE")
  local symSepa = GetOpVar("OPSYM_SEPARATOR")
  local sModeDB = GetOpVar("MODE_DATABASE")
  if    (sOffs == "V") then ctA, ctB, ctC = cvX, cvY, cvZ
  elseif(sOffs == "A") then ctA, ctB, ctC = caP, caY, caR
  else return StatusLog(nil,"StringPOA: Missed offset mode "..sOffs) end
  return stringGsub((stPOA[csD] and symDisa or "")  -- Get rid of the spaces
                 ..((stPOA[csA] == -1) and symRevs or "")..tostring(stPOA[ctA])..symSepa
                 ..((stPOA[csB] == -1) and symRevs or "")..tostring(stPOA[ctB])..symSepa
                 ..((stPOA[csC] == -1) and symRevs or "")..tostring(stPOA[ctC])," ","")
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
  local Chr = stringSub(sStr,Cnt,Cnt)
  while(Chr ~= "") do
    Out = Out..Chr
    if(Chr == "'") then
      Out = Out..Chr
    end
    Cnt = Cnt + 1
    Chr = stringSub(sStr,Cnt,Cnt)
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

local mtPanel = {}
      mtPanel.__type = "panel"
function MakePanel(sName)
  self = {Name = "", Node = {}}
  function self:AddNode(sName)
    local nam = tostring(sName or "n/a")
    self.Node[nam] = MakePanel(nam)
    return self.Node[nam]:SetName(nam)
  end
  function self:SetName(sName)
    self.Name = tostring(sName or "n/a"); return self
  end
  function self:GetName(sName) return self.Name end
  setmetatable(self, mtPanel); return self
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

function InitBase(sName,sPurpose)
  SetOpVar("TYPEMT_STRING",getmetatable("TYPEMT_STRING"))
  SetOpVar("TYPEMT_SCREEN",{})
  SetOpVar("TYPEMT_CONTAINER",{})
  if(not IsString(sName)) then
    return StatusPrint(false,"InitBase: Name <"..tostring(sName).."> not string") end
  if(not IsString(sPurpose)) then
    return StatusPrint(false,"InitBase: Purpose <"..tostring(sPurpose).."> not string") end
  if(IsEmptyString(sName) or tonumber(sName:sub(1,1))) then
    return StatusPrint(false,"InitBase: Name invalid <"..sName..">") end
  if(IsEmptyString(sPurpose) or tonumber(sPurpose:sub(1,1))) then
    return StatusPrint(false,"InitBase: Purpose invalid <"..sPurpose..">") end
  SetOpVar("TIME_INIT",Time())
  SetOpVar("LOG_MAXLOGS",0)
  SetOpVar("LOG_CURLOGS",0)
  SetOpVar("LOG_SKIP",{})
  SetOpVar("LOG_ONLY",{})
  SetOpVar("LOG_LOGFILE","")
  SetOpVar("LOG_LOGLAST","")
  SetOpVar("MAX_ROTATION",360)
  SetOpVar("DELAY_FREEZE",0.01)
  SetOpVar("ANG_ZERO",Angle())
  SetOpVar("VEC_ZERO",Vector())
  SetOpVar("VEC_FW",Vector(1,0,0))
  SetOpVar("VEC_RG",Vector(0,-1,1))
  SetOpVar("VEC_UP",Vector(0,0,1))
  SetOpVar("OPSYM_DISABLE","#")
  SetOpVar("OPSYM_REVSIGN","@")
  SetOpVar("OPSYM_DIVIDER","_")
  SetOpVar("OPSYM_DIRECTORY","/")
  SetOpVar("OPSYM_SEPARATOR",",")
  SetOpVar("EPSILON_ZERO", 1e-5)
  SetOpVar("COLOR_CLAMP", {0, 255})
  SetOpVar("GOLDEN_RATIO",1.61803398875)
  SetOpVar("DATE_FORMAT","%d-%m-%y")
  SetOpVar("TIME_FORMAT","%H:%M:%S")
  SetOpVar("NAME_INIT",sName:lower())
  SetOpVar("NAME_PERP",sPurpose:lower())
  SetOpVar("NAME_LIBRARY", GetOpVar("NAME_INIT").."asmlib")
  SetOpVar("TOOLNAME_NL",(GetOpVar("NAME_INIT")..GetOpVar("NAME_PERP")):lower())
  SetOpVar("TOOLNAME_NU",(GetOpVar("NAME_INIT")..GetOpVar("NAME_PERP")):upper())
  SetOpVar("TOOLNAME_PL",GetOpVar("TOOLNAME_NL").."_")
  SetOpVar("TOOLNAME_PU",GetOpVar("TOOLNAME_NU").."_")
  SetOpVar("DIRPATH_BAS",GetOpVar("TOOLNAME_NL")..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_INS","exp"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_DSV","dsv"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("MISS_NOID","N")    -- No ID selected
  SetOpVar("MISS_NOAV","N/A")  -- Not Available
  SetOpVar("MISS_NOMD","X")    -- No model
  SetOpVar("ARRAY_DECODEPOA",{0,0,0,1,1,1,false})
  if(CLIENT) then
    SetOpVar("LOCALIFY_AUTO","en")
    SetOpVar("LOCALIFY_TABLE",{})
    SetOpVar("TABLE_CATEGORIES",{})
    SetOpVar("STRUCT_SPAWN",{
      {"--- Origin ---"},
      {"F"     ,"VEC", "Forward direction"},
      {"R"     ,"VEC", "Right direction"},
      {"U"     ,"VEC", "Up direction"},
      {"OPos"  ,"VEC", "Origin position"},
      {"OAng"  ,"ANG", "Origin angles"},
      {"SPos"  ,"VEC", "Spawn position"},
      {"SAng"  ,"ANG", "Spawn angles"},
      {"RLen"  ,"FLT", "Active radius"},
      {"--- Holder ---"},
      {"HID"   ,"INT", "Point ID"},
      {"HPnt"  ,"VEC", "Search location"},
      {"HOrg"  ,"VEC", "Custom offset"},
      {"HAng"  ,"ANG", "Custom angles"},
      {"--- Traced ---"},
      {"TID"   ,"INT", "Point ID"},
      {"TPnt"  ,"VEC", "Search location"},
      {"TOrg"  ,"VEC", "Custom offset"},
      {"TAng"  ,"ANG", "Custom angles"},
      {"--- Offset ---"},
      {"PNxt"  ,"VEC", "Custom user position"},
      {"ANxt"  ,"VEC", "Custom user angles"}})
  end
  SetOpVar("MODELNAM_FILE","%.mdl")
  SetOpVar("MODELNAM_FUNC",function(x) return " "..x:sub(2,2):upper() end)
  SetOpVar("QUERY_STORE", {})
  SetOpVar("TABLE_BORDERS",{})
  SetOpVar("TABLE_FREQUENT_MODELS",{})
  SetOpVar("OOP_DEFAULTKEY","(!@<#_$|%^|&>*)DEFKEY(*>&|^%|$_#<@!)")
  SetOpVar("CVAR_LIMITNAME","asm"..GetOpVar("NAME_INIT").."s")
  SetOpVar("MODE_DATABASE",GetOpVar("MISS_NOAV"))
  SetOpVar("MODE_WORKING", {"SNAP", "CROSS"})
  SetOpVar("HASH_USER_PANEL",GetOpVar("TOOLNAME_PU").."USER_PANEL")
  SetOpVar("HASH_PROPERTY_NAMES","PROPERTY_NAMES")
  SetOpVar("HASH_PROPERTY_TYPES","PROPERTY_TYPES")
  SetOpVar("TRACE_CLASS", {["prop_physics"]=true})
  SetOpVar("TRACE_DATA",{ -- Used for general trace result storage
    start  = Vector(),    -- Start position of the trace
    endpos = Vector(),    -- End position of the trace
    mask   = MASK_SOLID,  -- Mask telling it what to hit
    filter = function(oEnt) -- Only valid props which are not the main entity or world or TRACE_FILTER ( if set )
      if(oEnt and oEnt:IsValid() and oEnt ~= GetOpVar("TRACE_FILTER") and
        GetOpVar("TRACE_CLASS")[oEnt:GetClass()]) then return true end end })
  SetOpVar("RAY_INTERSECT",{}) -- General structure for handling rail crosses and curves
  SetOpVar("NAV_PIECE",{})
  SetOpVar("NAV_PANEL",{})
  SetOpVar("NAV_ADDITION",{})
  SetOpVar("NAV_PROPERTY_NAMES",{})
  SetOpVar("NAV_PROPERTY_TYPES",{})
  return StatusPrint(true,"InitBase: Success")
end

--SQL---------------------------------

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

local function MatchType(defTable,snValue,ivIndex,bQuoted,sQuote,bStopRevise,bStopEmpty)
  if(not defTable) then
    return StatusLog(nil,"MatchType: Missing table definition") end
  local nIndex = tonumber(ivIndex)
  if(not IsExistent(nIndex)) then
    return StatusLog(nil,"MatchType: Field NAN {"..type(ivIndex)"}<"
             ..tostring(ivIndex).."> invalid on table "..defTable.Name) end
  local defField = defTable[nIndex]
  if(not IsExistent(defField)) then
    return StatusLog(nil,"MatchType: Invalid field #"
             ..tostring(nIndex).." on table "..defTable.Name) end
  local snOut
  local tipField = tostring(defField[2])
  local sModeDB  = GetOpVar("MODE_DATABASE")
  if(tipField == "TEXT") then
    snOut = tostring(snValue)
    if(not bStopEmpty and (snOut == "nil" or IsEmptyString(snOut))) then
      if    (sModeDB == "SQL") then snOut = "NULL"
      elseif(sModeDB == "LUA") then snOut = "NULL"
      else return StatusLog(nil,"MatchType: Wrong database mode <"..sModeDB..">") end
    end
    if    (defField[3] == "LOW") then snOut = snOut:lower()
    elseif(defField[3] == "CAP") then snOut = snOut:upper() end
    if(not bStopRevise and sModeDB == "SQL" and defField[4] == "QMK") then
      snOut = snOut:gsub("'","''")
    end
    if(bQuoted) then
      local sqChar
      if(sQuote) then
        sqChar = tostring(sQuote):sub(1,1)
      else
        if    (sModeDB == "SQL") then sqChar = "'"
        elseif(sModeDB == "LUA") then sqChar = "\"" end
      end
      snOut = sqChar..snOut..sqChar
    end
  elseif(tipField == "REAL" or tipField == "INTEGER") then
    snOut = tonumber(snValue)
    if(IsExistent(snOut)) then
      if(tipField == "INTEGER") then
        if(defField[3] == "FLR") then
          snOut = mathFloor(snOut)
        elseif(defField[3] == "CEL") then
          snOut = mathCeil(snOut)
        end
      end
    else
      return StatusLog(nil,"MatchType: Failed converting {"
               ..type(snValue).."}<"..tostring(snValue).."> to NUMBER for table "
               ..defTable.Name.." field #"..nIndex)
    end
  else
    return StatusLog(nil,"MatchType: Invalid field type <"
      ..tipField.."> on table "..defTable.Name) end
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
    Command.Create = Command.Create..stringUpper(v[1]).." "..stringUpper(v[2])
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
        FieldsU = FieldsU.."_" ..stringUpper(defTable[vF][1])
        FieldsC = FieldsC..stringUpper(defTable[vF][1])
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

function SQLStoreSelect(sHash,sQuery)
  if(not sHash) then
    return StatusLog(nil, "SQLStoreSelect: Store hash missing") end
  if(not sQuery) then
    return StatusLog(nil, "SQLStoreSelect: Store query missing") end
  local tStore, sB, sQ, sV = GetOpVar("QUERY_STORE"), " = ", ""
  if(not tStore[sHash]) then tStore[sHash] = {Cnt = 0, Stmt = ""} end tStore = tStore[sHash]
  local tBoom = stringExplode(sB, sQuery); tStore.Stmt = tBoom[1]
  for ID = 2, #tBoom do tStore.Cnt = tStore.Cnt + 1
    local sV = tBoom[ID]
    local nS = stringFind(sV,"%s")
    local sC = stringSub(sV,1,1)
    if(sC == "'") then
      if(stringSub(sV,nS-1,nS-1) ~= "'") then
        return StatusLog(nil, "SQLStoreSelect: Value quote mismatch ["..ID.."]<"..sV..">") end
      tStore.Stmt = tStore.Stmt..sB..sC.."%s"..stringSub(sV,nS-1,-1)
    else
      if(not nS) then
        return StatusLog(nil, "SQLStoreSelect: Value space mismatch ["..ID.."]<"..sV..">") end
      tStore.Stmt = tStore.Stmt..sB.."%d"..stringSub(sV,nS,-1)
    end
  end; return tStore
end

function SQLFetchSelect(sHash,...)
  local tStore, nCnt = GetOpVar("QUERY_STORE"), #{...}
  if(not tStore[sHash]) then
    return StatusLog(nil, "SQLFetchSelect: Storage missing for <"..sHash..">") end
  tStore = tStore[sHash]
  if(tStore.Cnt ~= nCnt) then
    return StatusLog(nil, "SQLFetchSelect: Fetched <"..sHash.."> with #"
      ..tostring(nCnt).." requires #"..tostring(tStore.Cnt)) end
  return stringFormat(tStore.Stmt,...)
end

function SQLCacheStmt(sHash,sStmt,...)
  if(not IsExistent(sHash)) then
    return StatusLog(nil, "SQLCacheStmt: Store hash missing") end
  local sHash, tStore = tostring(sHash), GetOpVar("QUERY_STORE")
  if(not IsExistent(tStore)) then
    return StatusLog(nil, "SQLCacheStmt: Store place missing") end
  if(IsExistent(sStmt)) then
    tStore[sHash] = tostring(sStmt); Print(tStore,"SQLCacheStmt: stmt") end
  local sStmt = tStore[sHash]
  if(not sStmt) then return StatusLog(nil, "SQLCacheStmt: Store stmt <"..sHash.."> missing") end
  return sStmt:format(...)
end

function SQLBuildSelect(defTable,tFields,tWhere,tOrderBy)
  if(not defTable) then
    return StatusLog(nil, "SQLBuildSelect: Missing table definition") end
  if(not (defTable[1][1] and defTable[1][2])) then
    return StatusLog(nil, "SQLBuildSelect: Missing table "..defTable.Name.." field definitions") end
  local Command, Cnt = "SELECT ", 1
  if(tFields) then
    while(tFields[Cnt]) do
      local v = tonumber(tFields[Cnt])
      if(not IsExistent(v)) then
        return StatusLog(nil, "SQLBuildSelect: Index NAN {"
             ..type(tFields[Cnt]).."}<"..tostring(tFields[Cnt])
             .."> type mismatch in "..defTable.Name) end
      if(not defTable[v]) then
        return StatusLog(nil, "SQLBuildSelect: Missing field by index #"
          ..v.." in the table "..defTable.Name) end
      if(defTable[v][1]) then Command = Command..defTable[v][1]
      else return StatusLog(nil, "SQLBuildSelect: Mising field name by index #"
        ..v.." in the table "..defTable.Name) end
      if(tFields[Cnt+1]) then Command = Command ..", " end
      Cnt = Cnt + 1
    end
  else Command = Command.."*" end
  Command = Command .." FROM "..defTable.Name
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
      local k = tonumber(tWhere[Cnt][1])
      local v = tWhere[Cnt][2]
      local t = defTable[k][2]
      if(not (k and v and t) ) then
        return StatusLog(nil, "SQLBuildSelect: Where clause inconsistent on "
          ..defTable.Name.." field index, {"..tostring(k)..","..tostring(v)..","..tostring(t)
          .."} value or type in the table definition") end
      if(not IsExistent(v)) then
        return StatusLog(nil, "SQLBuildSelect: Data matching failed on "
          ..defTable.Name.." field index #"..Cnt.." value <"..tostring(v)..">") end
      if(Cnt == 1) then Command = Command.." WHERE "..defTable[k][1].." = "..tostring(v)
      else              Command = Command.." AND "  ..defTable[k][1].." = "..tostring(v) end
      Cnt = Cnt + 1
    end
  end
  if(tOrderBy and (type(tOrderBy) == "table")) then
    local Dire = ""
    Command, Cnt = Command.." ORDER BY ", 1
    while(tOrderBy[Cnt]) do
      local v = tOrderBy[Cnt]
      if(v ~= 0) then
        if(v > 0) then Dire = " ASC"
        else Dire, tOrderBy[Cnt] = " DESC", -v end
      else return StatusLog(nil, "SQLBuildSelect: Order wrong for "
        ..defTable.Name .." field index #"..Cnt) end
      Command = Command..defTable[v][1]..Dire
      if(tOrderBy[Cnt+1]) then Command = Command..", " end
      Cnt = Cnt + 1
    end
  end; return Command..";"
end

function SQLBuildInsert(defTable,tInsert,tValues)
  if(not defTable) then
    return StatusLog(nil, "SQLBuildInsert: Missing Table definition") end
  if(not tValues) then
    return StatusLog(nil, "SQLBuildInsert: Missing Table value fields") end
  if(not defTable[1]) then
    return StatusLog(nil, "SQLBuildInsert: The table and the chosen fields must not be empty") end
  if(not (defTable[1][1] and defTable[1][2])) then
    return StatusLog(nil, "SQLBuildInsert: Missing table "..defTable.Name.." field definition") end
  local tInsert = tInsert or {}
  if(not tInsert[1]) then
    local iCnt = 1
    while(defTable[iCnt]) do
      tInsert[iCnt] = iCnt; iCnt = iCnt + 1 end
  end
  local iCnt, qVal = 1, " VALUES ( "
  local qIns = "INSERT INTO "..defTable.Name.." ( "
  while(tInsert[iCnt]) do
    local iIns = tInsert[iCnt]; local sIns = defTable[iIns]
    if(not IsExistent(sIns)) then
      return StatusLog(nil, "SQLBuildInsert: No such field #"..iIns.." on table "..defTable.Name) end
    local vVal = MatchType(defTable,tValues[iCnt],iIns,true)
    if(not IsExistent(vVal)) then
      return StatusLog(nil, "SQLBuildInsert: Cannot match value <"..tostring(tValues[iCnt]).."> #"..iInd.." on table "..defTable.Name) end
    qIns, qVal = qIns..sIns[1], qVal..tostring(vVal)
    if(tInsert[iCnt+1]) then qIns, qVal = qIns ..", " , qVal ..", "
    else qIns, qVal = qIns .." ) ", qVal .." );" end; iCnt = iCnt + 1
  end; return qIns..qVal
end


function CreateTable(sTable,defTable,bDelete,bReload)
  if(not IsString(sTable)) then
    return StatusLog(false,"CreateTable: Table key {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  if(not (type(defTable) == "table")) then
    return StatusLog(false,"CreateTable: Table definition missing for "..sTable) end
  if(#defTable <= 0) then
    return StatusLog(false,"CreateTable: Record definition missing for "..sTable) end
  if(#defTable ~= tableMaxn(defTable)) then
    return StatusLog(false,"CreateTable: Record definition mismatch for "..sTable) end
  local sTable  = sTable:upper()
  local sModeDB = GetOpVar("MODE_DATABASE")
  local symDis  = GetOpVar("OPSYM_DISABLE")
  local iCnt, defField = 1, nil
  SetOpVar("DEFTABLE_"..sTable,defTable)
  defTable.Size = #defTable
  defTable.Name = GetOpVar("TOOLNAME_PU")..sTable
  while(defTable[iCnt]) do
    defField    = defTable[iCnt]
    defField[3] = DefaultString(tostring(defField[3] or symDis), symDis)
    defField[4] = DefaultString(tostring(defField[4] or symDis), symDis)
    iCnt = iCnt + 1
  end; libCache[defTable.Name] = {}
  if(sModeDB == "SQL") then
    local tQ = SQLBuildCreate(defTable)
    if(not IsExistent(tQ)) then return StatusLog(false,"CreateTable: Build statement failed") end
    if(bDelete and sqlTableExists(defTable.Name)) then
      local qRez = sqlQuery(tQ.Delete)
      if(not qRez and IsBool(qRez)) then
        LogInstance("CreateTable: Table "..sTable.." is not present. Skipping delete !")
      else
        LogInstance("CreateTable: Table "..sTable.." deleted !")
      end
    end
    if(bReload) then
      local qRez = sqlQuery(tQ.Drop)
      if(not qRez and IsBool(qRez)) then
        LogInstance("CreateTable: Table "..sTable.." is not present. Skipping drop !")
      else
        LogInstance("CreateTable: Table "..sTable.." dropped !")
      end
    end
    if(sqlTableExists(defTable.Name)) then
      return StatusLog(true,"CreateTable: Table "..sTable.." exists!")
    else
      local qRez = sqlQuery(tQ.Create)
      if(not qRez and IsBool(qRez)) then
        return StatusLog(false,"CreateTable: Table "..sTable
          .." failed to create because of "..sqlLastError()) end
      if(sqlTableExists(defTable.Name)) then
        for k, v in pairs(tQ.Index) do
          qRez = sqlQuery(v)
          if(not qRez and IsBool(qRez)) then
            return StatusLog(false,"CreateTable: Table "..sTable..
              " failed to create index ["..k.."] > "..v .." > because of "..sqlLastError()) end
        end return StatusLog(true,"CreateTable: Indexed Table "..sTable.." created !")
      else
        return StatusLog(false,"CreateTable: Table "..sTable..
          " failed to create because of "..sqlLastError().." Query ran > "..tQ.Create) end
    end; LogInstance("CreateTable: Created "..defTable.Name)
  elseif(sModeDB == "LUA") then
    LogInstance("CreateTable: Created "..defTable.Name)
  else return StatusLog(false,"CreateTable: Wrong database mode <"..sModeDB..">") end
end

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

local function TransferPOA(stOffset,sMode)
  if(not IsExistent(stOffset)) then
    return StatusLog(nil,"TransferPOA: Destination needed") end
  if(not IsString(sMode)) then
    return StatusLog(nil,"TransferPOA: Mode {"..type(sMode).."}<"..tostring(sMode).."> not string") end
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
  if    (sMode == "V") then stOffset[cvX] = arPOA[1]; stOffset[cvY] = arPOA[2]; stOffset[cvZ] = arPOA[3]
  elseif(sMode == "A") then stOffset[caP] = arPOA[1]; stOffset[caY] = arPOA[2]; stOffset[caR] = arPOA[3]
  else return StatusLog(nil,"TransferPOA: Missed mode "..sMode) end
  stOffset[csA] = arPOA[4]; stOffset[csB] = arPOA[5]; stOffset[csC] = arPOA[6]; stOffset[csD] = arPOA[7]
  return arPOA
end

function DecodePOA(sStr)
  if(not IsString(sStr)) then return nil end
   -- return StatusLog(nil,"DecodePOA: Argument {"..type(sStr).."}<"..tostring(sStr).."> not string") end
  local strLen = sStr:len(); if(strLen == 0) then return ReloadPOA() end; ReloadPOA()
  local symOff, symRev = GetOpVar("OPSYM_DISABLE"), GetOpVar("OPSYM_REVSIGN")
  local symSep, arPOA = GetOpVar("OPSYM_SEPARATOR"), GetOpVar("ARRAY_DECODEPOA")
  local S, E, iCnt, dInd, iSep, sCh = 1, 1, 1, 1, 0, ""
  if(sStr:sub(iCnt,iCnt) == symOff) then
    arPOA[7] = true; iCnt = iCnt + 1; S = S + 1 end
  while(iCnt <= strLen) do sCh = sStr:sub(iCnt,iCnt)
    if(sCh == symRev) then arPOA[3+dInd] = -arPOA[3+dInd]; S = S + 1
    elseif(sCh == symSep) then iSep = iSep + 1; E = iCnt - 1
      if(iSep > 2) then break end
      arPOA[dInd] = (tonumber(sStr:sub(S,E)) or 0)
      dInd = dInd + 1; S = iCnt + 1; E = S
    else E = E + 1 end; iCnt = iCnt + 1
  end; arPOA[dInd] = (tonumber(sStr:sub(S,E)) or 0); return arPOA
end

function NewDecodePOA(sStr)
  if(not IsString(sStr)) then return nil end
  --  return StatusLog(nil,"DecodePOA: Argument {"..type(sStr).."}<"..tostring(sStr).."> not string") end
  local strLen, symRev = sStr:len(), GetOpVar("OPSYM_REVSIGN"); ReloadPOA()
  local symOff, arPOA = GetOpVar("OPSYM_DISABLE"), GetOpVar("ARRAY_DECODEPOA")
  local tP = GetOpVar("OPSYM_SEPARATOR"):Explode(sStr)
  if(tP[1]:sub(1, 1) == GetOpVar("OPSYM_DISABLE")) then
    arPOA[7], tP[1] = true, tP[1]:sub(2, -1) end
  for iP = 1, #tP do local vP = tP[iP]
    if(vP:sub(1,1) == symRev) then
      arPOA[iP+3], tP[iP] = -arPOA[iP+3], vP:sub(2, -1); vP = tP[iP]
    end; arPOA[iP] = (tonumber(vP) or 0)
  end; return arPOA
end

function ComDecodePOA(sStr)
  if(not IsString(sStr)) then return nil end
   -- return StatusLog(nil,"DecodePOA: Argument {"..type(sStr).."}<"..tostring(sStr).."> not string") end
  local iL = sStr:len(); if(iL == 0) then return ReloadPOA() end; ReloadPOA()
  local symOff, symRev = GetOpVar("OPSYM_DISABLE"), GetOpVar("OPSYM_REVSIGN")
  local symSep, arPOA = GetOpVar("OPSYM_SEPARATOR"), GetOpVar("ARRAY_DECODEPOA")
  local S, E, iC, iD, iS, sCh = 1, 1, 1, 1, 0, ""
  if(sStr:sub(iC,iC) == symOff) then
    arPOA[7] = true; iC = iC + 1; S = S + 1 end
  while(iC <= iL) do sCh = sStr:sub(iC,iC)
    if(sCh == symRev) then arPOA[3+iD] = -arPOA[3+iD]; S = S + 1
    elseif(sCh == symSep) then iS, E = (iS+1), (iC-1)
      if(iS > 2) then break end
      arPOA[iD] = (tonumber(sStr:sub(S,E)) or 0)
      iD, S = (iD+1), (iC+1); E = S
    else E = (E+1) end; iC = (iC+1)
  end; arPOA[iD] = (tonumber(sStr:sub(S,E)) or 0); return arPOA
end

local function RegisterPOA(stPiece, ivID, sP, sO, sA)
  if(not stPiece) then
    return StatusLog(nil,"RegisterPOA: Cache record invalid") end
  local iID = tonumber(ivID)
  if(not IsExistent(iID)) then
    return StatusLog(nil,"RegisterPOA: OffsetID NAN {"..type(ivID).."}<"..tostring(ivID)..">") end
  local sP = sP or "NULL"
  local sO = sO or "NULL"
  local sA = sA or "NULL"
  if(not IsString(sP)) then
    return StatusLog(nil,"RegisterPOA: Point  {"..type(sP).."}<"..tostring(sP)..">") end
  if(not IsString(sO)) then
    return StatusLog(nil,"RegisterPOA: Origin {"..type(sO).."}<"..tostring(sO)..">") end
  if(not IsString(sA)) then
    return StatusLog(nil,"RegisterPOA: Angle  {"..type(sA).."}<"..tostring(sA)..">") end
  if(not stPiece.Offs) then
    if(iID > 1) then return StatusLog(nil,"RegisterPOA: First ID cannot be #"..tostring(iID)) end
    stPiece.Offs = {}
  end
  local tOffs = stPiece.Offs
  if(tOffs[iID]) then
    return StatusLog(nil,"RegisterPOA: Exists ID #"..tostring(iID))
  else
    if((iID > 1) and (not tOffs[iID - 1])) then
      return StatusLog(nil,"RegisterPOA: No sequential ID #"..tostring(iID - 1))
    end
    tOffs[iID]   = {}
    tOffs[iID].P = {}
    tOffs[iID].O = {}
    tOffs[iID].A = {}
    tOffs        = tOffs[iID]
  end
  ---------------- Origin ----------------
  if((sO ~= "NULL") and not IsEmptyString(sO)) then DecodePOA(sO) else ReloadPOA() end
  if(not IsExistent(TransferPOA(tOffs.O,"V"))) then
    return StatusLog(nil,"RegisterPOA: Cannot transfer origin") end
  ---------------- Point ----------------
  local sD = sP:gsub(GetOpVar("OPSYM_DISABLE"),"")
  if((sP ~= "NULL") and not IsEmptyString(sP)) then DecodePOA(sP) else ReloadPOA() end
  if(not IsExistent(TransferPOA(tOffs.P,"V"))) then
    return StatusLog(nil,"RegisterPOA: Cannot transfer point") end
  if((sD == "NULL") or IsEmptyString(sD)) then -- If empty use origin
    tOffs.P[cvX] = tOffs.O[cvX]; tOffs.P[cvY] = tOffs.O[cvY]; tOffs.P[cvZ] = tOffs.O[cvZ];
    tOffs.P[csA] = tOffs.O[csA]; tOffs.P[csB] = tOffs.O[csB]; tOffs.P[csC] = tOffs.O[csC];
  end
  ---------------- Angle ----------------
  if((sA ~= "NULL") and not IsEmptyString(sA)) then DecodePOA(sA) else ReloadPOA() end
  if(not IsExistent(TransferPOA(tOffs.A,"A"))) then
    return StatusLog(nil,"RegisterPOA: Cannot transfer angle") end
  return tOffs
end

function oldSort(tTable,tKeys,tFields,sMethod)
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

function Sort(tTable,tKeys,tFields)
  local function QuickSort(Data,Lo,Hi)
    if(not (Lo and Hi and (Lo > 0) and (Lo < Hi))) then
      return StatusLog(nil,"QuickSort: Data dimensions mismatch") end
    local iMid = mathRandom(Hi-(Lo-1))+Lo-1
    Data[Lo], Data[iMid] = Data[iMid], Data[Lo]
    iMid = Lo
    local vMid = Data[Lo].Val
    local iCnt = Lo + 1
    while(iCnt <= Hi)do
      if(Data[iCnt].Val < vMid) then
        iMid = iMid + 1
        Data[iMid], Data[iCnt] = Data[iCnt], Data[iMid]
      end
      iCnt = iCnt + 1
    end
    Data[Lo], Data[iMid] = Data[iMid], Data[Lo]
    QuickSort(Data,Lo,iMid-1)
    QuickSort(Data,iMid+1,Hi)
  end

  local Match = {}
  local tKeys = tKeys or {}
  local tFields = tFields or {}
  local iCnt, iInd, sKey, vRec, sFld = 1, nil, nil, nil, nil
  if(not tKeys[1]) then
    for k,v in pairs(tTable) do
      tKeys[iCnt] = k; iCnt = iCnt + 1
    end; iCnt = 1
  end
  while(tKeys[iCnt]) do
    sKey = tKeys[iCnt]; vRec = tTable[sKey]
    if(not vRec) then
      return StatusLog(nil,"Sort: Key <"..sKey.."> does not exist in the primary table") end
    Match[iCnt] = {}
    Match[iCnt].Key = sKey
    if(type(vRec) == "table") then
      Match[iCnt].Val, iInd = "", 1
      while(tFields[iInd]) do
        sFld = tFields[iInd]
        if(not IsExistent(vRec[sFld])) then
          return StatusLog(nil,"Sort: Field <"..sFld.."> not found on the current record") end
        Match[iCnt].Val = Match[iCnt].Val..tostring(vRec[sFld])
        iInd = iInd + 1
      end
    else Match[iCnt].Val = vRec end
    iCnt = iCnt + 1
  end; QuickSort(Match,1,iCnt-1)
  return Match
end

function InsertRecord(sTable,arLine)
  if(not IsExistent(sTable)) then
    return StatusLog(false,"InsertRecord: Missing table name/values") end
  if(type(sTable) == "table") then
    arLine, sTable = sTable, DefaultTable()
    if(not (IsExistent(sTable) and sTable ~= "")) then
      return StatusLog(false,"InsertRecord: Missing table default name") end
  end
  if(not IsString(sTable)) then
    return StatusLog(false,"InsertRecord: Table name {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable); if(not defTable) then
    return StatusLog(false,"InsertRecord: Missing table definition for "..sTable) end
  if(not defTable[1]) then
    return StatusLog(false,"InsertRecord: Missing table definition is empty for "..sTable) end
  if(not arLine) then
    return StatusLog(false,"InsertRecord: Missing data table for "..sTable) end
  if(not arLine[1])   then
    for key, val in pairs(arLine) do
      LogInstance("PK data ["..tostring(key).."] = <"..tostring(val)..">") end
    return StatusLog(false,"InsertRecord: Missing PK for "..sTable)
  end

  if(sTable == "PIECES") then
    local trClass = GetOpVar("TRACE_CLASS")
    arLine[2] = DisableString(arLine[2],DefaultType(),"TYPE")
    arLine[3] = DisableString(arLine[3],ModelToName(arLine[1]),"MODEL")
    arLine[8] = DisableString(arLine[8],"NULL","NULL")
    if(not((arLine[8] == "NULL") or trClass[arLine[8]] or IsEmptyString(arLine[8]))) then
      trClass[arLine[8]] = true -- Register the class provided
      LogInstance("InsertRecord: Register trace <"..tostring(arLine[8]).."@"..arLine[1]..">")
    end -- Add the special class to the trace list
  elseif(sTable == "PHYSPROPERTIES") then
    arLine[1] = DisableString(arLine[1],DefaultType(),"TYPE")
  end

  local sModeDB = GetOpVar("MODE_DATABASE")
  if(sModeDB == "SQL") then local Q
    for iID = 1, defTable.Size, 1 do
      arLine[iID] = MatchType(defTable,arLine[iID],iID,true) end
    if(sTable == "PIECES") then
      Q = SQLCacheStmt("stmtInsertPieces", nil, unpack(arLine))
      if(not Q) then
        local sStmt = SQLBuildInsert(defTable,nil,{"%s","%s","%s","%d","%s","%s","%s","%s"})
        if(not IsExistent(sStmt)) then
          return StatusLog(nil,"InsertRecord: Build statement <"..sTable.."> failed") end
        Q = SQLCacheStmt("stmtInsertPieces", sStmt, unpack(arLine)) end
    elseif(sTable == "ADDITIONS") then
      Q = SQLCacheStmt("stmtInsertAdditions", nil, unpack(arLine))
      if(not Q) then
        local sStmt = SQLBuildInsert(defTable,nil,{"%s","%s","%s","%d","%s","%s","%d","%d","%d","%d","%d","%d"})
        if(not IsExistent(sStmt)) then
          return StatusLog(nil,"InsertRecord: Build statement <"..sTable.."> failed") end
        Q = SQLCacheStmt("stmtInsertAdditions", sStmt, unpack(arLine)) end
    elseif(sTable == "PHYSPROPERTIES") then
      Q = SQLCacheStmt("stmtInsertPhysproperties", nil, unpack(arLine))
      if(not Q) then
        local sStmt = SQLBuildInsert(defTable,nil,{"%s","%d","%s"})
        if(not IsExistent(sStmt)) then
          return StatusLog(nil,"InsertRecord: Build statement <"..sTable.."> failed") end
        Q = SQLCacheStmt("stmtInsertPhysproperties", sStmt, unpack(arLine)) end
    else return StatusLog(false, "InsertRecord: Missed query pattern for <"..sTable..">") end
    if(not IsExistent(Q)) then
      return StatusLog(false, "InsertRecord: Internal cache error <"..sTable..">")end
    local qRez = sqlQuery(Q)
    if(not qRez and IsBool(qRez)) then
       return StatusLog(false,"InsertRecord: Failed to insert a record because of <"
              ..sqlLastError().."> Query ran <"..Q..">") end
    return true
  elseif(sModeDB == "LUA") then
    local snPrimaryKey = MatchType(defTable,arLine[1],1)
    if(not IsExistent(snPrimaryKey)) then -- If primary key becomes a number
      return StatusLog(nil,"InsertRecord: Cannot match primary key "
                          ..sTable.." <"..tostring(arLine[1]).."> to "
                          ..defTable[1][1].." for "..tostring(snPrimaryKey)) end
    local tCache = libCache[defTable.Name]
    if(not IsExistent(tCache)) then
      return StatusLog(false,"InsertRecord: Cache not allocated for "..defTable.Name) end
    if(sTable == "PIECES") then
      local stData = tCache[snPrimaryKey]
      if(not stData) then
        tCache[snPrimaryKey] = {}; stData = tCache[snPrimaryKey] end
      if(not IsExistent(stData.Type)) then stData.Type = arLine[2] end
      if(not IsExistent(stData.Name)) then stData.Name = arLine[3] end
      if(not IsExistent(stData.Unit)) then stData.Unit = arLine[8] end
      if(not IsExistent(stData.Kept)) then stData.Kept = 0        end
      if(not IsExistent(stData.Slot)) then stData.Slot = snPrimaryKey end
      local nOffsID = MatchType(defTable,arLine[4],4) -- LineID has to be set properly
      if(not IsExistent(nOffsID)) then
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(arLine[4]).."> to "
                            ..defTable[4][1].." for "..tostring(snPrimaryKey))
      end
      local stRezul = RegisterPOA(stData,nOffsID,arLine[5],arLine[6],arLine[7])
      if(not IsExistent(stRezul)) then
        return StatusLog(nil,"InsertRecord: Cannot process offset #"..tostring(nOffsID).." for "..tostring(snPrimaryKey)) end
      if(nOffsID > stData.Kept) then stData.Kept = nOffsID else
        return StatusLog(nil,"InsertRecord: Offset #"..tostring(nOffsID).." sequential mismatch") end
    elseif(sTable == "ADDITIONS") then
      local stData = tCache[snPrimaryKey]
      if(not stData) then
        tCache[snPrimaryKey] = {}; stData = tCache[snPrimaryKey] end
      if(not IsExistent(stData.Kept)) then stData.Kept = 0 end
      if(not IsExistent(stData.Slot)) then stData.Slot = snPrimaryKey end
      local nCnt, sFld, nAddID = 2, "", MatchType(defTable,arLine[4],4)
      if(not IsExistent(nAddID)) then -- LineID has to be set properly
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(arLine[4]).."> to "
                            ..defTable[4][1].." for "..tostring(snPrimaryKey)) end
      stData[nAddID] = {}
      while(nCnt <= defTable.Size) do
        sFld = defTable[nCnt][1]
        stData[nAddID][sFld] = MatchType(defTable,arLine[nCnt],nCnt)
        if(not IsExistent(stData[nAddID][sFld])) then  -- ADDITIONS is full of numbers
          return StatusLog(nil,"InsertRecord: Cannot match "
                    ..sTable.." <"..tostring(arLine[nCnt]).."> to "
                    ..defTable[nCnt][1].." for "..tostring(snPrimaryKey)) end
        nCnt = nCnt + 1
      end; stData.Kept = nAddID
    elseif(sTable == "PHYSPROPERTIES") then
      local sKeyName = GetOpVar("HASH_PROPERTY_NAMES")
      local sKeyType = GetOpVar("HASH_PROPERTY_TYPES")
      local tTypes   = tCache[sKeyType]
      local tNames   = tCache[sKeyName]
      -- Handle the Type
      if(not tTypes) then
        tCache[sKeyType] = {}; tTypes = tCache[sKeyType]; tTypes.Kept = 0 end
      if(not tNames) then
        tCache[sKeyName] = {}; tNames = tCache[sKeyName] end
      local iNameID = MatchType(defTable,arLine[2],2)
      if(not IsExistent(iNameID)) then -- LineID has to be set properly
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(arLine[2]).."> to "
                            ..defTable[2][1].." for "..tostring(snPrimaryKey)) end
      if(not IsExistent(tNames[snPrimaryKey])) then
        -- If a new type is inserted
        tTypes.Kept = tTypes.Kept + 1
        tTypes[tTypes.Kept] = snPrimaryKey
        tNames[snPrimaryKey] = {}
        tNames[snPrimaryKey].Kept = 0
        tNames[snPrimaryKey].Slot = snPrimaryKey
      end -- MatchType crashes only on numbers
      tNames[snPrimaryKey].Kept = iNameID
      tNames[snPrimaryKey][iNameID] = MatchType(defTable,arLine[3],3)
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
  if(not IsExistent(sTimerSet)) then
    return StatusLog(nil,"TimerSetting: Timer set missing for setup") end
  if(not IsString(sTimerSet)) then
    return StatusLog(nil,"TimerSetting: Timer set {"..type(sTimerSet).."}<"..tostring(sTimerSet).."> not string") end
  local tBoom = stringExplode(GetOpVar("OPSYM_REVSIGN"),sTimerSet)
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
  if(not IsExistent(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model does not exist") end
  if(not IsString(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model {"..type(sModel).."}<"..tostring(sModel).."> not string") end
  if(IsEmptyString(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model empty string") end
  if(not utilIsValidModel(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model invalid <"..sModel..">") end
  local defTable = GetOpVar("DEFTABLE_PIECES")
  if(not defTable) then
    return StatusLog(nil,"CacheQueryPiece: Table definition missing") end
  local tCache = libCache[defTable.Name] -- Match the model casing
  local sModel = MatchType(defTable,sModel,1,false,"",true,true)
  if(not IsExistent(tCache)) then
    return StatusLog(nil,"CacheQueryPiece: Cache not allocated for <"..defTable.Name..">") end
  local caInd    = GetOpVar("NAV_PIECE")
  if(not IsExistent(caInd[1])) then caInd[1] = defTable.Name end caInd[2] = sModel
  local stPiece  = tCache[sModel]
  if(IsExistent(stPiece) and IsExistent(stPiece.Kept)) then
    if(stPiece.Kept > 0) then
      return TimerRestart(libCache,caInd,defTable,"CacheQueryPiece") end
    return nil
  else
    local sModeDB = GetOpVar("MODE_DATABASE")
    if(sModeDB == "SQL") then
      LogInstance("CacheQueryPiece: Model >> Pool <"..stringToFileName(sModel)..">")
      tCache[sModel] = {}; stPiece = tCache[sModel]; stPiece.Kept = 0
      local Q = SQLFetchSelect("CacheQueryPiece", sModel)
      if(not Q) then
        Q = SQLBuildSelect(defTable,nil,{{1,sModel}},{4})
        if(not IsExistent(Q)) then
          return StatusLog(nil,"CacheQueryPiece: Build statement failed") end
        Print(SQLStoreSelect("CacheQueryPiece",Q), "CacheQueryPiece: SQLStoreSelect")
      end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        return StatusLog(nil,"CacheQueryPiece: SQL exec error <"..sqlLastError()..">") end
      if(not (qData and qData[1])) then
        return StatusLog(nil,"CacheQueryPiece: No data found <"..Q..">") end
      stPiece.Kept = 1 --- Found at least one record
      stPiece.Slot = sModel
      stPiece.Type = qData[1][defTable[2][1]]
      stPiece.Name = qData[1][defTable[3][1]]
      stPiece.Unit = qData[1][defTable[8][1]]
      local qRec, qRez
      while(qData[stPiece.Kept]) do
        qRec = qData[stPiece.Kept]
        qRez = RegisterPOA(stPiece,
                           stPiece.Kept,
                           qRec[defTable[5][1]],
                           qRec[defTable[6][1]],
                           qRec[defTable[7][1]])
        if(not IsExistent(qRez)) then
          return StatusLog(nil,"CacheQueryPiece: Cannot process offset #"..tostring(stPiece.Kept).." for <"..sModel..">")
        end
        stPiece.Kept = stPiece.Kept + 1
      end
      return TimerAttach(libCache,caInd,defTable,"CacheQueryPiece")
    elseif(sModeDB == "LUA") then return StatusLog(nil,"CacheQueryPiece: Record not located")
    else return StatusLog(nil,"CacheQueryPiece: Wrong database mode <"..sModeDB..">") end
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

local function GetColumns(defTable, sDelim)
  if(not IsExistent(sDelim)) then return "" end
  local sDelim  = tostring(sDelim or "\t"):sub(1,1)
  local sResult = ""
  if(IsEmptyString(sDelim)) then
    return StatusLog("","GetColumns: Invalid delimiter for <"..defTable.Name..">") end
  local iCount  = 1
  local namField
  while(defTable[iCount]) do
    namField = defTable[iCount][1]
    if(not IsString(namField)) then
      return StatusLog("","GetColumns: Field #"..iCount
               .." {"..type(namField).."}<"..tostring(namField).."> not string") end
    sResult = sResult..namField
    if(defTable[iCount + 1]) then sResult = sResult..sDelim end
    iCount = iCount + 1
  end
  return sResult
end

function GetDirectoryObj(pCurr, vName)
  if(not pCurr) then
    return StatusLog(nil,"GetDirectoryObj: Location invalid") end
  local sName = tostring(vName or "")
        sName = IsEmptyString(sName) and "Other" or sName
  if(not pCurr[sName]) then
    return StatusLog(nil,"GetDirectoryObj: Location invalid") end
  return pCurr[sName], pCurr[sName].__ObjPanel__
end

function SetDirectoryObj(pnBase, pCurr, vName, sImage, txCol)
  local sName = tostring(vName or "")
        sName = IsEmptyString(sName) and "Other" or sName
  local pItem = pnBase:AddNode(sName)
  pCurr[sName] = {}; pCurr[sName].__ObjPanel__ = pItem
  pItem:SetName(sName)
  return pCurr[sName], pItem
end


function expCaegoty(sNam, vEq)
  local nEq = tonumber(vEq) or 0
  if(nEq <= 0) then
    return StatusLog(nil, "Wrong equality <"..tostring(vEq)..">") end
  local sEq, nLen = ("="):rep(nEq), (nEq+2)
  local tCat = GetOpVar("TABLE_CATEGORIES")
  local ioF  = fileOpen(sNam, "w")
  for cat, rec in pairs(tCat) do
    if(IsString(rec.Txt)) then
      local exp = "["..sEq.."["..cat..sEq..rec.Txt:Trim("%s").."]"..sEq.."]"
      if(not rec.Txt:find("\n")) then
        return StatusLog(nil, "Category one-liner <"..cat..">") end
      ioF:write(exp.."\n")
    else StatusLog(nil, "Category <"..cat.."> code <"..tostring(rec.Txt).."> invalid ") end
  end; ioF:flush(); ioF:close()
end

function impCategory(sNam, vEq)
  local nEq = tonumber(vEq) or 0
  if(nEq <= 0) then
    return StatusLog(nil, "Wrong equality <"..tostring(vEq)..">") end
  local sEq, sLin, nLen = ("="):rep(nEq), "", (nEq+2)
  local cFr, cBk, sCh = "["..sEq.."[", "]"..sEq.."]", "X"
  local tCat = GetOpVar("TABLE_CATEGORIES")
  local ioF, sPar, isPar = fileOpen(sNam, "r"), "", false
  while(sCh) do
    sCh = ioF:read(1)
    if(not sCh) then break end
    if(sCh == "\n") then
      if(sLin:sub(-1,-1) == "\r") then
        sLin = sLin:sub(1,-2) end
      local sFr, sBk = sLin:sub(1,nLen), sLin:sub(-nLen,-1)
      if(sFr == cFr and sBk == cBk) then
        return StatusLog(nil, "Category one-liner <"..sLin..">")
      elseif(sFr == cFr and not isPar) then
        sPar, isPar = sLin:sub(nLen+1,-1).."\n", true
      elseif(sBk == cBk and isPar) then
        sPar, isPar = sPar..sLin:sub(1,-nLen-1), false
        local tBoo = stringExplode(sEq,sPar)
        local key, txt = tBoo[1], tBoo[2]
        if(key == "") then
          return StatusLog(nil, "Name missing <"..txt..">") end
        if(not txt:find("function")) then
          return StatusLog(nil, "Function missing <"..key..">") end
        tCat[key] = {}; tCat[key].Txt = txt:Trim("%s")
        tCat[key].Cmp = CompileString("return ("..tCat[key].Txt..")",key)
      else sPar = sPar..sLin.."\n" end; sLin = ""
    else sLin = sLin..sCh end
  end; ioF:close(); return tCat
end

SetOpVar("TIME_EPOCH",osClock())

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
  local tPool = GetOpVar("LOCALIFY_TABLE")
  if(not IsExistent(tPool[sCode])) then tPool[sCode] = {}; end
  tPool[sCode][sPhrase] = tostring(sDetail)
end

function InitLocalify(sCode) -- https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
  local tPool = GetOpVar("LOCALIFY_TABLE")
  local sCode = tostring(sCode or "") -- English is used when missing
        sCode = tPool[sCode] and sCode or GetOpVar("LOCALIFY_AUTO")
  if(not IsExistent(tPool[sCode])) then
    return StatusLog(nil,"InitLocalify: Code <"..sCode.."> invalid") end
  LogInstance("InitLocalify: Code <"..sCode.."> selected")
  for phrase, detail in pairs(tPool[sCode]) do print(phrase, detail) end
end

local function StripValue(vVal)
  local sVal = tostring(vVal or ""):Trim()
  if(sVal:sub( 1, 1) == "\"") then sVal = sVal:sub(2,-1) end
  if(sVal:sub(-1,-1) == "\"") then sVal = sVal:sub(1,-2) end
  return sVal:Trim()
end

-- Golden retriever reads file line as string
-- But seriously returns the sting line and EOF flag
local function GetStringFile(pFile)
  if(not pFile) then return StatusLog("", "GetStringFile: No file"), true end
  local sCh, sLine = "X", "" -- Use a value to start cycle with
  while(sCh) do sCh = pFile:Read(1); if(not sCh) then break end
    if(sCh == "\n") then return sLine:Trim(), false else sLine = sLine..sCh end
  end; return sLine:Trim(), true -- EOF has been reached. Return the last data
end

function ImportCategory(vEq, sPref)
  if(SERVER) then return StatusLog(true, "ImportCategory: Working on server") end
  local nEq = tonumber(vEq) or 0; if(nEq <= 0) then
    return StatusLog(false,"ImportCategory: Wrong equality <"..tostring(vEq)..">") end
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        fName = fName..tostring(sPref or GetInstPref())
        fName = fName..GetOpVar("TOOLNAME_PU").."CATEGORY.txt"
  local F = fileOpen(fName, "rb", "DATA")
  if(not F) then return StatusLog(false,"ImportCategory: fileOpen("..fName..") failed") end
  local sEq, sLine, nLen = ("="):rep(nEq), "", (nEq+2)
  local cFr, cBk, sCh = "["..sEq.."[", "]"..sEq.."]", "X"
  local tCat, symOff = GetOpVar("TABLE_CATEGORIES"), GetOpVar("OPSYM_DISABLE")
  local sPar, isPar, isEOF = "", false, false
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    local sFr, sBk = sLine:sub(1,nLen), sLine:sub(-nLen,-1)
    if(sFr == cFr and sBk == cBk) then
      sLine, isPar, sPar = sLine:sub(nLen+1,-1), true, "" end
    if(sFr == cFr and not isPar) then
      sPar, isPar = sLine:sub(nLen+1,-1).."\n", true
    elseif(sBk == cBk and isPar) then
      sPar, isPar = sPar..sLine:sub(1,-nLen-1), false
      local tBoo = sEq:Explode(sPar)
      local key, txt = tBoo[1]:Trim(), tBoo[2]
      if(not IsEmptyString(key)) then
        if(txt:find("function")) then
          if(key:sub(1,1) ~= symOff) then
            tCat[key] = {}; tCat[key].Txt = txt:Trim()
            tCat[key].Cmp = CompileString("return ("..tCat[key].Txt..")",key)
            local suc, out = pcall(tCat[key].Cmp)
            if(suc) then tCat[key].Cmp = out else
              tCat[key].Cmp = StatusLog(nil, "ImportCategory: Compilation fail <"..key..">") end
          else LogInstance("ImportCategory: Key skipped <"..key..">") end
        else LogInstance("ImportCategory: Function missing <"..key..">") end
      else LogInstance("ImportCategory: Name missing <"..txt..">") end
    else sPar = sPar..sLine.."\n" end; sLine = ""
  end; F:Close(); return StatusLog(true, "ImportCategory: Success")
end

function ProcessDSV(sDelim)
  local fName = GetOpVar("DIRPATH_BAS").."trackasmlib_dsv.txt"
  local F = fileOpen(fName, "rb" ,"DATA")
  if(not F) then return StatusLog(false,"ProcessDSV: fileOpen("..fName..") failed") end
  local sCh, sLine, symOff = "X", "", GetOpVar("OPSYM_DISABLE")
  local sNt, tProc = GetOpVar("TOOLNAME_PU"), {}
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local sDv = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
  while(sCh) do
    sCh = F:Read(1)
    if(not sCh) then break end
    if(sCh == "\n") then sLine = sLine:Trim()
      if(sLine:sub(1,1) ~= symOff) then
        local tInf = stringExplode(sDelim, sLine)
        local fPrf = StripValue(tostring(tInf[1] or ""):Trim())
        local fSrc = StripValue(tostring(tInf[2] or ""):Trim())
        if(not IsEmptyString(fPrf)) then -- Is there something
          if(not tProc[fPrf]) then
            tProc[fPrf] = {Cnt = 1, [1] = {Prog = fSrc, File = (sDv..fPrf..sNt)}}
          else -- Prefix is processed already
            local tStore = tProc[fPrf]
            tStore.Cnt = tStore.Cnt + 1 -- Store the count of the repeated prefixes
            tStore[tStore.Cnt] = {Prog = fSrc, File = (sDv..fPrf..sNt)}
          end -- That user puts there is a problem of his own
        end -- If the line is disabled/comment
      else LogInstance("ProcessDSV: Skipped <"..sLine..">") end; sLine = ""
    else sLine = sLine..sCh end
  end; F:Close()
  for prf, tab in pairs(tProc) do
    if(tab.Cnt > 1) then
      PrintInstance("ProcessDSV: Prefix <"..prf.."> clones #"..tostring(tab.Cnt).." @"..fName)
      for i = 1, tab.Cnt do
        PrintInstance("ProcessDSV: Prefix <"..prf.."> "..tab[i].Prog)
      end
    else
      local dir = tab[tab.Cnt].File
      if(CLIENT) then
        if(fileExists(dir.."CATEGORY.txt", "DATA")) then
          if(not ImportCategory(3, prf)) then F:Close()
            return StatusLog(false,"ProcessDSV("..prf.."): Failed CATEGORY") end
        end
      end
      if(fileExists(dir.."PIECES.txt", "DATA")) then
        if(not ImportDSV("PIECES", true, prf)) then F:Close()
          return StatusLog(false,"ProcessDSV("..prf.."): Failed PIECES") end
      end
      if(fileExists(dir.."ADDITIONS.txt", "DATA")) then
        if(not ImportDSV("ADDITIONS", true, prf)) then F:Close()
          return StatusLog(false,"ProcessDSV("..prf.."): Failed ADDITIONS") end
      end
      if(fileExists(dir.."PHYSPROPERTIES.txt", "DATA")) then
        if(not ImportDSV("PHYSPROPERTIES", true, prf)) then F:Close()
          return StatusLog(false,"ProcessDSV("..prf.."): Failed PHYSPROPERTIES") end
      end
    end
  end; return StatusLog(true,"ProcessDSV: Success")
end

function SynchronizeDSV(sTable, tData, bRepl, sPref, sDelim)
  local fPref = tostring(sPref or GetInstPref())
  if(not IsString(sTable)) then
    return StatusLog(false,"SynchronizeDSV("..fPref.."): Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"SynchronizeDSV("..fPref.."): Missing table definition for <"..sTable..">") end
  local fName, sDelim = GetOpVar("DIRPATH_BAS"), tostring(sDelim or "\t"):sub(1,1)
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..fPref..defTable.Name..".txt"
  local I, fData, smOff = fileOpen(fName, "rb", "DATA"), {}, GetOpVar("OPSYM_DISABLE")
  if(I) then
    local sLine, sCh  = "", "X"
    while(sCh) do
      sCh = I:Read(1)
      if(not sCh) then break end
      if(sCh == "\n") then
        sLine = sLine:Trim()
        if(sLine:sub(1,1) ~= smOff) then
          local tLine = stringExplode(sDelim,sLine)
          if(tLine[1] == defTable.Name) then
            for i = 1, #tLine do tLine[i] = StripValue(tLine[i]) end
            local sKey = tLine[2]
            if(not fData[sKey]) then fData[sKey] = {Kept = 0} end
              tKey = fData[sKey]
            local nRake, vRake = 0 -- The raking angle
            if    (sTable == "PIECES") then vRake = tLine[5]; nRake = tonumber(vRake) or 0 end
            tKey.Kept = 1; tKey[tKey.Kept] = {}
            local kKey, nCnt = tKey[tKey.Kept], 3
            while(tLine[nCnt]) do -- Do a value matching without quotes
              local vMatch = MatchType(defTable,tLine[nCnt],nCnt-1)
              if(not IsExistent(vMatch)) then
                I:Close(); return StatusLog(false,"SynchronizeDSV("..fPref.."): Read matching failed <"
                  ..tostring(tLine[nCnt]).."> to <"..tostring(nCnt-1).." # "
                    ..defTable[nCnt-1][1].."> of <"..sTable..">")
              end; kKey[nCnt-2] = vMatch; nCnt = nCnt + 1
            end
          else I:Close()
            return StatusLog(false,"SynchronizeDSV("..fPref.."): Read table name mismatch <"..sTable..">") end
        end; sLine = ""
      else sLine = sLine..sCh end
    end; I:Close()
  else LogInstance("SynchronizeDSV("..fPref.."): Creating file <"..fName..">") end
  Print(fData, "fData")
  for key, rec in pairs(tData) do -- Check the given table
    for pnID = 1, #rec do
      local tRec = rec[pnID]
      local nRake, vRake = 0 -- Where the lime ID mut be read from
      if(sTable == "PIECES") then
        vRake = tRec[3]; nRake = tonumber(vRake) or 0
     --   if(not fileExists(key, "GAME")) then
     --     LogInstance("SynchronizeDSV("..fPref.."): Missing piece <"..key..">") end
      end
      print(tRec, "tRec")
      for nCnt = 1, #tRec do -- Do a value matching without quotes
        local vMatch = MatchType(defTable,tRec[nCnt],nCnt+1)
        if(not IsExistent(vMatch)) then
          return StatusLog(false,"SynchronizeDSV("..fPref.."): Given matching failed <"
            ..tostring(tRec[nCnt]).."> to <"..tostring(nCnt+1).." # "
              ..defTable[nCnt+1][1].."> of "..sTable)
        end
      end
    end -- Register the read line to the output file
    if(bRepl) then
      if(tData[key]) then -- Update the file with the new data
        fData[key] = rec
        fData[key].Kept = #rec
      end
    else --[[ Do not modify fData ]] end
  end
  local tSort = Sort(tableGetKeys(fData))
  if(not tSort) then
    return StatusLog(false,"SynchronizeDSV("..fPref.."): Sorting failed") end
  local O = fileOpen(fName, "wb" ,"DATA")
  if(not O) then return StatusLog(false,"SynchronizeDSV("..fPref.."): Write fileOpen("..fName..") failed") end
  O:Write("# SynchronizeDSV("..fPref.."): "..GetDate().." ["..GetOpVar("MODE_DATABASE").."]\n")
  O:Write("# Data settings:\t"..GetColumns(defTable,sDelim).."\n")
  for rcID = 1, #tSort do
    local key = tSort[rcID].Val
    local rec = fData[key]
    local sCash, sData = defTable.Name..sDelim..key, ""
    for pnID = 1, rec.Kept do
      local tItem = rec[pnID]
      for nCnt = 1, #tItem do
        local vMatch = MatchType(defTable,tItem[nCnt],nCnt+1,true,"\"",true)
        if(not IsExistent(vMatch)) then
          O:Flush(); O:Close()
          return StatusLog(false,"SynchronizeDSV("..fPref.."): Write matching failed <"
            ..tostring(tItem[nCnt]).."> to <"..tostring(nCnt+1).." # "..defTable[nCnt+1][1].."> of "..sTable)
        end; sData = sData..sDelim..tostring(vMatch)
      end; O:Write(sCash..sData.."\n"); sData = ""
    end
  end O:Flush(); O:Close()
  return StatusLog(true,"SynchronizeDSV("..fPref.."): Success")
end

function TranslateDSV(sTable, sPref, sDelim)
  local fPref  = tostring(sPref or GetInstPref())
  if(not IsString(sTable)) then
    return StatusLog(false,"TranslateDSV("..fPref.."): Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"TranslateDSV("..fPref.."): Missing table definition for <"..sTable..">") end
  local sNdsv, sNins = GetOpVar("DIRPATH_BAS"), GetOpVar("DIRPATH_BAS")
  if(not fileExists(sNins,"DATA")) then fileCreateDir(sNins) end
  sNdsv, sNins = sNdsv..GetOpVar("DIRPATH_DSV"), sNins..GetOpVar("DIRPATH_INS")
  if(not fileExists(sNins,"DATA")) then fileCreateDir(sNins) end
  sNdsv, sNins = sNdsv..fPref..defTable.Name..".txt", sNins..fPref..defTable.Name..".txt"
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local D = fileOpen(sNdsv, "rb", "DATA")
  if(not D) then return StatusLog(false,"TranslateDSV("..fPref.."): fileOpen("..sNdsv..") failed") end
  local I = fileOpen(sNins, "wb", "DATA")
  if(not I) then return StatusLog(false,"TranslateDSV("..fPref.."): fileOpen("..sNins..") failed") end
  I:Write("# TranslateDSV("..fPref.."@"..sTable.."): "..GetDate().." ["..GetOpVar("MODE_DATABASE").."]\n")
  I:Write("# Data settings:\t"..GetColumns(defTable, sDelim).."\n")
  local pfLib = GetOpVar("NAME_LIBRARY"):gsub(GetOpVar("NAME_INIT"),"")
  local sLine, isEOF, symOff = "", false, GetOpVar("OPSYM_DISABLE")
  local sFr, sBk, sHs = pfLib..".InsertRecord(\""..sTable.."\", {", "})\n", (fPref.."@"..sTable)
  while(not isEOF) do sLine, isEOF = GetStringFile(D)
    sLine = sLine:gsub(defTable.Name,""):Trim()
    if(not IsEmptyString(sLine) and sLine:sub(1,1) ~= symOff) then
      local tBoo, sCat = sDelim:Explode(sLine), ""
      for nCnt = 1, #tBoo do
        local vMatch = MatchType(defTable,StripValue(tBoo[nCnt]),nCnt,true,"\"",true)
        if(not IsExistent(vMatch)) then D:Close(); I:Flush(); I:Close()
          return StatusLog(false,"TranslateDSV("..sHs.."): Given matching failed <"
            ..tostring(tBoo[nCnt]).."> to <"..tostring(nCnt).." # "
              ..defTable[nCnt][1].."> of "..sTable) end
        sCat = sCat..", "..tostring(vMatch)
      end; I:Write(sFr..sCat:sub(3,-1)..sBk)
    end
  end; D:Close(); I:Flush(); I:Close()
  return StatusLog(true,"TranslateDSV("..sHs.."): Success")
end

function RegisterDSV(sProg, sPref, sDelim, bSkip)
  if(CLIENT and gameSinglePlayer()) then
    return StatusLog(true,"RegisterDSV: Single client") end
  local sPref = tostring(sPref or GetInstPref())
  if(IsEmptyString(sPref)) then
    return StatusLog(false,"RegisterDSV("..sPref.."): Prefix empty") end
  local sBas = GetOpVar("DIRPATH_BAS")
  if(not fileExists(sBas,"DATA")) then fileCreateDir(sBas) end
  local lbNam = GetOpVar("NAME_LIBRARY")
  local fName = (sBas..lbNam.."_dsv.txt")
  local sMiss, sDelim = GetOpVar("MISS_NOAV"), tostring(sDelim or "\t"):sub(1,1)
  if(bSkip) then
    local symOff = GetOpVar("OPSYM_DISABLE")
    local fPool, isEOF, isAct = {}, false, true
    local F, sLine = fileOpen(fName, "rb" ,"DATA"), ""
    if(not F) then return StatusLog(false,"RegisterDSV("
      ..sPref.."): fileOpen("..fName..") read failed") end
    while(not isEOF) do sLine, isEOF = GetStringFile(F)
      if(not IsEmptyString(sLine)) then
        if(sLine:sub(1,1) == symOff) then
          isAct, sLine = false, sLine:sub(2,-1) else isAct = true end
        local tab = sDelim:Explode(sLine)
        local prf, src = tab[1]:Trim(), tab[2]:Trim()
        local inf = fPool[prf]
        if(not inf) then
          fPool[prf] = {Cnt = 1}; inf = fPool[prf]
          inf[inf.Cnt] = {src, isAct}
        else
          inf.Cnt = inf.Cnt + 1
          inf[inf.Cnt] = {src, isAct}
        end
      end
    end; F:Close()
    if(fPool[sPref]) then
      local inf = fPool[sPref]
      for ID = 1, inf.Cnt do local tab = inf[ID]
        LogInstance("RegisterDSV("..sPref.."): "..(tab[2] and "On " or "Off").." <"..tab[1]..">") end
      return StatusLog(true,"RegisterDSV("..sPref.."): Skip <"..sProg..">")
    end
  end; local F = fileOpen(fName, "ab" ,"DATA")
  if(not F) then return StatusLog(false,"RegisterDSV("
    ..sPref.."): fileOpen("..fName..") append failed") end
  F:Write(sPref..sDelim..tostring(sProg or sMiss).."\n"); F:Flush(); F:Close()
  return StatusLog(true,"RegisterDSV("..sPref.."): Register")
end

--[[
 * Import table data from DSV database created earlier
 * sTable > Definition KEY to import
 * bComm  > Calls @InsertRecord(sTable,arLine) when set to true
 * sPref  > Prefix used on importing ( if any )
 * sDelim > Delimiter separating the values
]]--
function ImportDSV(sTable, bComm, sPref, sDelim)
  local fPref = tostring(sPref or GetInstPref())
  if(not IsString(sTable)) then
    return StatusLog(false,"ImportDSV("..fPref.."): Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ImportDSV("..fPref.."): Missing table definition for <"..sTable..">") end
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        fName = fName..fPref..defTable.Name..".txt"
  local F = fileOpen(fName, "rb", "DATA")
  if(not F) then return StatusLog(false,"ImportDSV("..fPref.."): fileOpen("..fName..") failed") end
  local symOff, sDelim = GetOpVar("OPSYM_DISABLE"), tostring(sDelim or "\t"):sub(1,1)
  local sLine, isEOF, nLen = "", false, defTable.Name:len()
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if((not IsEmptyString(sLine)) and (sLine:sub(1,1) ~= symOff)) then
      if(sLine:sub(1,nLen) == defTable.Name) then
        local tData = sDelim:Explode(sLine:sub(nLen+2,-1))
        for iCnt = 1, defTable.Size do
          tData[iCnt] = StripValue(tData[iCnt]) end
        if(bComm) then InsertRecord(sTable, tData) end
      end
    end
  end; F:Close(); return StatusLog(true, "ImportDSV("..fPref.."@"..sTable.."): Success")
end

function InsertsDSV(sTable, sPref, sDelim)
  local fPref  = tostring(sPref or GetInstPref())
  if(not IsString(sTable)) then
    return StatusLog(false,"InsertsDSV("..fPref.."): Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"InsertsDSV("..fPref.."): Missing table definition for <"..sTable..">") end
  local sNdsv  = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        sNdsv  = sNdsv..fPref..defTable.Name..".txt"
  local sNins  = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_INS")
        sNins  = sNins..fPref..defTable.Name..".txt"
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local D, I   = fileOpen(sNdsv, "rb", "DATA"), fileOpen(sNins, "wb", "DATA")
  if(not D) then return StatusLog(false,"InsertsDSV("..fPref.."): fileOpen("..sNdsv..") failed") end
  if(not I) then return StatusLog(false,"InsertsDSV("..fPref.."): fileOpen("..sNins..") failed") end
  I:Write("# InsertsDSV("..fPref.."@"..sTable.."): "..osDate().." ["..GetOpVar("MODE_DATABASE").."]\n")
  I:Write("# Data settings:\t"..GetColumns(defTable, sDelim).."\n")
  local sLine, sCh, symOff = "", "X", GetOpVar("OPSYM_DISABLE")
  local sFr, sBk, sHs = "asmlib.InsertRecord(\""..sTable.."\", {", "})\n", (fPref.."@"..sTable)
  while(sCh) do
    sCh = D:Read(1)
    if(not sCh) then break end
    if(sCh == "\n") then
      sLine = sLine:gsub(defTable.Name,""):Trim()
      if(sLine:sub(1,1) ~= symOff) then
        local tBoo, sCat = stringExplode(sDelim, sLine), ""
        for nCnt = 1, #tBoo do
          local vMatch = MatchType(defTable,StripValue(tBoo[nCnt]),nCnt,true,"\"",true)
          if(not IsExistent(vMatch)) then D:Close(); I:Flush(); I:Close()
            return StatusLog(false,"InsertsDSV("..sHs.."): Given matching failed <"
              ..tostring(tBoo[nCnt]).."> to <"..tostring(nCnt).." # "
                ..defTable[nCnt][1].."> of "..sTable) end
          sCat = sCat..", "..tostring(vMatch)
        end
        I:Write(sFr..sCat:sub(3,-1)..sBk)
      else LogInstance("InsertsDSV("..sHs.."): Ignore <"..sLine..">") end sLine = ""
    else sLine = sLine..sCh end
  end; D:Close(); I:Flush(); I:Close()
  return StatusLog(true,"InsertsDSV("..sHs.."): Success")
end

function ExportDSV(sTable, sPref, sDelim)
  if(not IsString(sTable)) then
    return StatusLog(false,"StoreExternalDatabase: Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ExportDSV: Missing table definition for <"..sTable..">") end
  local fName, sPref = GetOpVar("DIRPATH_BAS"), tostring(sPref or GetInstPref())
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..sPref..defTable.Name..".txt"
  local F = fileOpen(fName, "wb", "DATA" )
  if(not F) then return StatusLog(false,"ExportDSV("..sPref
      .."): fileOpen("..fName..") failed") end
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local sModeDB, symOff = GetOpVar("MODE_DATABASE"), GetOpVar("OPSYM_DISABLE")
  F:Write("# ExportDSV: "..osDate().." [ "..sModeDB.." ]".."\n")
  F:Write("# Data settings:\t"..GetColumns(defTable,sDelim).."\n")
  if(sModeDB == "SQL") then
    local Q = ""
    if    (sTable == "PIECES"        ) then Q = SQLBuildSelect(defTable,nil,nil,{2,3,1,4})
    elseif(sTable == "ADDITIONS"     ) then Q = SQLBuildSelect(defTable,nil,nil,{1,4})
    elseif(sTable == "PHYSPROPERTIES") then Q = SQLBuildSelect(defTable,nil,nil,{1,2})
    else                                    Q = SQLBuildSelect(defTable,nil,nil,nil) end
    if(not IsExistent(Q)) then
      return StatusLog(false,"ExportDSV("..sPref.."): Build statement failed") end
    F:Write("# Query ran: <"..Q..">\n")
    local qData = sqlQuery(Q)
    
    ------------
    qData = {
      {"models/props_phx/construct/metal_plate1x2.mdl", "NULL", "#", 1, "NULL", "-0.02664,-47.455105,2.96593", "0,-90,0", "NULL"},
      {"models/props_phx/construct/metal_plate1x2.mdl", "NULL", "#", 2, "NULL", "-0.02664, 47.455105,2.96593", "0, 90,0", "NULL"}
    }
    ------------
    
    if(not qData and IsBool(qData)) then
      return StatusLog(nil,"ExportDSV: SQL exec error <"..sqlLastError()..">") end
    if(not (qData and qData[1])) then
      return StatusLog(false,"ExportDSV: No data found <"..Q..">") end
    local sData, sTab = "", defTable.Name
    for iCnt = 1, #qData do
      local qRec = qData[iCnt]; sData = sTab
      for iInd = 1, defTable.Size do
        local sHash = defTable[iInd][1]
        LogInstance(sHash)
        sData = sData..sDelim..tostring(MatchType(defTable,qRec[sHash],iInd,true,"\"",true))
      end; F:Write(sData.."\n"); sData = ""
    end
  elseif(sModeDB == "LUA") then
    local tCache = libCache[defTable.Name]
    if(not IsExistent(tCache)) then
      return StatusLog(false,"ExportDSV("..sPref.."): Table <"..sTable.."> cache not allocated") end
    if(sTable == "PIECES") then
      local tData = {}
      for sModel, tRecord in pairs(tCache) do
        local sSort   = (tRecord.Type..tRecord.Name..sModel)
        tData[sModel] = {[defTable[1][1]] = sSort}
      end
      local tSorted = Sort(tData,nil,{defTable[1][1]})
      if(not tSorted) then
        return StatusLog(false,"ExportDSV("..sPref.."): Cannot sort cache data") end
      for iIdx = 1, #tSorted do
        local stRec = tSorted[iIdx]
        local tData = tCache[stRec.Key]
        local tOffs = tData.Offs
        local sData = defTable.Name..sDelim..MatchType(defTable,stRec.Key,1,true,"\"")..sDelim..
                       MatchType(defTable,tData.Type,2,true,"\"")..sDelim..
                       MatchType(defTable,((ModelToName(stRec.Key) == tData.Name) and symOff or tData.Name),3,true,"\"")
        -- Matching crashes only for numbers. The number is already inserted, so there will be no crash
        for iInd = 1, #tOffs do 
          local stPnt = tData.Offs[iInd]
          F:Write(sData..sDelim..MatchType(defTable,iInd,4,true,"\"")..sDelim..
                   "\""..(IsEqualPOA(stPnt.P,stPnt.O) and "" or StringPOA(stPnt.P,"V")).."\""..sDelim..
                   "\""..  StringPOA(stPnt.O,"V").."\""..sDelim..
                   "\""..( IsZeroPOA(stPnt.A,"A") and "" or StringPOA(stPnt.A,"A")).."\""..sDelim..
                   "\""..(tData.Unit and tData.Unit or "").."\"\n")
        end
      end
    elseif(sTable == "ADDITIONS") then
      for mod, rec in pairs(tCache) do
        local sData = defTable.Name..sDelim..mod
        for iIdx = 1, #rec do
          local tData = rec[iIdx]; F:Write(sData)
          for iID = 2, defTable.Size do
            local vData = tData[defTable[iID][1]]
            F:Write(sDelim..MatchType(defTable,tData[defTable[iID][1]],iID,true,"\""))
          end; F:Write("\n") -- Data is already inserted, there will be no crash
        end
      end
    elseif(sTable == "PHYSPROPERTIES") then
      local tTypes = tCache[GetOpVar("HASH_PROPERTY_TYPES")]
      local tNames = tCache[GetOpVar("HASH_PROPERTY_NAMES")]
      if(not (tTypes or tNames)) then
        return StatusLog(false,"ExportDSV("..sPref.."): No data found") end
      for iInd = 1, tTypes.Kept do
        local sType = tTypes[iInd]
        local tType = tNames[sType]
        if(not tType) then return StatusLog(false,"ExportDSV("..sPref
            .."): Missing index #"..iInd.." on type <"..sType..">") end
        for iCnt = 1, tType.Kept do
          F:Write(defTable.Name..sDelim..MatchType(defTable,sType      ,1,true,"\"")..
                                 sDelim..MatchType(defTable,iCnt       ,2,true,"\"")..
                                 sDelim..MatchType(defTable,tType[iCnt],3,true,"\"").."\n")
        end
      end
    end
  end; F:Flush(); F:Close()
end

function SettingsLogs(sHash)
  local sKey = tostring(sHash or ""):upper():Trim()
  if(not (sKey == "SKIP" or sKey == "ONLY")) then
    return StatusLog(false,"SettingsLogs("..sKey.."): Invalid hash") end
  local tLogs, lbNam = GetOpVar("LOG_"..sKey), GetOpVar("NAME_LIBRARY")
  if(not tLogs) then return StatusLog(true,"SettingsLogs("..sKey.."): Skip table") end
  local fName = GetOpVar("DIRPATH_BAS")..lbNam.."_sl"..sKey:lower()..".txt"
  local S = fileOpen(fName, "rb", "DATA")
  if(S) then
    local sCh, sLine, isEOF = "X", "", false
    while(not isEOF) do sLine, isEOF = GetStringFile(S)
      if(sLine ~= "") then tableInsert(tLogs, sLine) end; sLine = ""
    end; S:Close(); return StatusLog(true,"SettingsLogs("..sKey.."): Success <"..fName..">")
  else return StatusLog(true,"SettingsLogs("..sKey.."): Missing <"..fName..">") end
end

--------------- TEST ------------------

function DisableString1(sBase, anyDisable, anyDefault)
  if(IsString(sBase)) then
    local sFirst = sBase:sub(1,1)
    if(sFirst ~= GetOpVar("OPSYM_DISABLE") and not IsEmptyString(sBase)) then
      return sBase
    elseif(sFirst == GetOpVar("OPSYM_DISABLE")) then
      return anyDisable
    end
  end; return anyDefault
end

function DisableString2(sBase, vDsb, vDef)
  if(IsString(sBase)) then 
    local sF, sD = sBase:sub(1,1), GetOpVar("OPSYM_DISABLE")
    if(sF ~= sD and not IsEmptyString(sBase)) then
      return sBase -- Not disabled or empty
    elseif(sF == sD) then return vDsb end
  end; return vDef
end

SetOpVar("MODE_DATABASE", "LUA")
