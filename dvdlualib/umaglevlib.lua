--[[
 * Label    : Module for maglev base functionality
 * Author   : DVD ( dvd_video )
 * E-mail   : dvd_video@abv.bg
 * Date     : 19-01-2017
 * Location : lua/maglev/umaglevlib.lua
 * Defines  : A list of functions for initializing a maglev
]]--

if(SERVER) then
  AddCSLuaFile("maglev/umaglevlib.lua")
end

local file = {}
local bit                   = bit
local type                  = function(any)
  local t = type(any)
  if(t == "table") then
    local mt = getmetatable(any)
    return mt and mt.__type or t
  end
  return t
end
local languageGetPhrase     = languageGetPhrase
local CompileString         = CompileString
local tobool                = tobool
local next                  = next
local print                 = print
local pairs                 = pairs
local tostring              = tostring
local tonumber              = tonumber
local SysTime               = SysTime
local CreateConVar          = CreateConVar
local Vector                = Vector
local Angle                 = Angle
local Color                 = Color
local setmetatable          = setmetatable
local getmetatable          = getmetatable
local collectgarbage        = collectgarbage
local LocalPlayer           = LocalPlayer
local fileAppend            = fileAppend
local fileExists            = fileExists
local fileOpen              = fileOpen
local osDate                = os and os.date
local mathAbs               = math and math.abs
local mathModf              = math and math.modf
local mathClamp             = math and math.Clamp
local stringExplode         = string and string.Explode
local stringUpper           = string and string.upper
local tableGetMax           = table and table.getn
local tableConcat           = table and table.concat
local inputIsKeyDown        = input and input.IsKeyDown
local renderDrawLine        = render and render.DrawLine
local renderDrawSphere      = render and render.DrawSphere
local renderSetColorMaterial = render and render.SetColorMaterial
local duplicatorRegisterEntityClass = duplicator and duplicator.RegisterEntityClass

file.Open   = fileOpen
file.Exists = fileExists 

local CLIENT = CLIENT
local SERVER = SERVER

local KEY_LSHIFT = KEY_LSHIFT
local KEY_E      = KEY_E

local libOpVars = {}

module("umaglevlib")

function GetOpVar(anyKey)
  return (anyKey and libOpVars[anyKey])
end

function IsNil(anyVal)
  return (anyVal == nil)
end

function IsString(sVal)
  return (getmetatable(sVal) == GetOpVar("TYPE_METASTRING"))
end

function IsEmptyTab(tData)
  return IsNil(next(tData))
end

function IsEmptyStr(sData)
  return (sData == GetOpVar("STRING_ZERO"))
end

function IsNumber(sVal)
  return (tonumber(sVal) and IsNil(getmetatable(sVal)))
end

function CaseSelect(bCas, vTru, vFls)
  if(bCas) then return vTru else return vFls end
end

-- Function that calculates a sign
function GetSign(anyVal)
  local nVal = (tonumber(anyVal) or 0)
  return ((nVal > 0 and 1) or (nVal < 0 and -1) or 0) end

function GetDate()
  return (osDate(GetOpVar("DATE_FORMAT"))
   .." "..osDate(GetOpVar("TIME_FORMAT")))
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
  local arVec = stringExplode(symComp,sVec:gsub("%[",""):gsub("%]",""))
  return Vector(tonumber(arVec[1]) or 0,
                tonumber(arVec[2]) or 0,
                tonumber(arVec[3]) or 0)
end

-- Fixes a value to the nearest fraction
local function FixValue(nVal, nFrc)
  local nVal = tonumber(nVal) or 0
  local nFrc = tonumber(nFrc) or 0.01 -- Default the second digit
  local q, f = mathModf(nVal / nFrc)
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

function InitConstants()
  libOpVars["LIBRARY_NAME"    ] = "umaglevlib"    -- Name of the library
  libOpVars["GOLDEN_RATIO"    ] = 1.61803398875   -- Golden ration for panel resolution be more appealing
  libOpVars["OPSYM_GENINDENT" ] = " "             -- What symbol is used for indent spacing readability
  libOpVars["OPSYM_ITEMSPLIT" ] = "/"             -- Primary delimiter to split multiple string items by
  libOpVars["OPSYM_COMPONENT" ] = ","             -- Secondary delimiter to split individual item components
  libOpVars["OPSYM_INITSTRING"] = "@"             -- Trigger symbol for string source initialization ( including general settings )
  libOpVars["OPSYM_INITFILE"  ] = "#"             -- Trigger symbol for file source initialization ( including general settings )
  libOpVars["NAME_ENTITY"     ] = "maglevmodule"  -- The entity name used for limits and stuff
  libOpVars["NAME_TOOL"       ] = "maglevspawner" -- The tool mode which operates the entity
  libOpVars["TYPE_SENSOR"     ] = "sensor"        -- The internal sensor type as string
  libOpVars["TYPE_CONTROL"    ] = "control"       -- The internal control type as string
  libOpVars["TYPE_GENERAL"    ] = "general"       -- General storage type for maglev properties
  libOpVars["TYPE_FORCER"     ] = "forcer"        -- The internal forcer type as string
  libOpVars["HASH_ENTITY"     ] = "DataMGL"       -- Where in the entity the data is stored
end

function LogStatus(anyMsg, ...)
  local tSet = GetOpVar("LOG_SETTINGS")
  if(tSet.Enab:GetBool()) then
    local fLog = GetOpVar("PATH_TOOL")
    local sMsg = tostring(anyMsg)
    if(tSet.Skip and tSet.Skip[1]) then
      for id = 1, #tSet.Skip do
        if(sMsg:find(tostring(tSet.Skip[id]))) then return ... end end end
    if(tSet.Last and tSet.Last == sMsg) then return ... end
    local bFile = tSet.File:GetBool()
    local sLogo = bFile and "" or tostring(tSet.Info)..": "
    local sTime = "["..osDate()..":"..("%f"):format(SysTime()).."] "
    local sInst = (CLIENT and "CLIENT") or (SERVER and "SERVER") or "NOINST"
    local sLogs = "["..sInst.."] "..sTime..sLogo..sMsg
    if(bFile) then fileAppend(fLog.."system_log.txt", sLogs.."\n")
    else print(sLogs) end
  end; return ...
end

function InitDataMapping()
  local tMap = GetOpVar("MAPPING_MAGDATA")
  local tGen = GetOpVar("MAPPING_GENERAL")
  for key, rec in pairs(tMap) do
    local var, id = tostring(rec[3] or ""), (tonumber(rec[5]) or 0)
    local foo = ((type(rec[6]) == "function") and rec[6] or nil)
    if(var and (type(var) == "string") and (var ~= "")) then
      tGen[var] = {key, id, foo}
      if(id <= 0) then LogStatus("InitDataMapping: Invalid ID #"..id.." for <"..key.."/"..var..">") end
    end
  end -- All generals must be defined using the global maglev data[item][3]
end

local function ckControlTar(tab)
  local cn, mx, mt = #tab, tableGetMax(tab)
  if(cn ~= mx) then
    return LogStatus("ckControlTar: Array vacancies "..cn.." of "..mx, false) end
  if(cn == 0) then return LogStatus("ckControlTar: Array empty", false) end
  for id = 1, cn do if(type(tab[id]) ~= "string") then
    return LogStatus("ckControlTar: Array value #"..tostring(tab[id]).." not string", false) end end
  return true
end

local function ckControlTun(tab, dep)
  local cn, mx, mt = #tab, tableGetMax(tab), getmetatable("string")
  if(cn ~= mx) then
    return LogStatus("ckControlTun: Array vacancies "..cn.." of "..mx, false) end
  if(cn == 0) then return LogStatus("ckControlTun: Array empty", false) end
  if(cn >  3) then return LogStatus("ckControlTun: Array too long #"..cn, false) end
  for id = 1, cn do if(type(tab[id]) ~= "string") then
    return LogStatus("ckControlTun: Array value #"..tostring(tab[id]).." not string", false) end end
  return true
end

local function ckControlRef(tab, dep)
  local cn, mx = #tab, tableGetMax(tab)
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

function InitDependancies(vEnab, vFile)
  libOpVars["TRANSLATE_KEYTAB"] = {[2]="nam",[4]="cat",[7]="tip"}
  libOpVars["NUMBER_ZERO"     ] = 10e-5
  libOpVars["STRING_ZERO"     ] = ""
  -- More meaningful name to the one above used for labels
  libOpVars["DATE_FORMAT"     ] = "%d-%m-%y"
  libOpVars["TIME_FORMAT"     ] = "%H:%M:%S"
  libOpVars["FILE_ENTITY"     ] = "sent_"..GetOpVar("NAME_ENTITY") -- How is the entity controlled class called
  -- Base directory for all the data written. Defines there the library data is stored
  libOpVars["DIRPATH_BASE"    ] = "E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/ZeroBraineProjects/Transrapid/"..GetOpVar("NAME_TOOL").."/"
  libOpVars["DIRPATH_SAVE"    ] = GetOpVar("NAME_ENTITY").."/"
  libOpVars["LOG_SETTINGS"    ] = {
    Skip = {},
    Last = "",
    Info = GetOpVar("NAME_TOOL"):gsub("^%l", stringUpper),
    Enab = vEnab, -- Enable logging in general
    File = vFile  -- Enable logging file
  } -- Make a list with the log settings
  libOpVars["CLASS_TARGETS"   ] = {"prop_physics","prop_dynamic","prop_static","prop_ragdoll"}
  libOpVars["WIRE_REFERENCES" ] = {
    Name = {"RefGap", "RefSide", "RefPitch", "RefYaw", "RefRoll"},
    Type = {"NORMAL", "NORMAL" , "NORMAL"  , "NORMAL", "NORMAL" },
    Note = {"Refer gap spacing"  ,
            "Refer side symmetry",
            "Refer pitch bias"   ,
            "Refer yaw turn"     ,
            "Refer roll lean" }
  }
  libOpVars["TYPE_DEFCOLUMN"  ] = {} -- Columns that are enabled for processing
  libOpVars["UNIT_DESCRIPTION"] = {} -- The maglev unit description
  libOpVars["TYPE_METASTRING" ] = getmetatable("") -- Store string meta-table
  --[[
   * This is used for data mapping
   * [1] > Data type
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
  -- Data["Key"] = {"type", "~= of what", "cvar", "isIalid(type)", "order", "conv_base"}
  -- If the convar name is defined, the general type is used
  libOpVars["MAPPING_GENERAL"] = {} -- Mapping Convar name to column name and ID
  libOpVars["MAPPING_MAGDATA"] = {
    ["Name"]    = {"string" , nil, "name"   ,  nil, 1, tostring},
    ["Prop"]    = {"string" , "" , "model"  ,  nil, 2, tostring},
    ["FwLoc"]   = {"Vector" , nil, "fwloc"  , ckVecDirect, 3, GetVectorString},
    ["UpLoc"]   = {"Vector" , nil, "uploc"  , ckVecDirect, 4, GetVectorString},
    ["CnLoc"]   = {"Vector" , nil, "cnloc"  , ckVecOrigin, 5, GetVectorString},
    ["Mass"]    = {"number" , 0  , "mass"   , nil, 6 , tonumber},
    ["Tick"]    = {"number" , 0  , "tick"   , nil, 7 , tonumber},
    ["KeyOn"]   = {"number" , 0  , "keyon"  , nil, 8 , tonumber},
    ["KeyF"]    = {"number" , 0  , "keyf"   , nil, 9 , tonumber},
    ["KeyR"]    = {"number" , 0  , "keyr"   , nil, 10, tonumber},
    ["Target"]  = {"string" , nil, "target" , nil, 11, tostring},
    ["NumFor"]  = {"number" , nil, "numfor" , nil, 12, tonumber},
    ["NumTog"]  = {"boolean", nil, "numtog" , nil, 13, tobool},
    ["{Control}"] = { -- List of control structures
      ["Tar"]   = {"table"   , nil, nil, ckControlTar},
      ["Tun"]   = {"table"   , nil, nil, ckControlTun},
      ["Ref"]   = {"table"   , nil, nil, ckControlRef},
      ["Prs"]   = {"string"  , "" },
      ["Cmb"]   = {"boolean" , nil},
      ["Neg"]   = {"boolean" , nil},
      ["Dev"]   = {"function", nil},
      ["ID"]    = {"number"  , nil}
    },
    ["{Sensors}"] = { -- List of sensor structures
      ["Hit"] = {"table" , nil, nil, ckTargetTable},
      ["Org"] = {"Vector", nil, nil, ckVecOrigin},
      ["Dir"] = {"Vector", nil, nil, ckVecDirect},
      ["Len"] = {"number", 0},   -- Length
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

function InitDescription()
  local tDes = GetOpVar("UNIT_DESCRIPTION")
  tDes[ 1] = {Name = "User defined maglev"}
  tDes[ 2] = {Name = "Monorail bogie"           , Prop = "models/mechanics/solid_steel/sheetmetal_u_4.mdl"}
  tDes[ 3] = {Name = "PHX wheel-set"            , Prop = "models/hunter/plates/plate075x2.mdl"            }
  tDes[ 4] = {Name = "PHX bogie"                , Prop = "models/hunter/plates/plate2x2.mdl"              }
  tDes[ 5] = {Name = "Coaster bogie"            , Prop = "models/hunter/blocks/cube05x05x025.mdl"         }
  tDes[ 6] = {Name = "Narrow gauge bogie"       , Prop = "models/hunter/plates/plate1x1.mdl"              }
  tDes[ 7] = {Name = "Suspended bogie"          , Prop = "models/hunter/blocks/cube075x075x075.mdl"       }
  tDes[ 8] = {Name = "Monorail bogie"           , Prop = "models/props_phx/construct/metal_wire1x2x2b.mdl"}
  tDes[ 9] = {Name = "Sligwolf mini-track bogie", Prop = "models/props_junk/PlasticCrate01a.mdl"          }
  tDes[10] = {Name = "V-Surface bogie"          , Prop = "models/PHXtended/tri1x1x1.mdl"                  }
  tDes[11] = {Name = "Transrapid bogie"         , Prop = "models/ron/maglev/train/slider.mdl",
    Sensors = [[@{sensor:DFR}{Len:12}{Org: 17, 47,-4.3}{Dir:0, 0,1}
                @{sensor:DBR}{Len:12}{Org:-17, 47,-4.3}{Dir:0, 0,1}
                @{sensor:DFL}{Len:12}{Org: 17,-47,-4.3}{Dir:0, 0,1}
                @{sensor:DBL}{Len:12}{Org:-17,-47,-4.3}{Dir:0, 0,1}
                @{sensor:SFR}{Len:15}{Org: 17, 62, 4.0}{Dir:0,-1,0}
                @{sensor:SBR}{Len:15}{Org:-17, 62, 4.0}{Dir:0,-1,0}
                @{sensor:SFL}{Len:15}{Org: 17,-62, 4.0}{Dir:0, 1,0}
                @{sensor:SBL}{Len:15}{Org:-17,-62, 4.0}{Dir:0, 1,0}]],
     Forcers =[[@{forcer:UR}{Org:0, 60,0}{Dir:0,0,1}
                @{forcer:UL}{Org:0,-60,0}{Dir:0,0,1}
                @{forcer:LR}{Org:0,  0,0}{Dir:0,1,0}
                @{forcer:APF}{Org: 250,0,0}{Dir:0,0, 1}
                @{forcer:APB}{Org:-250,0,0}{Dir:0,0,-1}
                @{forcer:AYR}{Org:0, 250,0}{Dir: 1,0,0}
                @{forcer:AYL}{Org:0,-250,0}{Dir:-1,0,0}
                @{forcer:ARR}{Org:0, 500,0}{Dir:0,0, 1}
                @{forcer:ARL}{Org:0,-500,0}{Dir:0,0,-1}]],
     Control =[[@{control:UR}{Tar:UR}{Cmb:true}{Tun:460,0.2,1740//1.2,1,1}{Ref:4.5/}{Neg:true}{Pro:((DFR < DBR) and DFR or DBR)}
                @{control:UL}{Tar:UL}{Cmb:true}{Tun:460,0.2,1740//1.2,1,1}{Ref:4.5/}{Neg:true}{Pro:((DFL < DBL) and DFL or DBL)}
                @{control:LR}{Tar:LR}{Cmb:true}{Tun:2500,0,2600//1.5,1,1.4}{Ref:0/}{Neg:true}{Pro:(((SFR < SBR) and SFR or SBR) - ((SFL < SBL) and SFL or SBL))}
                @{control:AP}{Tar:APF/APB}{Cmb:true}{Tun:100,0,250//}{Ref:0/}{Neg:true}{Pro:(4 * (((DBR < DBL) and DBR or DBL) - ((DFR < DFL) and DFR or DFL)))}
                @{control:AY}{Tar:AYR/AYL}{Cmb:true}{Tun:510,0,450//}{Ref:0/}{Neg:false}{Pro:(4 * (((SFR < SBL) and SFR or SBL) - ((SFL < SBR) and SFL or SBR)))}
                @{control:AR}{Tar:ARR/ARL}{Cmb:true}{Tun:32,0,1200//1.2,1,1.2}{Ref:0/}{Neg:true}{Pro:(4 * (((DFL < DBL) and DFL or DBL) - ((DFR < DBR) and DFR or DBR)))}]]
    }
end

function LogTable(tT,sS,tP)
  local vS, vT, vK, sS = type(sS), type(tT), "", tostring(sS or "Data")
  if(vT ~= "table") then
    return LogStatus("{"..vT.."}["..tostring(sS or "Data").."] = <"..tostring(tT)..">") end
  if(IsEmptyTab(tT)) then
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
 * ValidateTable: Validates a stricture based
 * on the parameters given
 * aName > Any name to identify the validation
 * tData > The data to validate
 * tPara > Validation parameters
 * iStg  > Initial recursion stage. Managed internally
]]--

function ValidateTable(aName, tData, tPara, iStg)
  local suc, nam, stg = true, tostring(aName), (iStg and (iStg+1) or 0)
  for key, val in pairs(tData) do -- Output success
    local par, dep = tPara[key], nam.."["..key.."]"
    if(suc and not par and tPara["{"..key.."}"]) then -- Process item mist of the same type
      local par = tPara["{"..key.."}"]
      if(not par) then
        return LogStatus("ValidateTable["..stg.."]: Hash item "..dep.." <"..type(val).."> fail", false) end
      for ki, vi in pairs(val) do
        local li = dep.."["..ki.."]"
        if(not ValidateTable(li, vi, par, stg)) then
          suc = LogStatus("ValidateTable["..stg.."]: Recursive item "
            ..dep.." <"..type(val).."> fail", false) end
      end
    elseif(suc and (type(par) ~= "table")) then -- It is not item list and parameters are invalid
      return LogStatus("ValidateTable["..stg.."]: Parameter "..dep.." <"..type(par).."> fail", false)
    elseif(suc and par[4] and type(par[4]) == "function") then -- Use the validation function for the value
      if(type(val) ~= par[1]) then -- Not having the experted type
        suc = LogStatus("ValidateTable["..stg.."]: Function type "
          ..dep.." is <"..type(val).."> expects <"..par[1]..">", false) end
      suc = par[4](val, dep); LogStatus("Validated via function "..dep.." "..(suc and "OK" or "fail"))
    elseif(suc and type(val) == "table") then -- All the table parameters
      if(not ValidateTable(dep, val, par, stg)) then
        suc = LogStatus("ValidateTable["..stg.."]: Recursive type "..dep.." <"..type(val).."> fail", false) end
    else -- Process all the generals
      if(suc) then -- Make sure validating only successful records for faster recursion
        if(type(val) ~= par[1]) then -- Not having the experted type
          suc = LogStatus("ValidateTable["..stg.."]: Value type "..dep.." <"..type(val).."> fail", false) end
        if(type(val) == "Vector") then
          if(par[2] and val:Length() == par[2]) then -- Vectors having zero length
            suc = LogStatus("ValidateTable["..stg.."]: Vector length "..dep.." <"..type(val).."> fail", false) end
        else
          if(par[2] and val == par[2]) then -- The value is defined as invalid
            suc = LogStatus("ValidateTable["..stg.."]: Value "..dep.." <"..type(val).."> fail", false) end
        end
      end
    end
  end; return LogStatus("ValidateTable["..stg.."]: Validated > "..tostring(aName).." "..(suc and "OK" or "fail"), suc)
end

--[[
 * MixWireOutputs: This function mixes the names types and
 * notes for the outputs given with the data provided by the
 * library variable /WIRE_REFERENCES/
 * tName > Wire outputs names list
 * tType > Wire outputs types list
 * tNote > Wire outputs notes list
]]--
function MixWireOutputs(tName, tType, tNote)
  local seOuts = GetOpVar("WIRE_REFERENCES")
  local syItem = GetOpVar("OPSYM_ITEMSPLIT")
  local syInde = GetOpVar("OPSYM_GENINDENT")
  for id = 1, #tName do
    local nm = tostring(tName[id] or ""):Trim()
    local tp = tostring(tType[id] or ""):Trim()
    local nt = tostring(tNote[id] or ""):Trim()
    if(nm ~= "" and tp ~= "") then
      tName[id], tType[id] = nm, tp
      if(nt ~= "") then tNote[id] = (syInde..nt..syInde) else tNote[id] = ""
        LogStatus("MixWireOutputs: Skip processing notes <"..tostring(nm)..">") end
    else return LogStatus("MixWireOutputs: Failed processing output <"
           ..tostring(nm).."/"..tostring(tp)..">", false) end
  end
  for id = 1, #seOuts.Name do
    local nm = tostring(seOuts.Name[id] or ""):Trim()
    local tp = tostring(seOuts.Type[id] or ""):Trim()
    local nt = tostring(seOuts.Note[id] or ""):Trim()
    if(nm ~= "" and tp ~= "") then
      tableInsert(tName, nm); tableInsert(tType, tp)
      if(nt ~= "") then tableInsert(tNote, syInde..nt..syInde) else tableInsert(tNote, "")
        LogStatus("MixWireOutputs: Skip adding notes <"..tostring(nm)..">") end
    else return LogStatus("MixWireOutputs: Failed adding output <"
           ..tostring(nm).."/"..tostring(tp)..">", false) end
  end; return LogStatus("MixWireOutputs: Done", true)
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
  if(mNam == "") then return LogStatus("NewConvarArray: Name empty. "..mInf, nil) end
  if(mCnt <= 0) then return LogStatus("NewConvarArray: Beam count invalid <"..mNam.."> #"..mCnt, nil) end
  if(mLen <= 0) then return LogStatus("NewConvarArray: Bean length invalid <"..mNam..">"..mSiz, nil) end
  local mTab = {}
  if(nFlg ~= 0) then -- For custom behavior
    for id = 1, mCnt do mTab[id] = CreateConVar(mNam.."_"..id, mVal, nFlg, mInf) end
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
    if(sD ~= "") then tE = stringExplode(sD, sI); cE = #tE else
      tE = {}
      local iS, iE = 1, mLen
      local sS, id = sIn:sub(iS, iE), 1
      while(sS and sS ~= "") do
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
        return LogStatus("NewConvarArray: Beam ["..id.."] <"..mNam.."> shorter {"
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
      mtSensor.__type  = GetOpVar("TYPE_SENSOR")
      mtSensor.__tostring = function(oSen) return "["..mtSensor.__type.."]"..
        " {E="..tostring(oSen:getEntity())..", L="..tostring(oSen:getLength())..
        ", O="..tostring(oSen:getOrigin())..", D="..tostring(oSen:getDirect()).."}" end
function NewSensor(sNam)
  local mNam = tostring(sNam or "") -- Name used to identify the thing
  if(mNam == "") then return LogStatus("NewSensor: Name invalid", nil) end
  local mOrg = Vector() -- Local position relative to mEnt
  local mDir = Vector() -- Local direction relative to mEnt
  local mLen, mEnt = 0 -- Length and base attachment entity
  local mfTrace, mtTrC -- The tracer function to be used
  local self, mtTrO = {}, {} -- Define the member parameters
  local mtTrI = { -- This table stores the trace input information
    start  = Vector(),   -- Start position of the trace
    endpos = Vector(),   -- End   position of the trace
    mask   = MASK_SOLID, -- Mask telling it what to hit ( currently solid )
    output = mtTrO,      -- Trace result for avoiding table creation in real time
    filter = function(oEnt) -- Only valid props which are not the main entity or world or mtTrC
      if(oEnt and oEnt:IsValid() and oEnt ~= mEnt and mtTrC[oEnt:GetClass()]) then return true end end }
  setmetatable(self, mtSensor)
  function self:getEntity() return mEnt end
  function self:getLength() return mLen end
  function self:getTrace()  return mtTrI end
  function self:isHit()     return mtTrO.Hit end
  function self:getFraction() return mtTrO.Fraction end
  function self:Sample() mfTrace(mtTrI); return self end
  function self:getOrigin() v = Vector(); v:Set(mOrg) return v end
  function self:getDirect() v = Vector(); v:Set(mDir) return v end
  function self:setTrace(fTrs, tHit)
    mfTrace, mtTrC = fTrs, tHit
    if(type(mtTrC) == "table") then
        for key, val in pairs(mtTrC) do
          LogStatus("NewSensor.setTrace: ["..key.."] = "..tostring(val)) end
    end; return self
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
  function self:Update(ePos, eAng) -- Updates the trace parameters and gets ready to sample
    local fPos = ePos and ePos or mEnt:GetPos()
    local fAng = eAng and eAng or mEnt:GetAngles()
    local vstr, vend = mtTrI.start, mtTrI.endpos
    vstr:Set(mOrg); vstr:Rotate(fAng); vstr:Add(fPos)
    vend:Set(mDir); vend:Rotate(fAng); vend:Add(vstr); return self
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
    return LogStatus("NewSensor.Validate: Sensor <"..mNam.."> "..(oSta and "success" or "fail"), oSta)
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
      mtForcer.__type  = GetOpVar("TYPE_FORCER")
      mtForcer.__tostring = function(oSen) return "["..mtForcer.__type.."]"..
        " {E="..tostring(oSen:getEntity())..", O="..tostring(oSen:getOrigin())..", D="..tostring(oSen:getDirect()).."}" end
function NewForcer(sNam)
  local mNam = tostring(sNam or "") -- Name used to identify the thing
  if(mNam == "") then return LogStatus("NewForcer: Name invalid", nil) end
  local mOrg = Vector() -- Local position of the forcer
  local mDir = Vector() -- Local direction of the forcer
  local fOrg = Vector() -- Force origin lever relative to ePos
  local fDir = Vector() -- force world-space direction vector of the force applied
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
  function self:Update(ePos, eAng) -- Updates the trace parameters and gets ready to sample
    local fPos = ePos and ePos or mEnt:GetPos()
    local fAng = eAng and eAng or mEnt:GetAngles()
    fOrg:Set(mOrg); fOrg:Rotate(fAng); fOrg:Add(fPos)
    fDir:Set(mDir); fDir:Rotate(fAng); return self
  end -- Executed in real-time. Performs position and direction update
  function self:Force(nAmt)
    fDir:Mul(tonumber(nAmt) or 0); mPhys:ApplyForceOffset(fDir, fOrg); return self
  end
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
    if(not (mPhys and mPhys:IsValid())) then
      oSta = LogStatus("NewForcer.Validate: Physics invalid <"..tostring(mEnt)..">", nil) end
    if(mDir:Length() == 0) then -- Vector magnitude cannot be negative
      oSta = LogStatus("NewForcer.Validate: Direct invalid <"..tostring(mDir)..">", nil) end
    if(not oSta) then self:Dump() end -- Try to validate the object return it validated
    return LogStatus("NewForcer.Validate: Forcer <"..mNam.."> "..(oSta and "success" or "fail"), oSta)
  end; return LogStatus("NewForcer: Create ["..mNam.."]", self) -- The forcer object
end

--[[
 * NewControl: Class maglev state processing manager. Implements a controller unit
 * nTo   > Controller sampling time in seconds
 * sName > Controller hash name differentiation
]]--
local mtControl = {}
      mtControl.__index = mtControl
      mtControl.__type  = GetOpVar("TYPE_CONTROL")
      mtControl.__tostring = function(oCon)
        return oCon:getType().."["..mtControl.__type.."] ["..tostring(oCon:getPeriod()).."]"..
          "{T="..oCon:getTune()..",W="..oCon:getWindup()..",P="..oCon:getPower().."}"
      end
function NewControl(nTo, sName)
  local mTo = (tonumber(nTo) or 0); if(mTo <= 0) then -- Sampling time [s]
    return LogStatus("NewControl: Sampling time <"..tostring(nTo).."> invalid",nil) end
  local self  = {}                 -- Place to store the methods
  local mfAbs = mathAbs            -- Function used for error absolute
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
    local arTune = stringExplode(symComp,sTune)
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
    local arSat = stringExplode(symComp,sWind)
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
    local arPow = stringExplode(symComp,sPow) -- Power ignored when missing
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
    local sLabel = (mType ~= "") and (mType.."-") or mType
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
 * Is the type enabled for control or sensor
 * sTyp > Either sensor or control hash
]]--
function IsType(sTyp)
  local tCol = GetOpVar("TYPE_DEFCOLUMN")
  return ((tCol and sTyp) and tCol[sTyp])
end

--[[
 * Is the column name enabled for control or sensor
 * sTyp > Either sensor or control hash
 * sCol > The name of the column to be checked
]]--
function IsHash(sTyp, sCol)
  local tTyp = IsType(sTyp)
  return ((tTyp and sCol) and tTyp[sCol])
end

function GetDescriptionID(vID)
  local tDs = GetOpVar("UNIT_DESCRIPTION")
  local nID = (tonumber(vID) or 0)
  return (tDs and tDs[nID] or nil)
end

function GetDescriptionSize()
  local tDs = GetOpVar("UNIT_DESCRIPTION")
  return (tDs and #tDs or 0)
end

function SetupDataSheet(pnLV, pnProp, tProp, obVar)
  local syInis = GetOpVar("OPSYM_INITSTRING")
  for ID = 1, #tProp do -- http://wiki.garrysmod.com/page/Category:DProperties
    local col = tostring(tProp[ID][2])
    LogStatus("SetupDataSheet: Processing["..ID.."] <"..col.."> ")
    if(tProp[ID][1]) then
      local cow = (tonumber(tProp[ID][3]) or 0)
      pnLV:AddColumn(col):SetFixedWidth(cow)
      LogStatus("SetupDataSheet: pnLV:AddColumn("..col.."):SetFixedWidth("..cow..")")
    end
    local cat, nam = tostring(tProp[ID][4] or ""), tostring(tProp[ID][2] or "")
    tProp.Pan = pnProp:CreateRow(cat, nam)
    LogStatus("SetupDataSheet: DProperties.CreateRow("..cat..","..nam..")")
    if(not IsValid(tProp.Pan)) then
      return LogStatus("SetupDataSheet: Create row <"..nam.."> fail #"..ID) end
    local typ, dat = tostring(tProp[ID][5] or ""), tProp[ID][6]
    if(typ == "Combo") then
      local lab, val = dat[1], dat[2];
      tProp.Pan:Setup(typ, {text = "Select ..."})
      LogStatus("SetupDataSheet: DProperties_Combo:Setup("..typ..", {text = Select ...})")
      for n = 1, #lab do -- Add all the choices: http://wiki.garrysmod.com/page/Category:DProperty_Combo
        tProp.Pan:AddChoice(lab[n], val[n])
        LogStatus("SetupDataSheet: DProperties_Combo:AddChoice("..lab[n]..", "..val[n]..")")
      end
      for k, v in pairs(dat) do -- Apply the override method
        if(not tonumber(k)) then
          tProp.Pan[k] = v
          LogStatus("SetupDataSheet: DProperties_Combo["..k.."] = "..tostring(v))
        end
      end
    else
      tProp.Pan:Setup(typ)
      tProp.Pan:SetValue(dat[1]); tProp.Pan:SetToolTip(tProp[ID][7])
    end
  end
  pnLV.OnRowSelected = function(pnSelf, nID, pnLine) -- For override (PASTE)
    -- Create/Update the properties on the line selected ( If name given is equal )
    -- Press SHIFT will create a new line ( If the name is new )
    -- https://wiki.garrysmod.com/page/DListView/AddLine ( PROP --> LIST )
    local pTyp, pCol = tProp.Type, tProp.List
    if(inputIsKeyDown(KEY_E)) then -- Import from the console variables
      local tVal, tIni, tSeq = stringExplode(syInis,obVar:GetValue():gsub("%s",""):Trim(syInis)), {}, {}
      for ID = 1, #tVal do
        if(not TransformSettings(tVal[ID], tIni, tSeq)) then
          LogStatus("SetupDataSheet: pnLV.OnRowSelected(CVAR): Unable to transform <"..tVal[ID]..">") end
      end; local tRep = GetKeyReportID(tIni[pTyp]) -- What element do we make report for
      if(not tRep) then return LogStatus("SetupDataSheet: pnLV.OnRowSelected(CVAR): Report fail") end
      pnLV:Clear(); LogStatus("SetupDataSheet: pnLV.OnRowSelected(CVAR): Clear")
      local aKey, tUni = tRep.Key, tIni[pTyp]
      for N = 1, #aKey do
        local key, cnt = aKey[N]  , 2 -- Count points to the next free slot
        local val, tab = tUni[key], {key}
        for ID = 2, #tProp do
          local col = tProp[ID][1] -- If column definition available add the value
          if(col) then tab[cnt] = val[col]; cnt = cnt + 1 end
        end; pnLV:AddLine(unpack(tab))
        LogStatus("SetupDataSheet: pnLV.OnRowSelected(CVA): Added <"..key..">")
      end
    elseif(inputIsKeyDown(KEY_LSHIFT)) then -- Import from the trace entity
      local trEnt, eKey = LocalPlayer:GetEyeTrace().Entity, GetOpVar("HASH_ENTITY")
      if(not (trEnt and trEnt:IsValid() and trEnt:GetClass() == GetOpVar("FILE_ENTITY"))) then
        return LogStatus("SetupDataSheet: pnLV.OnRowSelected(ENT): Skipped <"..tostring(trEnt)..">") end
      local tData = trEnt[eKey]; if(not tData) then
        return LogStatus("SetupDataSheet: pnLV.OnRowSelected(ENT): Data <"..tostring(trEnt).."> missing") end
      tData = tData[pCol]; if(not tData) then
        return LogStatus("SetupDataSheet: pnLV.OnRowSelected(ENT): List <"..pTyp.."> missing <"..tostring(trEnt)..">") end
      local tRep = GetKeyReportID(tData) -- Make a report fro the data stored under the type list selected
      if(not tRep) then return LogStatus("SetupDataSheet: pnLV.OnRowSelected(ENT): Report fail") end
      for N = 1, #tRep.Key do
        local key, cnt = tRep.Key[N], 2 -- Count points to the next free slot
        local val, tab = tData[key], {key}
        for ID = 2, #tProp do
          local col = tProp[ID][1] -- If column definition available add the value
          if(col) then tab[cnt] = val[col]; cnt = cnt + 1 end
        end; pnLV:AddLine(unpack(tab))
        LogStatus("SetupDataSheet: pnLV.OnRowSelected(ENT): Added <"..key..">")
      end
    else
      local tVal = {};
      for ID = 1, #tProp do
        if(tProp[ID][1]) then tVal[ID] = tProp[ID].Pan:GetValue()
          LogStatus("SetupDataSheet: pnLV.OnRowSelected: Property["..ID.."] = "..tVal[ID]) end
      end
      -- Add the line /tVal/ to the list view. If the line does not exist,
      -- it will be added, else all matching names will be deleted and the new line will be used
      for k, v in pairs(pnSelf:GetLines()) do
        if(tVal[1] == v:GetValue(1)) then pnLV:RemoveLine(k)
          LogStatus("SetupDataSheet: pnLV.OnRowSelected(ADD)["..k.."]: Removed <"..tVal[1]..">")
      end end -- Remove the old line if the name is repetitive
      pnLV:AddLine(unpack(tVal))
      LogStatus("SetupDataSheet: pnLV.OnRowSelected(ADD): <"..tVal[1]..">")
    end
  end
  pnLV.OnRowRightClick = function(pnSelf, nID, pnLine) -- For override (COPY)
    -- Copies the list view line into the item properties
    -- Hold SHIFT to remove the line selected ( cut-paste )
    -- https://wiki.garrysmod.com/page/DListView/RemoveLine ( LIST --> PROP )
    if(inputIsKeyDown(KEY_E)) then -- Export to the console variable
      local tLin, sVal = pnSelf:GetLines(), "" -- Initialize using string
      for ID = 1, #tLin do local pLin = tLin[ID]
        sVal = sVal..syInis.."{"..pTyp..":"..pLin:GetValue(1).."}"
        for N = 2, #tProp do
          if(tProp[N][1]) then sVal = sVal.."{"..tProp[N][1]..":"..pLin:GetValue(N).."}" end end
      end; obVar:SetValue(sVal)
      LogStatus("SetupDataSheet: pnLV.OnRowRightClick(EXP): "..pTyp.." <"..sVal..">")
    else -- Copy a line into the properties
      for ID = 1, #tProp do local val = tProp[ID] -- Copy the line selected into the properties menu
        if(val[1]) then local col = pnLine:GetValue(ID); tProp[ID].Pan:SetValue(col)
          LogStatus("SetupDataSheet: pnLV.OnRowRightClick: Property["..val[2].."]["..ID.."] = "..col) end end
      if(inputIsKeyDown(KEY_LSHIFT)) then -- Cut a line
        pnLV:RemoveLine(nID); LogStatus("SetupDataSheet: pnLV.OnRowRightClick(REM): "..pTyp.." <"..sVal..">")
      elseif(inputIsKeyDown(KEY_G) ~= 0) then -- Clear all lines
        pnLV:Clear(); LogStatus("SetupDataSheet: pnLV.OnRowRightClick(CLR): OK")
      end
    end
  end
end

--[[
 * Compiles a user-defined state deviation from a string
 * sErr  > The error deviation given as a sensor hash formula
 * sCon  > The state name that its error will be defined this way
 * stSen > The sensor structure used to compile the error function
]]--
function GetDeviation(sErr, sCon, stSen)
  local sCo = tostring(sCon):rep(1):Trim() -- Copy a temporary error selection
  local sEr = tostring(sErr):rep(1):Trim()
  for key, sen in pairs(stSen) do
    sEr = sEr:gsub(key, "oSens[\""..tostring(key).."\"].Val") end
  local sFc = "return (function(oSens) return "..sEr.." end)"
  local fCm = CompileString(sFc, GetOpVar("FILE_ENTITY").."_"..sCo)
  if(type(fCm) ~= "function") then
    LogTable(stSen, "GetDeviation("..sCo.."): Sensors")
    return LogStatus("GetDeviation("..sCo.."): <"..sFc..">", nil)
  end; return LogStatus("GetDeviation("..sCo.."): <"..sFc..">", fCm())
end

function InitTargetsHit(bRep)
  local tTrgs = GetOpVar("CLASS_TARGETS")
  local lbNam = GetOpVar("LIBRARY_NAME")
  local fName = GetOpVar("DIRPATH_BASE")..lbNam.."_hit.txt"
  local S = file.Open(fName, "rb", "DATA")
  if(S) then
    if(bRep) then
      for key, _ in pairs(tTrgs) do tTrgs[key] = nil end end
    local sCh, sLine = "X", ""
    while(sCh) do sCh = S:Read(1)
      if(not sCh) then break end
      if(sCh == "\n") then sLine = sLine:Trim()
        if(not IsEmptyStr(sLine)) then
          tTrgs[sLine] = true end; sLine = ""
      else sLine = sLine..sCh end
    end; if(not IsEmptyStr(sLine)) then tTrgs[sLine] = true end; S:Close()
    return LogStatus("InitTargetsHit: Success <"..fName..">", true)
  else return LogStatus("InitTargetsHit: Missing <"..fName..">", true) end
end

--[[
 * ConvertTraceTargets: Prepares a list of targets for a wet job
 * Retrieves the table hash hit list and hires the hit-man :D
 * You must be very careful when using this function as SO can get hurt !
 * But seriously: Converts "prop/ test " to {["prop"] = true, ["test"] = true}
 * If no arguments are provided or an empty string, uses CLASS_TARGETS
 * sCls > The string to convert to a hash format
 * tGlb > Global hit targets table to use if provided
 * bGlb > Whenever or not to use the global hit targets
]]--
function ConvertTraceTargets(sCls, tGlb, bGlb)
  local sCls = tostring(sCls or "")
  local tArg = CaseSelect(type(tGlb)=="table",tGlb,GetOpVar("CLASS_TARGETS"))
  local tSrc = CaseSelect(bGlb,tArg,{})
  if(not IsEmptyStr(sCls)) then
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
  local sBase = sLine:Trim()
  if(sBase:sub(1,1) == "#") then return true end
  local cnt, tab, typ, key = 1, 0
  for v in sBase:gmatch("{(.-)}") do -- All the items in curly brackets
    local exp = stringExplode(":",v) -- Explode on : to get key-value pairs
    local fld, val = tostring(exp[1] or ""):Trim(), tostring(exp[2] or ""):Trim()
    if(fld == "") then
      return LogStatus("TransformSettings: Key missing <["..tostring(cnt).."],"..sBase..">", false) end
    if(val == "") then
      return LogStatus("TransformSettings: Value missing <["..tostring(cnt).."]["..fld.."],"..sBase..">", false) end
    if(cnt == 1) then
      typ, key = fld, val
      if(not IsType(typ)) then
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
 * Does a post-processing of an initialization parameterization
 * tSet  > A value set table to be processed
 * tgHit > If the hit list is not available for the sensor use the global one
 * bgHit > Flag for using the global table or not
]]--
function PostProcessInit(tSet, tgHit, bgHit)
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
        if(not (rec["Len"] and mathAbs(rec["Len"]) ~= 0)) then
          return LogStatus("PostProcessInit: Sensor <"..key.."> invalid length", false) end
        rec["Org"], rec["Val"] = GetVectorString(rec["Org"]), 0
        rec["Dir"] = GetVectorString(rec["Dir"])
        if(rec["Dir"] and rec["Dir"]:Length() == 0) then
          return LogStatus("PostProcessInit: Sensor <"..key.."> invalid direct", false) end
        rec["Hit"] = ConvertTraceTargets(rec["Hit"],tgHit,bgHit)
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
          return LogStatus("PostProcessInit: Sensor <"..key.."> invalid direct", false) end
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
        rec["Ref"][2] = CaseSelect(not IsEmptyStr(rec["Ref"][2]),rec["Ref"][2],nil)
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
function InitializeUnitSource(srSet, sgHit, bgHit)
  local sHit = tostring(sgHit or ""):Trim()
  local sSet, tSet = tostring(srSet or ""):Trim(), {}
  local tHit, sMod = ConvertTraceTargets(sHit,nil,bgHit), sSet:sub(1,1)
  local mdFil, mdStr = GetOpVar("OPSYM_INITFILE"), GetOpVar("OPSYM_INITSTRING")
  if(sMod == mdFil) then -- Use a file
    local sNm = sSet:sub(2,-1); if(IsEmptyStr(sNm)) then
      return LogStatus("InitializeUnitSource(file): File name empty",nil) end
    sNm = GetOpVar("DIRPATH_BASE")..GetOpVar("DIRPATH_SAVE")..sNm..".txt"
    if(not file.Exists(sNm, "DATA")) then
      return LogStatus("InitializeUnitSource(file): File missing: "..sNm,nil) end
    local ioF = file.Open(sNm, "rb", "DATA"); if(not ioF) then
      return LogStatus("InitializeUnitSource(file): File failed <"..tostring(sNm)..">",nil) end
    local cnt, ln, pk, seq = 1, "", false, {}
    while(true) do
      local rd = ioF:Read(1); if(not rd) then break end
      if(rd == "\n") then -- If the end of the line is reached
        if(not TransformSettings(ln, tSet, seq)) then
          return LogStatus("InitializeUnitSource(file): Transform failed <"..ln..">",nil) end
          cnt, ln = (cnt + 1), ""
      else ln = ln..rd end
    end
    if(not IsEmptyStr(ln)) then
      if(not TransformSettings(ln, tSet, seq)) then
        return LogStatus("InitializeUnitSource(file): Transform last failed <"..ln..">",nil) end
    end; ioF:Close()
    if(not PostProcessInit(tSet, tHit, bgHit)) then
      return LogStatus("InitializeUnitSource(file): Post-process fail", nil) end
    collectgarbage(); return LogStatus("InitializeUnitSource(file): OK", tSet)
  elseif(sMod == mdStr) then
    local ini, seq = mdStr:Explode(sSet:sub(2,-1)), {}
      for cnt  = 1, #ini, 1 do
        local ln = ini[cnt]:Trim()
        if(not TransformSettings(ln, tSet, seq)) then
          return LogStatus("InitializeUnitSource(string): Transform failed <"..ln..">",nil) end
      end
    if(not PostProcessInit(tSet, tHit, bgHit)) then
      return LogStatus("InitializeUnitSource(string): Post-process fail", nil) end
    collectgarbage(); return LogStatus("InitializeUnitSource(string): OK", tSet)
  else return LogStatus("InitializeUnitSource: Mode missed <"..sMod..">", nil) end
end

--[[
 * Exports a set of maglev module controls
 * into array of initialization strings
 * sKey  > The sensor name/key to export
 * stCon > The sensor structure to be exported
 * tData > Where is the data stored
]]--
local function ExportSensor(sKey, stSen, tData)
  local tyArg = type(stSen)
  if(tyArg ~= "table") then
    return LogStatus("ExportSensor: Argument <"..tyArg.."> mismatch", false) end
  local symCp = GetOpVar("OPSYM_COMPONENT")
  local org, dir, len = stSen["Org"], stSen["Dir"], stSen["Len"]
  local sLin ,  ID = "{"..GetOpVar("TYPE_SENSOR")..":"..sKey.."}", (#tData + 1)
        sLin = sLin.."{Len:"..tostring(len).."}"
        sLin = sLin.."{Org:"..tostring(org.x)..symCp..tostring(org.y)..symCp..tostring(org.z).."}"
        sLin = sLin.."{Dir:"..tostring(dir.x)..symCp..tostring(dir.y)..symCp..tostring(dir.z).."}"
  local lst = ""; for hit, _ in pairs(stSen["Hit"]) do lst = lst.."/"..tostring(hit) end
        lst = lst:sub(2,-1); sLin = sLin..CaseSelect(IsEmptyStr(lst), "", "{Hit:"..lst.."}")
  tData[ID] = sLin; ID = ID + 1; sLin = ""; return true
end

--[[
 * Exports a set of maglev module controls
 * into array of initialization strings
 * sKey  > The control name/key to export
 * stCon > The control structure to be exported
 * tData > Where is the data stored
]]--
local function ExportControl(sKey, stCon, tData)
  local tyArg = type(stCon)
  if(tyArg ~= "table") then return LogStatus("ExportControl: Argument <"..tyArg.."> mismatch", false) end
  local symItem = GetOpVar("OPSYM_ITEMSPLIT")
  local cmb, neg, ref = stCon["Cmb"], stCon["Neg"], stCon["Ref"]
  local tun, prs, tar = stCon["Tun"], stCon["Prs"], stCon["Tar"]
  local sLin, ID = "{"..GetOpVar("TYPE_CONTROL")..":"..sKey.."}", (#tData + 1)
        sLin = sLin.."{Cmb:"..tostring(cmb):Trim().."}"
        sLin = sLin.."{Neg:"..tostring(neg):Trim().."}"
        sLin = sLin.."{Tar:"; for i = 1, #tar do
          sLin = sLin..tostring(tar[i]):Trim()..symItem end; sLin = sLin:sub(1,-2).."}"
        sLin = sLin.."{Ref:"..tostring(ref[1] or ""):Trim()
          ..symItem.. (ref[2] and tostring(ref[2]) or ""):Trim().."}"
        sLin = sLin.."{Tun:"..tostring(tun[1] or ""):Trim()..
            symItem..tostring(tun[2] or ""):Trim()..
            symItem..tostring(tun[3] or ""):Trim().."}"
        sLin = sLin.."{Prs:"..tostring(prs):Trim().."}"
  tData[ID] = sLin; ID = ID + 1; sLin = ""; return true
end

--[[
 * Exports a set of maglev module general settings ( properties )
 * into array of initialization strings
 * sKey  > The property name/key to export
 * stCon > The property structure to be exported
 * tData > Where is the data stored
]]--
local function ExportGeneral(sKey, stGen, tData)
  local tyArg = type(stGen)
  if(tyArg ~= "table") then return LogStatus("ExportGeneral: Argument <"..tyArg.."> mismatch", false) end
  local sLin, ID = "{"..GetOpVar("TYPE_GENERAL")..":"..sKey.."}", (#tData + 1)
        sLin = sLin.."{Val:"..tostring(stGen.Val).."}"
  tData[ID] = sLin; return true
end

--[[
 * Exports a set of maglev module forcer settings
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
function GetKeyReportID(stSet)
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
 * Exports a set of maglev module settings
 * into array of initialization strings
 * stSet > A table set to export
 * sType > The set type either /sensor/ or /control/ or /general/
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
 * stMaglevData > The maglev initialization data to be updated
 * tGen         > The general setting we need to update the structure with
]]--
function SetGeneralTable(stMaglevData, tGen)
  local tMap = GetOpVar("MAPPING_GENERAL")
  for key, rec in pairs(tGen) do
    local map = tMap[key]
    local col, foo = map[1], map[3]
    if(type(col) == "string") then
      if(type(foo) == "function") then stMaglevData[col] = foo(rec.Val)
      else stMaglevData[col] = rec.Val end
    end
  end
end

--[[
 * Creates a general purpose table based on non-list entity fields
 * This table is later used for exporting the general setting into a file
 * eMag > The maglev entity to be extracted
]]--
function GetGeneralTable(eMag)
  local sCls = GetOpVar("FILE_ENTITY")
  local tGen = GetOpVar("MAPPING_GENERAL")
  local sHas = GetOpVar("HASH_ENTITY")
  if(not (eMag and eMag:IsValid() and eMag:GetClass() == sCls)) then
    return LogStatus("GetGeneralTable: Entity invalid <"..tostring(eMag)..">") end
  local magData = eMag[sHas]
  local tExp = {}; for key, val in pairs(tGen) do
    tExp[key] = {Val = magData[val[1]], ID = val[2]} end
  return tExp
end

--[[
 * Exports a maglev module unit setting into a file
 * eMag  > The maglev module entity
 * sFile > The file to export the settings to
]]--
function ExportUnitSource(eMag, sFile)
  if(not (eMag and eMag:IsValid())) then
    return LogStatus("ExportUnitSource: Maglev module invalid", nil) end
  local sMag, sEnt = eMag:GetClass(), GetOpVar("FILE_ENTITY")
  if(sMag ~= sEnt) then -- If another entity is given
    return LogStatus("ExportUnitSource: Maglev class <"..sMag.."> invalid", nil) end
  local sNm = tostring(sFile or "default")
  if(IsEmptyStr(sNm)) then
    return LogStatus("ExportUnitSource: File name empty", nil) end
  local sNm = GetOpVar("DIRPATH_BASE")..GetOpVar("DIRPATH_SAVE")..sNm..".txt"
  local ioF = file.Open(sNm, "wb", "DATA")
  if(not ioF) then
    return LogStatus("ExportUnitSource: Failed to open file <"..sNm..">", nil) end
  local sKey, ID = GetOpVar("HASH_ENTITY"), 1
  local tData = {ExportInitString(GetGeneralTable(eMag), GetOpVar("TYPE_GENERAL")),
                 ExportInitString(eMag[sKey].Sensors   , GetOpVar("TYPE_SENSOR")) ,
                 ExportInitString(eMag[sKey].Forcers   , GetOpVar("TYPE_FORCER")) ,
                 ExportInitString(eMag[sKey].Control   , GetOpVar("TYPE_CONTROL"))}
  while(tData[ID]) do
    local tSet, ST = tData[ID], 1
    while(tSet[ST]) do
      ioF:Write(tostring(tSet[ST]).."\n"); ST = ST + 1
    end; ioF:Write("\n"); ID = ID + 1
  end; ioF:Flush() ioF:Close()
end

function NotifyUser(pPly,sText,sType)
  if(SERVER) then -- Send notification to client that something happened
    pPly:SendLua("GAMEMODE:AddNotify(\""..sText.."\", NOTIFY_"..sType..", 6)")
    pPly:SendLua("surface.PlaySound(\"ambient/water/drip"..mathRandom(1, 4)..".wav\")")
  end
end

local function onMaglevModuleRemove(ent, ...)
  local remID = {...}; for k, v in pairs(remID) do numpad.Remove(v) end
  LogStatus("onMaglevModuleRemove: Numpad removed <"..tostring(ent)..">")
end

function NewMaglevModule(oPly, vPos, aAng, stMaglevData)
  local sLimit = GetOpVar("NAME_ENTITY").."s"
  if(not oPly:CheckLimit(sLimit)) then
    return LogStatus("NewMaglevModule: Maglev module limit reached", nil) end
  local eDye = (stMaglevData.Dye and stMaglevData.Dye or Color(255, 255, 255, 255))
  local sNam = GetOpVar("NAME_TOOL")                -- Get the creator tool
  local eMag = ents.Create(GetOpVar("FILE_ENTITY")) -- Create the thing
  if(eMag and eMag:IsValid()) then                  -- Setup the module entity if valid
    eMag:SetPos(vPos)                               -- Set position
    eMag:SetAngles(aAng)                            -- Set orientation
    eMag:SetModel(stMaglevData.Prop)                -- Use the model given
    eMag:Spawn()                                    -- Make the ENT:Initialize run once
    eMag:SetPlayer(oPly)                            -- Set the player who has spawned it
    eMag:SetColor(eDye)                             -- Apply the color if given
    eMag:SetRenderMode(RENDERMODE_TRANSALPHA)       -- Use the alpha of the color given
    eMag:SetCollisionGroup(COLLISION_GROUP_NONE)    -- Normal collision: https://wiki.garrysmod.com/page/Enums/COLLISION
    eMag:SetNotSolid(false)                         -- Make it collide like a solid
    eMag:CallOnRemove("MaglevModuleNumpadCleanup", onMaglevModuleRemove,
      numpad.OnDown(oPly, stMaglevData.KeyOn, sNam.."_Power_On"        , eMag ),
      numpad.OnDown(oPly, stMaglevData.KeyF , sNam.."_ForceForward_On" , eMag ),
      numpad.OnUp  (oPly, stMaglevData.KeyF , sNam.."_ForceForward_Off", eMag ),
      numpad.OnDown(oPly, stMaglevData.KeyR , sNam.."_ForceReverse_On" , eMag ),
      numpad.OnUp  (oPly, stMaglevData.KeyR , sNam.."_ForceReverse_Off", eMag ))
    if(not eMag:Setup(stMaglevData)) then eMag:Remove() -- Setup the data and controllers
      return LogStatus("NewMaglevModule: Setup module invalid", nil) end
    eMag:Activate()                                 -- Start ENT:Think method run in real-time
    oPly:AddCount  (sLimit, eMag)                   -- Register entity to the max count
    oPly:AddCleanup(sLimit, eMag)                   -- Register entity to the cleanup list
    return LogStatus("NewMaglevModule: Success <"..tostring(eMag)..">", eMag);
  end; return LogStatus("NewMaglevModule: Entity invalid", nil)
end

function GetLibraryData() return libOpVars end

function TranslateProperty(tProp)
  if(not IsString(tProp.Type)) then
    return LogStatus("TranslateProperty: Property type invalid", false) end
  local kTab, sNam = GetOpVar("TRANSLATE_KEYTAB"), GetOpVar("NAME_TOOL")
  local sPrf = ("tool."..sNam.."."..tProp.Type.."_")
  for ID = 1, #tProp do
    local key = tProp[ID][2]; if(not key) then
      return LogStatus("TranslateProperty: Key missing {"..tProp.Type..":"..ID.."}", false) end
    for k, v in pairs(kTab) do
      tProp[ID][k] = languageGetPhrase(sPrf..v..key:lower()) end
  end; return true
end