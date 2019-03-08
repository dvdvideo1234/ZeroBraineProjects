--[[
 * Label    : Module for hover module base functionality
 * Author   : DVD ( dvd_video )
 * E-mail   : dvd_video@abv.bg
 * Date     : 19-01-2017
 * Location : lua/hovermodule/hovermodlib.lua
 * Defines  : A list of functions for initializing a hover module
]]--

local type           = type
local next           = next
local pcall          = pcall
local print          = print
local pairs          = pairs
local unpack         = unpack
local tobool         = tobool
local tostring       = tostring
local tonumber       = tonumber
local CreateConVar   = CreateConVar
local PrintTable     = PrintTable
local Vector         = Vector
local Angle          = Angle
local Color          = Color
local SysTime        = SysTime
local IsValid        = IsValid
local CompileString  = CompileString
local CompileFile    = CompileFile
local setmetatable   = setmetatable
local getmetatable   = getmetatable
local collectgarbage = collectgarbage
local LocalPlayer    = LocalPlayer
local os             = os
local ents           = ents
local math           = math
local file           = file
local vgui           = vgui
local table          = table
local input          = input
local numpad         = numpad
local string         = string
local language       = language
local duplicator     = duplicator

local FILL                  = FILL
local KEY_E                 = KEY_E
local CLIENT                = CLIENT
local SERVER                = SERVER
local KEY_LSHIFT            = KEY_LSHIFT
local COLLISION_GROUP_NONE  = COLLISION_GROUP_NONE
local RENDERMODE_TRANSALPHA = RENDERMODE_TRANSALPHA

local libOpVars = {}

module("hovermodlib")

function GetOpVar(anyKey)
  return (anyKey and libOpVars[anyKey])
end

function IsNil(anyVal)
  return (anyVal == nil)
end

function IsString(sVal)
  return (getmetatable(sVal) == GetOpVar("TYPE_METASTRING"))
end

function IsEmptyTable(tData)
  return IsNil(next(tData))
end

function IsEmptyString(sData)
  return (sData == GetOpVar("STRING_ZERO"))
end

function IsNumber(sVal)
  return (tonumber(sVal) and IsNil(getmetatable(sVal)))
end

function GetPick(bIf, vTru, vFls)
  if(bIf) then return vTru else return vFls end
end

-- Function that calculates a sign
function GetSign(anyVal)
  local nVal = (tonumber(anyVal) or 0)
  return ((nVal > 0 and 1) or (nVal < 0 and -1) or 0) end

function GetDate()
  return (os.date(GetOpVar("DATE_FORMAT"))
   .." "..os.date(GetOpVar("TIME_FORMAT")))
end

function GetXY(xyPnt,nX,nY)
  local xyOut = {x = tonumber(xyPnt and xyPnt.x or 0), y = tonumber(xyPnt and xyPnt.y or 0)}
  xyOut.x, xyOut.y = (xyOut.x + (tonumber(nX) or 0)), (xyOut.y + (tonumber(nY) or 0))
  return xyOut -- Get a new point without overwriting the old one
end

-- Golden retriever. Retrieves file line as string
-- But seriously returns the sting line and EOF flag
local function GetStringFile(pFile)
  if(not pFile) then return StatusLog("", "GetStringFile: No file"), true end
  local sCh, sLine = "X", "" -- Use a value to start cycle with
  while(sCh) do sCh = pFile:Read(1); if(not sCh) then break end
    if(sCh == "\n") then return sLine:Trim(), false else sLine = sLine..sCh end
  end; return sLine:Trim(), true -- EOF has been reached. Return the last data
end

-- Project a vector without making a copy
function ProjectAngle(vVec, aAng)
  local F, R, U = aAng:Forward(), aAng:Right(), aAng:Up()
  local X, Y, Z = vVec:Dot(F), vVec:Dot(R), vVec:Dot(U)
  vVec.x, vVec.y, vVec.z = X, Y, Z; return vVec
end

-- Create vector from a component list
function GetVectorString(sVec)
  local symComp = GetOpVar("OPSYM_COMPONENT") -- Handle also [0,0,0]
  local arVec = symComp:Explode(sVec:gsub("%[",""):gsub("%]",""))
  return Vector(tonumber(arVec[1]) or 0,
                tonumber(arVec[2]) or 0,
                tonumber(arVec[3]) or 0)
end

-- Fixes a value to the nearest fraction
local function FixValue(nVal, nFrc)
  local nVal = tonumber(nVal) or 0
  local nFrc = tonumber(nFrc) or 0.01 -- Default the second digit
  local q, f = math.modf(nVal / nFrc)
  return nFrc * (q + (f > 0.5 and 1 or 0))
end

-- Converts vector to string with a given fraction
function GetStringVector(vVec, nFrc)
  local symComp = GetOpVar("OPSYM_COMPONENT")
  local x = FixValue(vVec.x, nFrc)
  local y = FixValue(vVec.y, nFrc)
  local z = FixValue(vVec.z, nFrc)
  return tostring(x)..symComp..tostring(y)..symComp..tostring(z)
end

function LogStatus(anyMsg, ...)
  local tSet = GetOpVar("LOG_SETTINGS")
  if(tSet["ENAB"]:GetBool()) then
    local tSkip, tOnly = tSet["SKIP"], tSet["ONLY"]
    local fLog, sMsg = GetOpVar("DIRPATH_BASE"), tostring(anyMsg)
    if(tSkip and tSkip[1]) then for id = 1, #tSkip do
      if(sMsg:find(tostring(tSkip[id]))) then return ... end end end
    if(tOnly and tOnly[1]) then for id = 1, #tOnly do
      if(not sMsg:find(tostring(tOnly[id]))) then return ... end end end
    if(tSet["LAST"] and tSet["LAST"] == sMsg) then return ... else tSet["LAST"] = sMsg end
    local bFile, sLib = tSet["FILE"]:GetBool(), GetOpVar("LIBRARY_NAME")
    local sLogo = GetPick(bFile, "", tostring(tSet.Info)..": ")
    local sTime = "["..GetDate()..":"..("%f"):format(SysTime()).."] "
    local sInst = (CLIENT and "CLIENT") or (SERVER and "SERVER") or "NOINST"
    local sLogs = sInst.." > "..sTime..sLogo..sMsg
    if(bFile) then file.Append(fLog..sLib.."_log.txt", sLogs.."\n")
    else print(sLogs) end
  end; return ...
end

function InitDataMapping()
  local tMap = GetOpVar("MAPPING_ENTDATA")
  local tGen = GetOpVar("MAPPING_GENERAL")
  for key, rec in pairs(tMap) do
    local var, id = tostring(rec[3] or ""), (tonumber(rec[5]) or 0)
    local foo = ((type(rec[6]) == "function") and rec[6] or nil)
    if(var and (type(var) == "string") and not IsEmptyString(var)) then tGen[var] = {key, id, foo}
      if(id <= 0) then LogStatus("InitDataMapping: Invalid ID #"..id.." for <"..key.."/"..var..">") end
    end
  end -- All generals must be defined using the global hover unit data[item][3]
end

local function ckControlTar(tab)
  local cn, mx, mt = #tab, table.getn(tab)
  if(cn ~= mx) then
    return LogStatus("ckControlTar: Array vacancies "..cn.." of "..mx, false) end
  if(cn == 0) then return LogStatus("ckControlTar: Array empty", false) end
  for id = 1, cn do if(type(tab[id]) ~= "string") then
    return LogStatus("ckControlTar: Array value #"..tostring(tab[id]).." not string", false) end end
  return true
end

local function ckControlTun(tab, dep)
  local cn, mx, mt = #tab, table.getn(tab), getmetatable("string")
  if(cn ~= mx) then
    return LogStatus("ckControlTun: Array vacancies "..cn.." of "..mx, false) end
  if(cn == 0) then return LogStatus("ckControlTun: Array empty", false) end
  if(cn >  3) then return LogStatus("ckControlTun: Array too long #"..cn, false) end
  for id = 1, cn do if(type(tab[id]) ~= "string") then
    return LogStatus("ckControlTun: Array value #"..tostring(tab[id]).." not string", false) end end
  return true
end

local function ckControlRef(tab, dep)
  local cn, mx = #tab, table.getn(tab)
  if(cn ~= mx) then
    return LogStatus("ckControlRef: Array vacancies "..cn.." of "..mx, false) end
  if(cn == 0) then return LogStatus("ckControlRef: Array empty", false) end
  if(cn >  2) then return LogStatus("ckControlRef: Array too long", false) end
  if(type(tab[1]) ~= "number") then return LogStatus("ckControlRef: Base value NaN", false) end
  if(tab[2]) then
    if(type(tab[2]) ~= "string") then
      return LogStatus("ckControlRef: Wire input not string but {"..
        type(tab[2]).."}<"..tostring(tab[2])..">", false) end
    local wRef = GetOpVar("WIRE_REFERENCES").Name
    for i = 1, #wRef do if(wRef[i] == tab[2]) then return true end
    end; return LogStatus("ckControlRef: Wire input mismatch <"..tab[2]..">", false)
  end; return true
end

local function ckVecOrigin(vec, dep) return true end

local function ckVecDirect(vec, dep)
  if(vec:Length() == 0) then
    return LogStatus("ckVecLength: Vector zero", false) end
  return true
end

local function ckTargetTable(tab, dep)
  for k, v in pairs(tab) do
    if(type(k) ~= "string") then -- All classes are strings so this is OK
      return LogStatus("ckTargetTable: Class not string but {"..type(k).."}<"..tostring(k)..">", false) end
    if(type(v) ~= "boolean") then -- Did intentionally for troubleshooting target list converter
      return LogStatus("ckTargetTable: Class state {"..type(v).."}<"..tostring(v)..">", false) end
    if(not v) then LogStatus("ckTargetTable: Class disabled <"..k..">") end
  end; return true
end

local function ckEmptyString(str)
  if(IsEmptyString(str)) then
    return LogStatus("ckEmptyString: Value empty", false) end; return true
end

function InitDependancies(vEnab, vFile)
  libOpVars["STRING_ZERO"     ] = ""
  libOpVars["NUMBER_ZERO"     ] = 10e-5
  libOpVars["VECTOR_ZERO"     ] = Vector()
  libOpVars["ANGLE_ZERO"      ] = Angle ()
  -- More meaningful name to the one above used for labels
  libOpVars["DATE_FORMAT"     ] = "%d-%m-%y"
  libOpVars["TIME_FORMAT"     ] = "%H:%M:%S"
  libOpVars["LOCALIFY_TABLE"  ] = GetPick(CLIENT,{},nil)
  libOpVars["TRANSLATE_KEYTAB"] = {[2]="nam",[4]="cat",[7]="tip"}
  libOpVars["FILE_ENTITY"     ] = "sent_"..GetOpVar("NAME_ENTITY") -- How is the entity controlled class called
  -- Base directory for all the data written. Defines there the library data is stored
  libOpVars["NAME_LIMIT"      ] = GetOpVar("NAME_ENTITY").."s"
  libOpVars["DIRPATH_BASE"    ] = GetOpVar("NAME_TOOL").."/"
  libOpVars["DIRPATH_SAVE"    ] = GetOpVar("NAME_ENTITY").."/"
  libOpVars["DIRPATH_PRESET"  ] = "presets/"
  libOpVars["DIRPATH_AUSAVE"  ] = "autosave/"
  libOpVars["FORM_LANGPATH"   ] = "%s"..GetOpVar("NAME_ENTITY").."/lang/%s"
  libOpVars["LOG_SETTINGS"    ] = {
    ["SKIP"] = {}, ["ONLY"] = {}, ["LAST"] = "",
    ["INFO"] = GetOpVar("NAME_TOOL"):gsub("^%l", string.upper),
    ["ENAB"] = vEnab, -- Enable logging in general
    ["FILE"] = vFile  -- Enable logging file
  } -- Make a list with the log settings
  libOpVars["CLASS_TARGETS"   ] = {
    ["prop_physics"] = true,
    ["prop_dynamic"] = true,
    ["prop_static"]  = true,
    ["prop_ragdoll"] = true
  }
  libOpVars["WIRE_REFERENCES" ] = {
    Name = {"RefGap", "RefSide", "RefPitch", "RefYaw", "RefRoll"},
    Type = {"NORMAL", "NORMAL" , "NORMAL"  , "NORMAL", "NORMAL" },
    Note = {"Refer gap spacing"  ,
            "Refer side symmetry",
            "Refer pitch bias"   ,
            "Refer yaw turn"     ,
            "Refer roll lean" }
  }
  libOpVars["CLASS_REGUPHYS"  ] = "prop_physics" -- Regular physics enabled prop
  libOpVars["TYPE_DEFCOLUMN"  ] = {} -- Columns that are enabled for processing
  libOpVars["UNIT_DESCRIPTION"] = {__size = 0} -- The hover unit description
  libOpVars["WIRE_PORTNAMES"  ] = {} -- Wire ports validation status storage
  libOpVars["TYPE_METASTRING" ] = getmetatable("") -- Store string meta-table
  --[[
   * This is used for data mapping
   * [1] > Data type and return value of `type()`
   * [2] > The value to be different from
   * [3] > Console variable mapping name
   * [4] > Validation function
   * [5] > Export ID the smaller the first
   * [6] > Function used to convert the string to the value needed
   * Keys are stored in square brackets. If the key name
   * is bordered with {} this means is must be applied on a
   * list of such values
  ]]--
  -- Legend for the mapping parameters
  -- If the convar name is defined, the general type is used
  libOpVars["MAPPING_GENERAL"] = {} -- Mapping Convar name to column name and ID
  libOpVars["MAPPING_ENTDATA"] = {
    ["Name"]    = {"string" , nil, "name"   , nil, 1, tostring},
    ["Prop"]    = {"string" , nil, "model"  , ckEmptyString, 2, tostring},
    ["FwLoc"]   = {"Vector" , nil, "fwloc"  , ckVecDirect, 3, GetVectorString},
    ["UpLoc"]   = {"Vector" , nil, "uploc"  , ckVecDirect, 4, GetVectorString},
    ["CnLoc"]   = {"Vector" , nil, "cnloc"  , ckVecOrigin, 5, GetVectorString},
    ["Mass"]    = {"number" , "+", "mass"   , nil, 6 , tonumber},
    ["MasPrt"]  = {"boolean", nil, "enmassp", nil, 7, tobool},
    ["Tick"]    = {"number" , "+", "tick"   , nil, 8 , tonumber},
    ["KeyOn"]   = {"number" , "+", "keyon"  , nil, 9 , tonumber},
    ["KeyF"]    = {"number" , "+", "keyf"   , nil, 10, tonumber},
    ["KeyR"]    = {"number" , "+", "keyr"   , nil, 11, tonumber},
    ["Target"]  = {"string" , nil, "target" , nil, 12, tostring},
    ["NumFor"]  = {"number" , nil, "numfor" , nil, 13, tonumber},
    ["NumTog"]  = {"boolean", nil, "numtog" , nil, 14, tobool},
    ["FrcDep"]  = {"number" , nil, "forcedp", nil, 15, tonumber},
    ["FrcDpC"]  = {"boolean", nil, "encfdp" , nil, 16, tobool},
    ["{Control}"] = { -- List of control structures
      ["Tar"]   = {"table"   , nil, nil, ckControlTar},
      ["Tun"]   = {"table"   , nil, nil, ckControlTun},
      ["Ref"]   = {"table"   , nil, nil, ckControlRef},
      ["Prs"]   = {"string"  , nil, nil, ckEmptyString},
      ["Cmb"]   = {"boolean" , nil},
      ["Neg"]   = {"boolean" , nil},
      ["Dev"]   = {"function", nil},
      ["ID"]    = {"number"  , nil}
    },
    ["{Sensors}"] = { -- List of sensor structures
      ["Hit"] = {"table" , nil, nil, ckTargetTable},
      ["Org"] = {"Vector", nil, nil, ckVecOrigin},
      ["Dir"] = {"Vector", nil, nil, ckVecDirect},
      ["Len"] = {"number", "~0"}, -- Length
      ["ID"]  = {"number", nil}, -- Export ID
      ["Val"] = {"number", nil}  -- Where the sensor sample is stored
    },
    ["{Forcers}"] = { -- List of forcer structures
      ["Org"] = {"Vector", nil, nil, ckVecOrigin},
      ["Dir"] = {"Vector", nil, nil, ckVecDirect},
      ["ID"]  = {"number", nil}
    }
  }
end

--[[
 * This defines the initialization columns.
 * It tells the program which column name is valid
]]--
function InitColumnNames()
  local tCol = GetOpVar("TYPE_DEFCOLUMN") -- Columns that are enabled for processing
  tCol[GetOpVar("TYPE_GENERAL")] = {["Val"] = true}
  tCol[GetOpVar("TYPE_FORCER") ] = {["Org"] = true, ["Dir"] = true}
  tCol[GetOpVar("TYPE_SENSOR") ] = {["Len"] = true, ["Org"] = true ,
                                    ["Dir"] = true, ["Hit"] = true}
  tCol[GetOpVar("TYPE_CONTROL")] = {["Ref"] = true, ["Tun"] = true ,
                                    ["Cmb"] = true, ["Neg"] = true ,
                                    ["Prs"] = true, ["Tar"] = true}
end

function LogTable(tT,sS,tP)
  local vS, vT, vK, sS = type(sS), type(tT), "", tostring(sS or "Data")
  if(vT ~= "table") then
    return LogStatus("{"..vT.."}["..tostring(sS or "Data").."] = <"..tostring(tT)..">") end
  if(IsEmptyTable(tT)) then
    return LogStatus(sS.." = {}") end; LogStatus(sS.." = {}")
  for k,v in pairs(tT) do
    if(type(k) == "string") then vK = sS.."[\""..k.."\"]"
    else sK = tostring(k)
      if(tP and tP[k]) then sK = tostring(tP[k]) end
      vK = sS.."["..sK.."]"
    end
    if(type(v) ~= "table") then
      if(type(v) == "string") then LogStatus(vK.." = \""..v.."\"")
      else sK = tostring(v)
        if(tP and tP[v]) then sK = tostring(tP[v]) end
        LogStatus(vK.." = "..sK)
      end
    else
      if(v == tT) then LogStatus(vK.." = "..sS)
      else LogTable(v,vK,tP) end
    end
  end
end

--[[
 * This function defines a margin for when a number
 * is in certain borders the process is considered a fail
]]--
local function DecodeMargin(vNum, sMar)
  local nNum = (tonumber(vNum) or 0)
  local sMar =  tostring(sMar or "")
      if(sMar == "~0") then return (nNum ~= 0)
  elseif(sMar == "=0") then return (nNum == 0)
  elseif(sMar == "0+") then return (nNum >= 0)
  elseif(sMar == "0-") then return (nNum <= 0)
  elseif(sMar ==  "+") then return (nNum >  0)
  elseif(sMar ==  "-") then return (nNum <  0)
  else LogStatus("DecodeMargin("..tostring(vNum)..","..sMar.."): Not supported") end
end

--[[
 * ValidateTable: Validates a stricture based
 * on the parameters given
 * aName > Any name to identify the validation
 * tData > The data to validate
 * tPara > Validation parameters
 * iStg  > Initial recursion stage. Managed internally
]]--
function ValidateTable(aName, tData, tPara, oPly, iStg)
  local suc, nam, stg = true, tostring(aName), ((tonumber(iStg) or 0)+1)
  for key, val in pairs(tData) do -- Output success
    local par, dep = tPara[key], nam.."["..key.."]"
    if(suc and not par and tPara["{"..key.."}"]) then -- Process item list of the same type
      local par = tPara["{"..key.."}"]
      if(not par) then
        return NotifyUser(oPly, "ValidateTable["..stg.."]: Hash item "..dep.." <"..type(val).."> fail", "ERROR", false) end
      for ki, vi in pairs(val) do
        local li = dep.."["..ki.."]"
        if(not ValidateTable(li, vi, par, oPly, stg)) then
          suc = NotifyUser(oPly, "ValidateTable["..stg.."]: Recursive item "
            ..dep.." <"..type(val).."> fail", "ERROR", false) end
      end
    elseif(suc and (type(par) ~= "table")) then -- It is not item list and parameters are invalid
      return NotifyUser(oPly, "ValidateTable["..stg.."]: Parameter "..dep.." <"..type(par).."> fail", "ERROR", false)
    elseif(suc and par[4] and type(par[4]) == "function") then -- Use the validation function for the value
      if(type(val) ~= par[1]) then -- Not having the experted type
        suc = NotifyUser(oPly, "ValidateTable["..stg.."]: Function type "
          ..dep.." is <"..type(val).."> expects <"..par[1]..">", "ERROR", false) end
      suc = par[4](val, dep); if(not suc) then
        NotifyUser(oPly, "Validated via function "..dep.." fail !", "ERROR") end
      LogStatus("Validated via function "..dep.." "..(suc and "OK" or "fail"))
    elseif(suc and type(val) == "table") then -- All the table parameters
      if(not ValidateTable(dep, val, par, oPly, stg)) then
        suc = NotifyUser(oPly, "ValidateTable["..stg.."]: Recursive type "..dep.." <"..type(val).."> fail", "ERROR", false) end
    else -- Process all the generals
      if(suc) then -- Make sure validating only successful records for faster recursion
        if(type(val) ~= par[1]) then -- Not having the experted type
          suc = NotifyUser(oPly, "ValidateTable["..stg.."]: Value type "..dep.." <"..type(val).."> fail", "ERROR", false) end
        if(type(val) == "Vector") then
          if(par[2] and not DecodeMargin(val:Length(), par[2])) then -- Vectors having zero length
            suc = NotifyUser(oPly, "ValidateTable["..stg.."]: Vector length "..dep.." <"..type(val).."> fail", "ERROR", false) end
        else
          if(par[2] and not DecodeMargin(val, par[2])) then -- The value is defined as invalid
            suc = NotifyUser(oPly, "ValidateTable["..stg.."]: Value "..dep.." <"..type(val).."> fail", "ERROR", false) end
        end
      end
    end
  end; return LogStatus("ValidateTable["..stg.."]: Validated > "..tostring(aName).." "..(suc and "OK" or "fail"), suc)
end

--[[
 * WireMixSetPoint: This function mixes the names types and
 * notes for the inputs given with the data provided by the
 * library variable /WIRE_REFERENCES/
 * tName > Wire inputs names list
 * tType > Wire inputs types list
 * tNote > Wire inputs notes list
]]--
function WireMixSetPoint(tName, tType, tNote)
  local tPorts = GetOpVar("WIRE_REFERENCES")
  local syItem = GetOpVar("OPSYM_ITEMSPLIT")
  local syInde = GetOpVar("OPSYM_GENINDENT")
  for ID = 1, #tName do
    local nm = tostring(tName[ID] or ""):Trim()
    local tp = tostring(tType[ID] or ""):Trim()
    local nt = tostring(tNote[ID] or ""):Trim()
    if(not IsEmptyString(nm) and not IsEmptyString(tp)) then
      tName[ID], tType[ID] = nm, tp
      if(not IsEmptyString(nt)) then tNote[ID] = (syInde..nt..syInde) else tNote[ID] = ""
        LogStatus("WireMixSetPoint: Skip processing notes <"..nm..">") end
    else return LogStatus("WireMixSetPoint: Failed processing output <"
      ..nm.."/"..tp.."/"..nt..">", false) end
  end
  for ID = 1, #tPorts.Name do
    local nm = tostring(tPorts.Name[ID] or ""):Trim()
    local tp = tostring(tPorts.Type[ID] or ""):Trim()
    local nt = tostring(tPorts.Note[ID] or ""):Trim()
    if(not IsEmptyString(nm) and not IsEmptyString(tp)) then
      table.insert(tName, nm); table.insert(tType, tp)
      if(not IsEmptyString(nt)) then table.insert(tNote, syInde..nt..syInde) else table.insert(tNote, "")
        LogStatus("WireMixSetPoint: Skip adding notes <"..nm..">") end
    else return LogStatus("WireMixSetPoint: Failed adding output <"
           ..nm.."/"..tp..">", false) end
  end; return LogStatus("WireMixSetPoint: Done", true)
end

--[[
 * NewConvarArray: Class long strings manager. Implements a convar array manager
 * A long string can be stored in beams with a given length
 * Names are stored using the convar name concatenated with the ID
 * I may be long, but I'm sure that you're gonna beam me up Scotty
 * sNam > The convar array base name
 * nCnt > Defines the length of the array
 * nLen > How many characters are gonna be stored in one cvar member
 * sInf > Convar information as what is the object used for
 * nFlg > Flags for the convars: http://wiki.garrysmod.com/page/Enums/FCVAR
]]--
function NewConvarArray(sNam, nCnt, nLen, sInf, nFlg)
  local mNam, mInf = (tostring(sNam  or ""):lower()), tostring(sInf or "")
  local mCnt, mLen = (tonumber(nCnt) or  0), (tonumber(nLen) or 0)
  if(IsEmptyString(mNam)) then return LogStatus("NewConvarArray: Name empty. "..mInf, nil) end
  if(mCnt <= 0) then return LogStatus("NewConvarArray: Beam count invalid <"..mNam.."> #"..mCnt, nil) end
  if(mLen <= 0) then return LogStatus("NewConvarArray: Bean length invalid <"..mNam..">"..mSiz, nil) end
  local mTab = {}
  if(nFlg ~= 0) then -- For custom behaviour
    for id = 1, mCnt do mTab[id] = CreateConVar(mNam.."_"..id, "", nFlg, mInf) end
  else -- This must behave like a client convar with user data enabled
    for id = 1, mCnt do mTab[id] = CreateClientConVar(mNam.."_"..id, mVal, true, true, mInf) end
  end
  local self = {}
  function self:GetValue(vD)
    local sD, sO = tostring(vD or ""), ""
    for id = 1, mCnt do sO = sO..sD..mTab[id]:GetString() end return sO
  end
  function self:GetName() return mNam end
  function self:GetInfo() return mInf end
  function self:GetCount() return mCnt end
  function self:GetLength() return mLen end
  function self:SetValue(sIn, vD)
    local sI, cE = tostring(sIn or ""), nil
    local sD, tE = tostring(vD  or ""), nil
    if(not IsEmptyString(sD)) then tE = sD:Explode(sI); cE = #tE else
      tE = {}
      local iS, iE = 1, mLen
      local sS, id = sIn:sub(iS, iE), 1
      while(sS and not IsEmptyString(sS)) do
        tE[id] = sS;
        iS, iE, id = (iS + mLen), (iE + mLen), (id + 1)
        sS = sIn:sub(iS, iE)
      end; cE = #tE
    end
    if(cE > mCnt) then return LogStatus("NewConvarArray: Array <"..mNam
      .."> shorter ["..sD.."] {"..cE.." > "..mCnt.."} for <"..sI..">", nil) end
    for id = 1, mCnt do
      local sB = tE[id]
      if(sB:len() > mLen) then
        return LogStatus("NewConvarArray: Array ["..id.."] <"..mNam.."> shorter {"
          ..sB:len().." > "..mLen.."} for <"..sB..">", nil) end
      mTab[id]:SetString(sB)
    end
  end; return self
end

--[[
 * NewSensor: Class sensors manager. Implements a sensor attachment
 * Ent > Entity the sensor is attached to
 * Len > Length of the sensor
 * Pos > Local position of the sensor
 * Dir > Local direction of the sensor
]]--
local mtSensor = {}
      mtSensor.__index = mtSensor
      mtSensor.__tostring = function(oSen) return "["..mtSensor.__type.."]"..
        " {E="..tostring(oSen:getEntity())..", L="..tostring(oSen:getLength())..
        ", O="..tostring(oSen:getOrigin())..", D="..tostring(oSen:getDirect()).."}" end
function NewSensor(sNam)
  local mNam = tostring(sNam or "") -- Name used to identify the thing
  if(IsEmptyString(mNam)) then return LogStatus("NewSensor: Name invalid", nil) end
  local mOrg = Vector() -- Local position relative to mEnt
  local mDir = Vector() -- Local direction relative to mEnt
  local mLen, mEnt = 0 -- Length and base attachment entity
  local mtTrC, mfTrace = {}  -- The tracer function to be used
  local self, mtTrO = {}, {} -- Define the member parameters
  local mtTrI = { -- This table stores the trace input information
    start  = Vector(),   -- Start position of the trace
    endpos = Vector(),   -- End   position of the trace
    mask   = MASK_SOLID, -- Mask telling it what to hit ( currently solid )
    output = mtTrO,      -- Trace result for avoiding table creation in real time
    filter = function(oEnt) -- Only valid props which are not the main entity or world or mtTrC
      if(oEnt and oEnt:IsValid() and oEnt ~= mEnt and -- The trace is not attachment and is valid
        (IsEmptyTable(mtTrC) or mtTrC[oEnt:GetClass()])) then return true end end }
  setmetatable(self, mtSensor)
  function self:getEntity() return mEnt end
  function self:getLength() return mLen end
  function self:getTrace()  return mtTrI end
  function self:isHit()     return mtTrO.Hit end
  function self:getFraction() return mtTrO.Fraction end
  function self:Sample() mfTrace(mtTrI); return self end
  function self:getOrigin() v = Vector(); v:Set(mOrg) return v end
  function self:getDirect() v = Vector(); v:Set(mDir) return v end
  function self:setTarget(sCls, bEn)
    mtTrC[tostring(sCls or ""):Trim()] = tobool(bEn); return self end
  function self:setTracer(fTrs)
    mfTrace = fTrs; if(type(mfTrace) ~= "function") then
      return LogStatus("NewSensor.setTracer: Tracer not function", nil) end; return self
  end
  function self:setEntity(oEnt) -- Load the base entity
    if(not (oEnt and oEnt:IsValid())) then
      return LogStatus("NewSensor.setEntity: Entity invalid <"..tostring(oEnt)..">", nil) end
    mEnt = oEnt; return LogStatus("NewSensor.setEntity("..tostring(mEnt)..") OK", self)
  end
  function self:setOrigin(vOrg) -- Load the local origin
    if(type(vOrg) ~= "Vector") then
      return LogStatus("NewSensor.setOrigin: Origin "..type(vOrg).." invalid <"..tostring(vOrg)..">", nil) end
    mOrg:Set(vOrg); return LogStatus("NewSensor.setOrigin("..tostring(mOrg)..") OK", self)
  end
  function self:setLength(nLen) -- Load the maximum length
    local nLen = (tonumber(nLen) or 0); if(nLen <= 0) then
      return LogStatus("NewSensor.setLength: Length invalid <"..tostring(nLen)..">", nil) end
    mLen = nLen; mDir:Normalize(); mDir:Mul(mLen); return LogStatus("NewSensor.setLength("..tostring(mLen)..") OK", self)
  end
  function self:setDirect(vDir) -- Load the direction
    if(type(vDir) ~= "Vector") then
      return LogStatus("NewSensor.setDirect: Direct "..type(vDir).." invalid <"..tostring(vDir)..">", nil) end
    if(not (mLen and mLen >= 0)) then
      return LogStatus("NewSensor.setDirect: Length invalid <"..tostring(mLen)..">", nil) end
    mDir:Set(vDir); mDir:Normalize(); mDir:Mul(mLen)
    return LogStatus("NewSensor.setDirect("..tostring(mDir)..") OK", self)
  end -- Uses custom ePos, eAng according to forward and up locals given
  function self:Update(cPos, cAng) -- Updates the trace parameters and gets ready to sample
    local oPos = GetPick(IsNil(cPos), mEnt:GetPos()   , cPos)    -- Custom center (pos)
    local oAng = GetPick(IsNil(cAng), mEnt:GetAngles(), cAng) -- Custom angle  (ucs)
    local vstr, vend = mtTrI.start, mtTrI.endpos
    vstr:Set(mOrg); vstr:Rotate(oAng); vstr:Add(oPos)
    vend:Set(mDir); vend:Rotate(oAng); vend:Add(vstr); return self
  end -- Executed in real-time. Performs a trace sensor update
  function self:Dump() -- The same as the setup method
    LogStatus("["..mtSensor.__type.."] Properties:")
    LogStatus("  Name  : "..tostring(mNam))
    LogStatus("  Entity: "..tostring(mEnt))
    LogStatus("  Origin: "..tostring(mOrg))
    LogStatus("  Direct: "..tostring(mDir))
    LogStatus("  Length: "..tostring(mLen))
    return self
  end
  function self:Validate()
    local oSta = self; if(mLen <= 0) then -- Start validation as valid status
      oSta = LogStatus("NewSensor.Validate: Length invalid <"..tostring(mLen)..">", nil) end
    if(mDir:Length() == 0) then -- Vector magnitude cannot be negative
      oSta = LogStatus("NewSensor.Validate: Direct invalid <"..tostring(mDir)..">", nil) end
    if(not (mEnt and mEnt:IsValid())) then
      oSta = LogStatus("NewSensor.Validate: Entity invalid <"..tostring(mEnt)..">", nil) end
    if(type(mtTrI) ~= "table") then
      oSta = LogStatus("NewSensor.Validate: Trace input invalid <"..type(mtTrI)..">", nil) end
    if(type(mtTrO) ~= "table") then
      oSta = LogStatus("NewSensor.Validate: Trace out invalid <"..type(mtTrO)..">", nil) end
    if(type(mfTrace) ~= "function") then
      oSta = LogStatus("NewSensor.Validate: Tracer invalid <"..type(mfTrace)..">", nil) end
    if(not oSta) then self:Dump() end -- Try to validate the object return it validated
    return LogStatus("NewSensor.Validate: Sensor <"..mNam.."> "..(oSta and "OK" or "fail"), oSta)
  end; return LogStatus("NewSensor: Create ["..mNam.."]", self) -- The sensor object
end

--[[
 * NewForcer: Class forcer manager. Implements a forcer attachment
 * Ent > Entity the forcer is attached to
 * Pos > Local position of the forcer
 * Dir > Local direction of the forcer
]]--
local mtForcer = {}
      mtForcer.__index = mtForcer
      mtForcer.__tostring = function(oSen) return "["..mtForcer.__type.."]"..
        " {E="..tostring(oSen:getEntity())..", O="..tostring(oSen:getOrigin())..", D="..tostring(oSen:getDirect()).."}" end
function NewForcer(sNam)
  local mNam = tostring(sNam or "") -- Name used to identify the thing
  if(IsEmptyString(mNam)) then return LogStatus("NewForcer: Name invalid", nil) end
  local mOrg = Vector() -- Local position of the forcer
  local mDir = Vector() -- Local direction of the force applied
  local fOrg = Vector() -- Force world-space origin position relative to custom center
  local fDir = Vector() -- Force world-space direction vector of the force applied
  local self, mEnt, mPhy = {} -- Define the member parameters and the local physics
  setmetatable(self, mtForcer)
  function self:getEntity() return mEnt end
  function self:getPhysics() return mPhy end
  function self:getOrigin() v = Vector(); v:Set(mOrg) return v end
  function self:getDirect() v = Vector(); v:Set(mDir) return v end
  function self:setEntity(oEnt) -- Load the base entity
    if(not (oEnt and oEnt:IsValid())) then
      return LogStatus("NewForcer.setEntity: Entity invalid <"..tostring(oEnt)..">", nil) end
    mEnt, mPhy = oEnt, oEnt:GetPhysicsObject()
    if(not (mPhy and mPhy:IsValid())) then
      return LogStatus("NewForcer.setEntity: Physics invalid <"..tostring(oEnt)..">", nil) end
    return LogStatus("NewForcer.setEntity("..tostring(mEnt)..") OK", self)
  end
  function self:setOrigin(vOrg) -- Load the local origin
    if(type(vOrg) ~= "Vector") then
      return LogStatus("NewForcer.setOrigin: Origin "..type(vOrg).." invalid <"..tostring(vOrg)..">", nil) end
    mOrg:Set(vOrg); return LogStatus("NewForcer.setOrigin("..tostring(mOrg)..") OK", self)
  end
  function self:setDirect(vDir) -- Load the direction
    if(type(vDir) ~= "Vector") then
      return LogStatus("NewForcer.setDirect: Direct "..type(vDir).." invalid <"..tostring(vDir)..">", nil) end
    mDir:Set(vDir); mDir:Normalize(); return LogStatus("NewForcer.setDirect("..tostring(mDir)..") OK", self)
  end -- Uses custom ePos, eAng according to forward and up locals given
  function self:Update(cPos, cAng) -- Updates the trace parameters and gets ready to sample
    local oPos = GetPick(IsNil(cPos), mEnt:GetPos()   , cPos) -- Custom center (pos)
    local oAng = GetPick(IsNil(cAng), mEnt:GetAngles(), cAng) -- Custom angle  (ucs)
    fOrg:Set(mOrg); fOrg:Rotate(oAng); fOrg:Add(oPos)
    fDir:Set(mDir); fDir:Rotate(oAng); return self
  end -- Executed in real-time. Performs position and direction update
  function self:Force(nAmt) fDir:Mul(tonumber(nAmt) or 0)
    mPhy:ApplyForceOffset(fDir, fOrg); return self
  end -- This method applies the offset force after update is performed on the forcer
  function self:Dump() -- The same as the setup method
    LogStatus("["..mtForcer.__type.."] Properties:")
    LogStatus("  Name  : "..tostring(mNam))
    LogStatus("  Entity: "..tostring(mEnt))
    LogStatus("  Origin: "..tostring(mOrg))
    LogStatus("  Direct: "..tostring(mDir))
    return self
  end
  function self:Validate()
    local oSta = self
    if(not (mEnt and mEnt:IsValid())) then
      oSta = LogStatus("NewForcer.Validate: Entity invalid <"..tostring(mEnt)..">", nil) end
    if(not (mPhy and mPhy:IsValid())) then
      oSta = LogStatus("NewForcer.Validate: Physics invalid <"..tostring(mEnt)..">", nil) end
    if(mDir:Length() == 0) then -- Vector magnitude cannot be negative
      oSta = LogStatus("NewForcer.Validate: Direct invalid <"..tostring(mDir)..">", nil) end
    if(not oSta) then self:Dump() end -- Try to validate the object return it validated
    return LogStatus("NewForcer.Validate: Forcer <"..mNam.."> "..(oSta and "OK" or "fail"), oSta)
  end; return LogStatus("NewForcer: Create ["..mNam.."]", self) -- The forcer object
end

--[[
 * NewControl: Class hovering state processing manager. Implements a controller unit
 * nTo   > Controller sampling time in seconds
 * sName > Controller hash name differentiation
]]--
local mtControl = {}
      mtControl.__index = mtControl
      mtControl.__tostring = function(oCon)
        return oCon:getType().."["..mtControl.__type.."] ["..tostring(oCon:getPeriod()).."]"..
          "{T="..oCon:getTune()..",W="..oCon:getWindup()..",P="..oCon:getPower().."}"
      end
function NewControl(nTo, sName)
  local mTo = (tonumber(nTo) or 0); if(mTo <= 0) then -- Sampling time [s]
    return LogStatus("NewControl: Sampling time <"..tostring(nTo).."> invalid",nil) end
  local self  = {}                 -- Place to store the methods
  local mfAbs = math.abs           -- Function used for error absolute
  local mfSgn = GetSign            -- Function used for error sign
  local mErrO, mErrN  = 0, 0       -- Error state values
  local mvCon, meInt  = 0, true    -- Control value and integral enabled
  local mvP, mvI, mvD = 0, 0, 0    -- Term values
  local mkP, mkI, mkD = 0, 0, 0    -- P, I and D term gains
  local mpP, mpI, mpD = 1, 1, 1    -- Raise the error to power of that much
  local mbCmb, mbInv, mbOn, mSatD, mSatU = true, false, true -- Saturation limits and settings
  local mName, mType, mTune, mWind, mPow = tostring(sName or "N/A"), "", "", "", ""
  setmetatable(self, mtControl)    -- Save the settings internally
  function self:getValue(kV,eV,pV) return (kV*mfSgn(eV)*mfAbs(eV)^pV) end
  function self:getGains() return mkP, mkI, mkD end
  function self:setEnInt(bSt) meInt = tobool(bSt); return self end
  function self:getEnInt() return meInt end
  function self:getError() return mErrO, mErrN end
  function self:getControl() return mvCon end
  function self:getTune() return mTune end
  function self:getWindup() return mWind end
  function self:getPower() return mPow end
  function self:getType() return mType end
  function self:getPeriod() return mTo end
  function self:setTune(sTune)
    local symComp = GetOpVar("OPSYM_COMPONENT")
    local sTune  = tostring(sTune or ""):Trim()
    local arTune = symComp:Explode(sTune)
    if(arTune[1] and (tonumber(arTune[1] or 0) > 0)) then
      mkP = (tonumber(arTune[1] or 0)) -- Proportional term
    else return LogStatus("NewControl.setTune: P-gain <"..tostring(arTune[1]).."> invalid",nil) end
    if(arTune[2] and (tonumber(arTune[2] or 0) > 0)) then
      mkI = (mTo / (2 * (tonumber(arTune[2] or 0)))) -- Discrete integral term approximation
      if(mbCmb) then mkI = mkI * mkP end
    else LogStatus("NewControl.setTune: I-gain <"..tostring(arTune[2]).."> skip") end
    if(arTune[3] and (tonumber(arTune[3] or 0) > 0)) then
      mkD = (tonumber(arTune[3] or 0) * mTo)  -- Discrete derivative term approximation
      if(mbCmb) then mkD = mkD * mkP end
    else LogStatus("NewControl.setTune: D-gain <"..tostring(arTune[3]).."> skip") end
    mType = ((mkP > 0) and "P" or "")..((mkI > 0) and "I" or "")..((mkD > 0) and "D" or "")
    -- Init multiple states using the table, so on duplication can be created easily
    mTune = tostring(sTune or ""); return LogStatus("NewControl.setTune: <"..tostring(sTune or "")..">", self)
  end
  function self:setWindup(sWind)
    local symComp = GetOpVar("OPSYM_COMPONENT")
    local sWind = tostring(sWind or ""):Trim()
    local arSat = symComp:Explode(sWind)
    if(arSat and tonumber(arSat[1]) and tonumber(arSat[2])) then
      arSat[1], arSat[2] = tonumber(arSat[1]), tonumber(arSat[2]) -- Saturation windup
      if(arSat[1] < arSat[2]) then
        mSatD, mSatU = arSat[1], arSat[2]
        LogStatus("NewControl.setWindup: Bounds {"..tostring(mSatD).."<"..tostring(mSatU).."} load")
      else LogStatus("NewControl.setWindup: Bounds {"..tostring(arSat[1]).."<"..tostring(arSat[2]).."} skip") end
    else LogStatus("NewControl.setWindup: Windup <"..tostring(sWind or "").."> skip") end
    mWind = tostring(sWind or ""); return LogStatus("NewControl.setWindup: OK", self)
  end
  function self:setPower(sPow)
    local symComp = GetOpVar("OPSYM_COMPONENT")
    local sPow  = tostring(sPow or ""):Trim()
    local arPow = symComp:Explode(sPow) -- Power ignored when missing
    if(arPow and tonumber(arPow[1]) and tonumber(arPow[2]) and tonumber(arPow[3])) then
      mpP = (tonumber(arPow[1]) or 1) -- Proportional power
      mpI = (tonumber(arPow[2]) or 1) -- Integral power
      mpD = (tonumber(arPow[3]) or 1) -- Derivative power
      LogStatus("NewControl.setPower: Power <"..tostring(mpP)..symComp..tostring(mpI)..symComp..tostring(mpD).."> load")
    else LogStatus("NewControl.setPower: Power <"..tostring(sPow or "").."> skip") end
    mPow = tostring(sPow or ""); return LogStatus("NewControl.setPower: OK", self)
  end
  function self:setFlags(bCmb, bInv)
    mbCmb, mbInv = tobool(bCmb), tobool(bInv)
    return LogStatus("NewControl.setFlags: OK", self) end
  function self:Toggle(bOn) -- Executed in realtime
    mbOn = tobool(bOn); return self end
  function self:Reset() -- Executed in realtime
    mErrO, mErrN, mvP, mvI, mvD, mvCon, meInt = 0, 0, 0, 0, 0, 0, true; return self end
  function self:Process(vRef,vOut) -- Executed in realtime
    if(not mbOn) then return self:Reset() end
    mErrO = mErrN -- Refresh error state sample
    mErrN = (mbInv and (vOut-vRef) or (vRef-vOut))
    if(mkP > 0) then -- P-Term
      mvP = self:getValue(mkP, mErrN, mpP) end
    if((mkI > 0) and (mErrN ~= 0) and meInt) then -- I-Term
      mvI = self:getValue(mkI, mErrN + mErrO, mpI) + mvI end
    if((mkD > 0) and (mErrN ~= mErrO)) then -- D-Term
      mvD = self:getValue(mkD, mErrN - mErrO, mpD) end
    mvCon = mvP + mvI + mvD  -- Calculate the control signal
    if(mSatD and mSatU) then -- Apply anti-windup effect
      if    (mvCon < mSatD) then mvCon, meInt = mSatD, false
      elseif(mvCon > mSatU) then mvCon, meInt = mSatU, false
      else meInt = true end
    end; return self
  end
  function self:Dump()
    local sLabel = GetPick(not IsEmptyString(mType), mType.."-", mType)
    LogStatus("["..sLabel..mtControl.__type.."] Properties:")
    LogStatus("  Name : "..mName.." ["..tostring(mTo).."]s")
    LogStatus("  Param: {"..mTune.."}")
    LogStatus("  Gains: {P="..tostring(mkP)..", I="..tostring(mkI)..", D="..tostring(mkD).."}")
    LogStatus("  Power: {P="..tostring(mpP)..", I="..tostring(mpI)..", D="..tostring(mpD).."}\n")
    LogStatus("  Limit: {D="..tostring(mSatD)..",U="..tostring(mSatU).."}")
    LogStatus("  Error: {"..tostring(mErrO)..", "..tostring(mErrN).."}")
    LogStatus("  Value: ["..tostring(mvCon).."] {P="..tostring(mvP)..", I="..tostring(mvI)..", D="..tostring(mvD).."}")
    return self -- The dump method
  end; return LogStatus("NewControl: Create ["..mName.."]", self) -- The control object
end

-- Checks if the record has a sensor object
function IsSensorRec(oRec)
  if(tonumber(oRec)) then return false end
  if(not (oRec and oRec.Obj)) then return false end
  return (getmetatable(oRec.Obj) == mtSensor)
end

-- Checks if the record has a sensor object
function IsForcerRec(oRec)
  if(tonumber(oRec)) then return false end
  if(not (oRec and oRec.Obj)) then return false end
  return (getmetatable(oRec.Obj) == mtForcer)
end

-- Checks if the record has a control object
function IsControlRec(oRec)
  if(tonumber(oRec)) then return false end
  if(not (oRec and oRec.Obj)) then return false end
  return (getmetatable(oRec.Obj) == mtControl)
end

--[[
 * Is the type enabled for an object
 * sTyp > Either general, sensor, forcer or control hash
]]--
function IsType(sTyp)
  local tCol = GetOpVar("TYPE_DEFCOLUMN")
  return ((tCol and sTyp) and tCol[sTyp])
end

--[[
 * Is the column name enabled for an object
 * sTyp > Either general, sensor, forcer or control hash
 * sCol > The name of the column to be checked
]]--
function IsHash(sTyp, sCol)
  local tTyp = IsType(sTyp)
  return ((tTyp and sCol) and tTyp[sCol])
end

function GetDescriptionID(vID)
  local tDes = GetOpVar("UNIT_DESCRIPTION")
  local nID = (tonumber(vID) or 0)
  return (tDes and tDes[nID] or nil)
end

function GetDescriptionSize()
  local tDes = GetOpVar("UNIT_DESCRIPTION")
  return (tDes and tDes.__size or 0)
end

function SetDescription(tData)
  local tDes = GetOpVar("UNIT_DESCRIPTION")
  local nSiz, nTot = tDes.__size, #tDes; if(nSiz ~= nTot) then
    return LogStatus("SetDescription: Stack mismatch <"..nSiz.."#"..nTot..">", false) end
  nSiz = nSiz + 1; tDes[nSiz] = tData; tDes.__size = nSiz
  return LogStatus("SetDescription: ["..nSiz.."]<"..tostring(tData.Name or "")..">"..tostring(tData.Prop or ""), false)
end

function InitConstants()
  libOpVars["LIBRARY_NAME"    ] = "hovermodlib"      -- Name of the library
  libOpVars["LIBRARY_VERSION" ] = "1.0"              -- General version of the whole thing
  libOpVars["GOLDEN_RATIO"    ] = 1.61803398875      -- Golden ration for panel resolution be more appealing
  libOpVars["OPSYM_GENINDENT" ] = " "                -- What symbol is used for indent spacing readability
  libOpVars["OPSYM_ITEMSPLIT" ] = "/"                -- Primary delimiter to split multiple string items by
  libOpVars["OPSYM_COMPONENT" ] = ","                -- Secondary delimiter to split individual item components
  libOpVars["OPSYM_INITSTRING"] = "@"                -- Trigger symbol for string source initialization ( including general settings )
  libOpVars["OPSYM_INITFILE"  ] = "$"                -- Trigger symbol for file source initialization ( including general settings )
  libOpVars["OPSYM_COMMENT"   ] = "#"                -- Trigger symbol for file source initialization ( including general settings )
  libOpVars["NAME_ENTITY"     ] = "hovermodule"      -- The entity name used for limits and stuff
  libOpVars["NAME_TOOL"       ] = "hovermoduletool"  -- The tool mode which operates the entity
  libOpVars["TYPE_GENERAL"    ] = "general"          -- General storage type for hover unit properties
  libOpVars["TYPE_SENSOR"     ] = "sensor"           -- The internal sensor type as string
  mtSensor.__type  = GetOpVar("TYPE_SENSOR")         -- Define local type for usage inside OOP sensors
  libOpVars["TYPE_FORCER"     ] = "forcer"           -- The internal forcer type as string
  mtForcer.__type  = GetOpVar("TYPE_FORCER")         -- Define local type for usage inside OOP forcers
  libOpVars["TYPE_CONTROL"    ] = "control"          -- The internal control type as string
  mtControl.__type = GetOpVar("TYPE_CONTROL")        -- Define local type for usage inside OOP control
  libOpVars["HASH_ENTITY"     ] = "HoverDataMD"      -- Where in the entity the data is stored
  libOpVars["LOCALIFY_AUTO"   ] = "en"               -- Default translation if a phrase is now found
  libOpVars["MISS_NOID"       ] = "N"                -- No ID selected
  libOpVars["MISS_NOAV"       ] = "N/A"              -- Not Available
  libOpVars["MISS_NOMD"       ] = "X"                -- No model
  libOpVars["MISS_NOTR"       ] = "Oops, missing ?"  -- No translation found
end

--[[
 * Compiles a user-defined state deviation from a string
 * sErr  > The error deviation given as a sensor hash formula
 * sCon  > The state name that its error will be defined this way
 * stSen > The sensor structure used to compile the error function
]]--
function GetDeviation(sErr, sCon, stSen)
  local sCo = tostring(sCon):rep(1):Trim() -- Copy a temporary error selection
  local sDv = tostring(sErr):rep(1):Trim()
  for key, sen in pairs(stSen) do
    if(type(sen) == "table" and IsString(key)) then
      sDv = sDv:gsub(key, "oSens[\""..tostring(key).."\"].Val") end end
  local sFc = "return (function(oSens) "..sDv.." end)"
  local suc1, out1 = pcall(CompileString, sFc, GetOpVar("FILE_ENTITY").."_"..sCo); if(not suc1) then
    return LogStatus("GetDeviation("..sCo.."): Failed primary <"..sFc.."> @"..tostring(out1), nil) end
  local suc2, out2 = pcall(out1); if(not suc2) then
    return LogStatus("GetDeviation("..sCo.."): Failed secondary <"..sFc.."> @"..tostring(out2), nil) end
  return LogStatus("GetDeviation("..sCo.."): <"..sFc..">", out2)
end

--[[
 * Updates the target hit list with additional classes if the file is provided
 * Automatically loads <library_name>_hit.txt into the class target list
 * bRep > Whenever to replace the internal class targets with the file or not
]]--
function InitTargetsHit(bRep)
  local tTrgs, lbNam = GetOpVar("CLASS_TARGETS"), GetOpVar("LIBRARY_NAME")
  local fName = GetOpVar("DIRPATH_BASE")..lbNam.."_hit.txt"
  local S = file.Open(fName, "rb", "DATA")
  if(S) then local isEOF, sLine = false, ""
    if(bRep) then for key, _ in pairs(tTrgs) do tTrgs[key] = nil end end
    while(not isEOF) do sLine, isEOF = GetStringFile(S)
      if(not IsEmptyString(sLine)) then tTrgs[sLine] = true end end
    S:Close(); return LogStatus("InitTargetsHit: OK <"..fName..">", true)
  else return LogStatus("InitTargetsHit: Missing <"..fName..">", true) end
end

--[[
 * Tells the library which log outputs must be skipped
 * Automatically loads <library_name>(_slskip/_slonly).txt into the log skip settings
 * bRep > Whenever to replace the internal class targets with the file or not
]]--
function SettingsLogs(sHash)
  local sKey = tostring(sHash or ""):upper():Trim()
  if(not (sKey == "SKIP" or sKey == "ONLY")) then
    return LogStatus("SettingsLogs("..sKey.."): Invalid hash", false) end
  local tLogs, lbNam = GetOpVar("LOG_SETTINGS")[sKey], GetOpVar("LIBRARY_NAME")
  if(not tLogs) then return LogStatus("SettingsLogs("..sKey.."): Skip table", true) end
  local fName = GetOpVar("DIRPATH_BASE")..lbNam.."_sl"..sKey:lower()..".txt"
  local S = file.Open(fName, "rb", "DATA"); table.Empty(tLogs)
  if(S) then local sLine, isEOF = "", false
    while(not isEOF) do sLine, isEOF = GetStringFile(S)
      if(not IsEmptyString(sLine)) then table.insert(tLogs, sLine) end
    end; S:Close(); return LogStatus("SettingsLogs("..sKey.."): Success <"..fName..">", true)
  else return LogStatus("SettingsLogs("..sKey.."): Missing <"..fName..">", true) end
end

--[[
 * ConvertTraceTargets: Prepares a list of targets for a wet job
 * Retrieves the table hash hit list and hires the hit-man :D
 * You must be very careful when using this function as SO can get hurt !
 * But seriously: Converts "prop/ test " to {["prop"] = true, ["test"] = true}
 * If no arguments are provided or an empty string, uses CLASS_TARGETS
 * sCls > The string to convert to a hash format
 * tHit > Hit targets table to use if provided
 * bHit > Whenever or not to use the global hit targets
]]--
function ConvertTraceTargets(sCls, bHit, tHit)
  local sCls = tostring(sCls or "")
  local tArg = GetPick(type(tHit)=="table",tHit,GetOpVar("CLASS_TARGETS"))
  local tSrc = GetPick(bHit,tArg,{})
  if(not IsEmptyString(sCls)) then
    tSrc = GetOpVar("OPSYM_ITEMSPLIT"):Explode(tostring(sCls))
    for ID = 1, #tSrc do -- Kill targets sequentially in order
      tSrc[tSrc[ID]:Trim()] = true; tSrc[ID] = nil end
  end -- Hire the hit-man to do the wet job
  local tHit = {}  -- How many targets are there
  for key, val in pairs(tSrc) do tHit[key] = tSrc[key] end
  return tHit -- Report to the agency
end

--[[
  * Transforms a setup line to initialization table
  * sLine  > The line to transform
  * tBase  > Base table to store the stuff
  * tSeq   > A place where the sequential type ID is stored
]]--
function TransformSettings(sLine, tBase, tSeq) -- Mecha henshin !
  local sBase, cnt, tab, typ, key = sLine:Trim(), 1, 0
  if(sBase:sub(1,1) == GetOpVar("OPSYM_COMMENT")) then return true end
  for v in sBase:gmatch("{(.-)}") do -- All the items in curly brackets
    local exp = (":"):Explode(v) -- Explode on : to get key-value pairs
    local fld = tostring(exp[1] or ""):Trim(); if(IsEmptyString(fld)) then
      return LogStatus("TransformSettings: Key missing <["..tostring(cnt).."],"..sBase..">", false) end
    local val = tostring(exp[2] or ""):Trim(); if(IsEmptyString(val)) then
      return LogStatus("TransformSettings: Value missing <["..tostring(cnt).."]["..fld.."],"..sBase..">", false) end
    if(cnt == 1) then
      typ, key = fld, val; if(not IsType(typ)) then
        return LogStatus("TransformSettings: Type ["..tostring(cnt).."] <"..fld.."> missing", false) end
      if(not tBase[typ]) then tBase[typ] = {} end
      if(not tSeq[typ]) then tSeq[typ] = 0 end; tSeq[typ] = tSeq[typ] + 1
      tBase[typ][key] = {}; tab = tBase[typ][key]; tab["ID"] = tSeq[typ]
    else -- Register the data in the column provided
      if(IsHash(typ, fld)) then tab[fld] = val:Trim()
      else LogStatus("TransformSettings: Column <"..fld.."> ["..typ.."]"..key.." skipped") end
    end; cnt = cnt + 1
  end; return true
end

--[[
 * Does a post-processing of an initialization parametrization
 * tSet  > A value set table to be processed
 * tgHit > If the hit list is not available for the sensor use the global one
 * bgHit > Flag for using the global table or not
]]--
function PostProcessInit(oPly, tSet, tgHit, bgHit)
  if(CLIENT) then
    return LogStatus("PostProcessInit: Working on client", false) end
  if(not (tSet and type(tSet) == "table")) then
    return LogStatus("PostProcessInit: Set missing", false) end
  local syItem = GetOpVar("OPSYM_ITEMSPLIT")
  local tSen = tSet[GetOpVar("TYPE_SENSOR")]
        tSen = ((type(tSen) == "table") and (next(tSen) and tSen or nil) or nil)
  local tFrc = tSet[GetOpVar("TYPE_FORCER")]
        tFrc = ((type(tFrc) == "table") and (next(tFrc) and tFrc or nil) or nil)
  local tCon = tSet[GetOpVar("TYPE_CONTROL")]
        tCon = ((type(tCon) == "table") and (next(tCon) and tCon or nil) or nil)
  if(tSen) then
    for key, rec in pairs(tSen) do -- Process sensors
      if(not tonumber(rec)) then
        rec["ID"]  = (tonumber(rec["ID"]) or 0); if(rec["ID"] < 1) then
          return LogStatus("PostProcessInit: Sensor <"..key.."> invalid ID", false) end
        rec["Len"] = (tonumber(rec["Len"]) or 0)
        if(not (rec["Len"] and math.abs(rec["Len"]) ~= 0)) then
          return LogStatus("PostProcessInit: Sensor <"..key.."> invalid length", false) end
        rec["Org"], rec["Val"] = GetVectorString(rec["Org"]), 0
        rec["Dir"] = GetVectorString(rec["Dir"])
        if(rec["Dir"] and rec["Dir"]:Length() == 0) then
          return NotifyUser(oPly, "PostProcessInit: Sensor <"..key.."> invalid direct", "ERROR", false) end
        rec["Hit"] = ConvertTraceTargets(rec["Hit"],bgHit,tgHit)
      end
    end
  else LogStatus("PostProcessInit: Sensors skip") end
  if(tFrc) then
    for key, rec in pairs(tFrc) do -- Process forcers
      if(not tonumber(rec)) then
        rec["ID"]  = (tonumber(rec["ID"]) or 0); if(rec["ID"] < 1) then
          return LogStatus("PostProcessInit: Forcer <"..key.."> invalid ID", false) end
        rec["Dir"] = GetVectorString(rec["Dir"])
        if(rec["Dir"] and rec["Dir"]:Length() == 0) then
          return NotifyUser(oPly, "PostProcessInit: Forcer <"..key.."> invalid direct", "ERROR", false) end
        rec["Org"] = GetVectorString(rec["Org"])
      end
    end
  else LogStatus("PostProcessInit: Forcers skip")end
  if(tSen and tFrc and tCon) then
    for key, rec in pairs(tCon) do -- Process controllers
      if(not tonumber(rec)) then
        rec["Tun"] = syItem:Explode(rec["Tun"])
        for k, v in pairs(rec["Tun"]) do rec["Tun"][k] = tostring(v or ""):Trim() end
        rec["Cmb"], rec["Neg"] = tobool(rec["Cmb"]), tobool(rec["Neg"])
        rec["ID"]  = (tonumber(rec["ID"]) or 0); if(rec["ID"] < 1) then
          return LogStatus("PostProcessInit: Controller <"..key.."> invalid ID", false) end
        rec["Ref"]    = syItem:Explode(rec["Ref"])
        rec["Ref"][1] = tonumber((rec["Ref"][1]):Trim()) or 0
        rec["Ref"][2] = tostring(rec["Ref"][2] or ""):Trim()
        rec["Ref"][2] = GetPick(not IsEmptyString(rec["Ref"][2]),rec["Ref"][2],nil)
        rec["Dev"] = GetDeviation(rec["Prs"], key, tSen) -- Define the deviation function for the error
        rec["Tar"] = syItem:Explode(tostring(rec["Tar"])) -- Forcer mapping for every control
        for k, v in pairs(rec["Tar"]) do rec["Tar"][k] = tostring(v or ""):Trim() end
      end
    end
  else return LogStatus("PostProcessInit: Control missing", false) end
  return LogStatus("PostProcessInit: OK", true)
end

--[[
 * Creates an initialization structure from three sources
 * srSet > A source set to be used either $file or @string
 * sgHit > A trace targets list string to be used if a sensor has none
 * bgHit > Whenever to use the global hit list or not
]]--
function InitializeUnitSource(oPly, srSet, sgHit, bgHit)
  local sHit = tostring(sgHit or ""):Trim()
  local sSet, tSet = tostring(srSet or ""):Trim(), {}
  local tHit, sMod = ConvertTraceTargets(sHit,bgHit), sSet:sub(1,1)
  local mdFil, mdStr = GetOpVar("OPSYM_INITFILE"), GetOpVar("OPSYM_INITSTRING")
  if(sMod == mdFil) then -- Use a file
    local sNm = sSet:sub(2,-1); if(IsEmptyString(sNm)) then
      return LogStatus("InitializeUnitSource(F): File name empty",nil) end
    if(not sNm:find(".txt", 1, true)) then sNm = sNm..".txt" end
    if(not file.Exists(sNm, "DATA")) then
      return LogStatus("InitializeUnitSource(F): File missing: "..sNm,nil) end
    local ioF = file.Open(sNm, "rb", "DATA"); if(not ioF) then
      return LogStatus("InitializeUnitSource(F): File failed <"..tostring(sNm)..">",nil) end
    local ln, eof, seq  = "", false, {}
    while(not eof) do ln, eof = GetStringFile(ioF)
      if(not IsEmptyString(ln)) then
        if(not TransformSettings(ln, tSet, seq)) then
          return LogStatus("InitializeUnitSource(F): Transform failed <"..ln..">",nil) end
      end
    end; ioF:Close()
    if(not PostProcessInit(oPly, tSet, tHit, bgHit)) then
      return LogStatus("InitializeUnitSource(F): Post-process fail", nil) end
    collectgarbage(); return LogStatus("InitializeUnitSource(F): OK", tSet)
  elseif(sMod == mdStr) then
    local ini, seq = mdStr:Explode(sSet:sub(2,-1)), {}
      for cnt  = 1, #ini, 1 do local ln = ini[cnt]:Trim()
        if(not IsEmptyString(ln)) then
          if(not TransformSettings(ln, tSet, seq)) then
            return LogStatus("InitializeUnitSource(S): Transform failed <"..ln..">",nil) end
        end
      end
    if(not PostProcessInit(oPly, tSet, tHit, bgHit)) then
      return LogStatus("InitializeUnitSource(S): Post-process fail", nil) end
    collectgarbage(); return LogStatus("InitializeUnitSource(S): OK", tSet)
  else return LogStatus("InitializeUnitSource: Mode missed <"..sMod..">", nil) end
end

--[[
 * Exports a set of hover module controls
 * into array of initialization strings
 * sKey  > The sensor name/key to export
 * stCon > The sensor structure to be exported
 * tData > Where is the data stored
]]--
local function ExportSensor(sKey, stSen, tData)
  local tyArg = type(stSen); if(tyArg ~= "table") then
    return LogStatus("ExportSensor: Argument <"..tyArg.."> mismatch", false) end
  local symCp = GetOpVar("OPSYM_COMPONENT")
  local org, dir, len = stSen["Org"], stSen["Dir"], stSen["Len"]
  local sLin ,  ID = "{"..GetOpVar("TYPE_SENSOR")..":"..sKey.."}", (#tData + 1)
        sLin = sLin.."{Len:"..tostring(len).."}"
        sLin = sLin.."{Org:"..tostring(org.x)..symCp..tostring(org.y)..symCp..tostring(org.z).."}"
        sLin = sLin.."{Dir:"..tostring(dir.x)..symCp..tostring(dir.y)..symCp..tostring(dir.z).."}"
  local lst = ""; for hit, _ in pairs(stSen["Hit"]) do lst = lst.."/"..tostring(hit) end
        lst = lst:sub(2,-1); sLin = sLin..GetPick(IsEmptyString(lst), "", "{Hit:"..lst.."}")
  tData[ID] = sLin; ID = ID + 1; sLin = ""; return true
end

--[[
 * Exports a set of hover module controls
 * into array of initialization strings
 * sKey  > The control name/key to export
 * stCon > The control structure to be exported
 * tData > Where is the data stored
]]--
local function ExportControl(sKey, stCon, tData)
  local tyArg = type(stCon); if(tyArg ~= "table") then
    return LogStatus("ExportControl: Argument <"..tyArg.."> mismatch", false) end
  local symItem = GetOpVar("OPSYM_ITEMSPLIT")
  local cmb, neg, ref = stCon["Cmb"], stCon["Neg"], stCon["Ref"]
  local tun, prs, tar = stCon["Tun"], stCon["Prs"], stCon["Tar"]
  local sLin, ID = "{"..GetOpVar("TYPE_CONTROL")..":"..sKey.."}", (#tData + 1)
        sLin = sLin.."{Cmb:"..tostring(cmb):Trim().."}"
        sLin = sLin.."{Neg:"..tostring(neg):Trim().."}"
        sLin = sLin.."{Tar:"; for i = 1, #tar do
        sLin = sLin..tostring(tar[i]):Trim()..symItem end; sLin = sLin:sub(1,-2).."}"
        sLin = sLin.."{Ref:"..tostring(ref[1] or ""):Trim()
          ..symItem..GetPick(ref[2], tostring(ref[2]), ""):Trim().."}"
        sLin = sLin.."{Tun:"..tostring(tun[1] or ""):Trim()..
            symItem..tostring(tun[2] or ""):Trim()..
            symItem..tostring(tun[3] or ""):Trim().."}"
        sLin = sLin.."{Prs:"..tostring(prs):Trim().."}"
  tData[ID] = sLin; ID = ID + 1; sLin = ""; return true
end

--[[
 * Exports a set of hover module general settings ( properties )
 * into array of initialization strings
 * sKey  > The property name/key to export
 * stGen > The property structure to be exported
 * tData > Where is the data stored
]]--
local function ExportGeneral(sKey, stGen, tData)
  local tyArg = type(stGen); if(tyArg ~= "table") then
    return LogStatus("ExportGeneral: Argument <"..tyArg.."> mismatch", false) end
  local sLin, ID = "{"..GetOpVar("TYPE_GENERAL")..":"..sKey.."}", (#tData + 1)
  if(type(stGen.Val) == "Vector") then local vVal = stGen.Val
    sLin = sLin.."{Val:"..tostring(vVal.x)..","..tostring(vVal.y)..","..tostring(vVal.z).."}"
  else sLin = sLin.."{Val:"..tostring(stGen.Val).."}" end
  tData[ID] = sLin; return true
end

--[[
 * Exports a set of hover module forcer settings
 * into array of initialization strings
 * sKey  > The force name/key to export
 * stFor > The force structure to be exported
 * tData > Where is the data stored
]]--
local function ExportForcer(sKey, stFor, tData)
  local tyArg = type(stFor)
  if(tyArg ~= "table") then return LogStatus("ExportForcer: Argument <"..tyArg.."> mismatch", false) end
  local org, dir, symCp = stFor["Org"], stFor["Dir"], GetOpVar("OPSYM_COMPONENT")
  local sLin, ID = "{"..GetOpVar("TYPE_FORCER")..":"..sKey.."}", (#tData + 1)
        sLin = sLin.."{Org:"..tostring(org.x)..symCp..tostring(org.y)..symCp..tostring(org.z).."}"
        sLin = sLin.."{Dir:"..tostring(dir.x)..symCp..tostring(dir.y)..symCp..tostring(dir.z).."}"
  tData[ID] = sLin; return true
end

--[[
 * Orders structure hash keys by item /ID/ containment
 * Returns a table of ordered sequential keys
 * stSet    > The source table for the report
 * tRep.All > The number of all keys existing
 * tRep.Int > The number of integer keys existing
 * tRep.Cnt > The number of keys without holes
 * tRep.Key > The list of keys (ordered)
 * tRep.Ord > The list of IDs (ordered) (not needed)
]]--
local function GetKeyReportID(stSet)
  local tRep, cnt = {Cnt = #stSet, Int = 0, All = 0, Key = {}, Ord = {}}, 1
  for k, v in pairs(stSet) do
    tRep.All = tRep.All + 1
    if(type(v) == "table") then
      local id = (tonumber(v.ID) or 0)
      if(id and id > 0) then
        tRep.Key[cnt], tRep.Ord[cnt] = k, id; cnt = cnt + 1
      else return LogStatus("GetKeyReportID: Unsortable <"..tostring(k)..","..tostring(v.ID)..">", nil) end
    elseif(type(k) == "number") then tRep.Int = tRep.Int + 1 end
  end; cnt = 1 -- Direct selection sort
  while(tRep.Key[cnt]) do
    for ind = cnt+1, #tRep.Ord, 1 do
      local ord, key = tRep.Ord, tRep.Key
      if(ord[ind] < ord[cnt]) then
        key[cnt], key[ind] = key[ind], key[cnt]
        ord[cnt], ord[ind] = ord[ind], ord[cnt]
      end
    end; cnt = cnt + 1
  end; tRep.Ord = nil; return tRep
end

--[[
 * Exports a set of hover module settings
 * into array of initialization strings
 * stSet > A table set to export
 * sType > The set type either /sensor/, /forcer/, /control/ or /general/
]]--
function ExportInitString(stSet, sType)
  if(not (stSet and type(stSet) == "table")) then
    return LogStatus("ExportInitString: Set definition missing", nil) end
  local tRep, tSet, cnt, typ = GetKeyReportID(stSet), {}, 1, tostring(sType)
  if(not tRep) then return LogStatus("ExportInitString: Sort by ID fail", nil) end
  local tExp = {[GetOpVar("TYPE_GENERAL")] = ExportGeneral,
                [GetOpVar("TYPE_SENSOR")]  = ExportSensor ,
                [GetOpVar("TYPE_FORCER")]  = ExportForcer ,
                [GetOpVar("TYPE_CONTROL")] = ExportControl}
  if(not IsType(sType)) then return LogStatus("ExportInitString: Invalid type <"..typ..">", nil) end
  while(tRep.Key[cnt]) do
    local key = tRep.Key[cnt]
    local val = stSet[key]
    tExp[sType](key, val, tSet); cnt = cnt + 1
  end; return tSet
end

--[[
 * This function updates the general settings to the specifies fields.
 * When they are read from the file they are strings and must be converted
 * stHoverData > The hover module initialization data to be updated
 * tGen        > The general setting we need to update the structure with
]]--
function SetGeneralTable(stHoverData, tGen, bReplace)
  local tMap = GetOpVar("MAPPING_GENERAL")
  for key, rec in pairs(tGen) do
    local map = tMap[key]
    local col, foo = map[1], map[3]
    if(bReplace and type(col) == "string") then
      if(type(foo) == "function") then
           stHoverData[col] = foo(rec.Val)
      else stHoverData[col] = rec.Val end
    end
  end
end

--[[
 * Creates a general purpose table based on non-list entity fields
 * This table is later used for exporting the general setting into a file
 * eHov > The hover entity to be extracted
]]--
function GetGeneralTable(eHov)
  local sCls = GetOpVar("FILE_ENTITY")
  local tGen = GetOpVar("MAPPING_GENERAL")
  local sHas = GetOpVar("HASH_ENTITY")
  if(not (eHov and eHov:IsValid() and eHov:GetClass() == sCls)) then
    return LogStatus("GetGeneralTable: Entity invalid <"..tostring(eHov)..">") end
  local hovData = eHov[sHas]
  local tExp = {}; for key, val in pairs(tGen) do
    tExp[key] = {Val = hovData[val[1]], ID = val[2]} end
  return tExp
end

--[[
 * Exports a hover module unit setting into a file
 * eHov  > The hover module entity
 * sFile > The file to export the settings to
]]--
function ExportUnitSource(eHov, sFile)
  if(not (eHov and eHov:IsValid())) then
    return LogStatus("ExportUnitSource: Hover module invalid", nil) end
  local sMag, sEnt = eHov:GetClass(), GetOpVar("FILE_ENTITY")
  if(sMag ~= sEnt) then -- If another entity is given
    return LogStatus("ExportUnitSource: Hover class <"..sMag.."> invalid", nil) end
  local sNm = tostring(sFile or "default"); if(IsEmptyString(sNm)) then
    return LogStatus("ExportUnitSource: File name empty", nil) end
  if(not sNm:find(".txt", 1, true)) then sNm = sNm..".txt" end
  local ioF = file.Open(sNm, "wb", "DATA"); if(not ioF) then
    return LogStatus("ExportUnitSource: Failed to open file <"..sNm..">", nil) end
  local sKey, ID = GetOpVar("HASH_ENTITY"), 1
  local tData = {ExportInitString(GetGeneralTable(eHov), GetOpVar("TYPE_GENERAL")),
                 ExportInitString(eHov[sKey].Sensors   , GetOpVar("TYPE_SENSOR")) ,
                 ExportInitString(eHov[sKey].Forcers   , GetOpVar("TYPE_FORCER")) ,
                 ExportInitString(eHov[sKey].Control   , GetOpVar("TYPE_CONTROL"))}
  while(tData[ID]) do
    local tSet, ST = tData[ID], 1
    while(tSet[ST]) do
      ioF:Write(tostring(tSet[ST]).."\n"); ST = ST + 1
    end; ioF:Write("\n"); ID = ID + 1
  end; ioF:Flush() ioF:Close()
end

function NotifyUser(pPly,sMsg,sTyp,...)
  if(SERVER) then -- Send notification to client that something happened
    pPly:SendLua("GAMEMODE:AddNotify(\""..tostring(sMsg).."\", NOTIFY_"..tostring(sTyp)..", 6)")
    pPly:SendLua("surface.PlaySound(\"ambient/water/drip"..math.random(1, 4)..".wav\")")
  end; return ...
end

local function onHoverModuleRemove(ent, ...)
  local remID = {...}; for k, v in pairs(remID) do numpad.Remove(v) end
  LogStatus("onHoverModuleRemove: Numpad removed <"..tostring(ent)..">")
end

function NewHoverModule(oPly, vPos, aAng, stHoverData)
  local sLimit = GetOpVar("NAME_ENTITY"); if(not oPly:CheckLimit(sLimit)) then
    return LogStatus("NewHoverModule: Hover module limit <"..sLimit.."> reached", nil) end
  local eDye = GetPick(stHoverData.Dye,stHoverData.Dye,Color(255, 255, 255, 255))
  local sNam = GetOpVar("NAME_TOOL")                -- Get the creator tool
  local eHov = ents.Create(GetOpVar("FILE_ENTITY")) -- Create the thing
  if(eHov and eHov:IsValid()) then                  -- Setup the module entity if valid
    eHov:SetPos(vPos)                               -- Set position
    eHov:SetAngles(aAng)                            -- Set orientation
    eHov:SetModel(stHoverData.Prop)                 -- Use the model given
    eHov:Spawn()                                    -- Make the ENT:Initialize run once
    eHov:SetPlayer(oPly)                            -- Set the player who has spawned it
    eHov:SetColor(eDye)                             -- Apply the color if given
    eHov:SetRenderMode(RENDERMODE_TRANSALPHA)       -- Use the alpha of the color given
    eHov:SetCollisionGroup(COLLISION_GROUP_NONE)    -- Normal collision: https://wiki.garrysmod.com/page/Enums/COLLISION
    eHov:SetNotSolid(false)                         -- Make it collide like a solid
    eHov:CallOnRemove("HoverModuleNumpadCleanup", onHoverModuleRemove,
      numpad.OnDown(oPly, stHoverData.KeyOn, sNam.."_Power_On"        , eHov ),
      numpad.OnDown(oPly, stHoverData.KeyF , sNam.."_ForceForward_On" , eHov ),
      numpad.OnUp  (oPly, stHoverData.KeyF , sNam.."_ForceForward_Off", eHov ),
      numpad.OnDown(oPly, stHoverData.KeyR , sNam.."_ForceReverse_On" , eHov ),
      numpad.OnUp  (oPly, stHoverData.KeyR , sNam.."_ForceReverse_Off", eHov ))
    if(not eHov:Setup(stHoverData)) then eHov:Remove() -- Setup the data and controllers
      return LogStatus("NewHoverModule: Setup module invalid", nil) end
    eHov:Activate()                                 -- Start ENT:Think method run in real-time
    oPly:AddCount  (sLimit, eHov)                   -- Register entity to the max count
    oPly:AddCleanup(sLimit, eHov)                   -- Register entity to the clean-up list
    return LogStatus("NewHoverModule: OK <"..tostring(eHov)..">", eHov);
  end; return LogStatus("NewHoverModule: Entity invalid", nil)
end

function GetPhrase(sKey)
  local sDef = GetOpVar("MISS_NOTR")
  local tSet = GetOpVar("LOCALIFY_TABLE")
  local sKey = tostring(sKey) if(IsNil(tSet[sKey])) then
    LogStatus("Miss <"..sKey..">"); return GetOpVar("MISS_NOTR") end
  return (tSet[sKey] or GetOpVar("MISS_NOTR")) -- Translation fail safe
end

local function GetLocalify(sCode)
  local sCode = tostring(sCode or GetOpVar("MISS_NOAV"))
  if(not CLIENT) then return LogStatus("("..sCode..") Not client", nil) end
  local sTool, sLimit = GetOpVar("NAME_TOOL"), GetOpVar("NAME_LIMIT")
  local sPath = GetOpVar("FORM_LANGPATH"):format("", sCode..".lua") -- Translation file path
  if(not file.Exists("lua/"..sPath, "GAME")) then
    return LogStatus("("..sCode..") Missing", nil) end
  local fCode = CompileFile(sPath); if(not fCode) then
    return LogStatus("("..sCode..") No function", nil) end
  local bFunc, fFunc = pcall(fCode); if(not bFunc) then
    return LogStatus("("..sCode..")[1] "..fFunc, nil) end
  local bCode, tCode = pcall(fFunc, sTool, sLimit); if(not bCode) then
    return LogStatus("("..sCode..")[2] "..tCode, nil) end
  return tCode -- The successfully extracted translations
end

function InitLocalify(sCode)
  local cuCod = tostring(sCode or GetOpVar("MISS_NOAV"))
  if(not CLIENT) then return LogStatus("("..cuCod..") Not client", nil) end
  local thSet = GetOpVar("LOCALIFY_TABLE"); table.Empty(thSet)
  local auCod = GetOpVar("LOCALIFY_AUTO") -- Automatic translation code
  local auSet = GetLocalify(auCod); if(not auSet) then
    return LogStatus("Base mismatch <"..auCod..">", nil) end
  if(cuCod ~= auCod) then local cuSet = GetLocalify(cuCod)
    if(cuSet) then -- When the language infornation is extracted apply on success
      for key, val in pairs(auSet) do auSet[key] = (cuSet[key] or auSet[key]) end
    else LogStatus("Custom skipped <"..cuCod..">") end -- Apply auto code
  end; for key, val in pairs(auSet) do thSet[key] = auSet[key]; language.Add(key, val) end
end
