require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")

function loglog(anyMsg, ...)
  io.write(tostring(anyMsg).."\n"); return ...
end

local print                 = print
local pairs                 = pairs
local type                  = type
local tostring              = tostring
local tonumber              = tonumber
local Vector                = Vector
local Angle                 = Angle
local Color                 = Color
local CurTime               = CurTime
local setmetatable          = setmetatable
local getmetatable          = getmetatable
local collectgarbage        = collectgarbage
local LocalPlayer           = LocalPlayer
local bitBor                = bit and bit.bor
local entsCreate            = ents and ents.Create
local mathAbs               = math and math.abs
local mathClamp             = math and math.Clamp
local undoCreate            = undo and undo.Create
local undoFinish            = undo and undo.Finish
local undoAddEntity         = undo and undo.AddEntity
local undoSetPlayer         = undo and undo.SetPlayer
local undoSetCustomUndoText = undo and undo.SetCustomUndoText
local fileAppend            = fileAppend
local fileExists            = fileExists
local fileOpen              = fileOpen
local stringGsub            = string and string.gsub
local stringFind            = string and string.find
local stringExplode         = string and string.Explode
local cleanupRegister       = cleanup and cleanup.Register
local languageAdd           = language and language.Add
local duplicatorRegisterEntityClass = duplicator and duplicator.RegisterEntityClass

local gsSentFile = "E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/ZeroBraineProjects/Transrapid"
local gsSentName = stringGsub(gsSentFile,"sent_","")
local gsSentLogo = gsSentName:sub(1,1):upper()..gsSentName:sub(2,-1)
local mtSensor  = {}; mtSensor.__type = "sensor"
local mtControl = {}; mtControl.__type = "control"

local bulFlgVar  = bitBor(1,3,7)
local varLogEnab = CreateConVar(gsSentFile.."_logenab", "1", bulFlgVar, "Controls logging for the the "..gsSentLogo:lower())
local varLogFile = CreateConVar(gsSentFile.."_logfile", "1", bulFlgVar, "Controls file output for the"..gsSentLogo:lower())
local varSample  = CreateConVar(gsSentFile.."_tick" , "0.005", bulFlgVar, "Controls the bogie sampling time")
local varFwLocal = CreateConVar(gsSentFile.."_fwloc", "1,0,0", bulFlgVar, "Bogie forward local vector")
local varUpLocal = CreateConVar(gsSentFile.."_uploc", "0,0,1", bulFlgVar, "Bogie up local vector")
local varCnLocal = CreateConVar(gsSentFile.."_cnloc", "0,0,0", bulFlgVar, "Bogie center local vector relative to the position")
local varLevers  = CreateConVar(gsSentFile.."_lever", "250,250,500,62", bulFlgVar, "Bogie angular force levers and gap arms")
local varModel   = CreateConVar(gsSentFile.."_model", "models/ron/maglev/train/slider.mdl", bulFlgVar, "Controls which model to be used for")
local varMass    = CreateConVar(gsSentFile.."_mass" , "1200", bulFlgVar, "Controls the bogie mass")
local varConUD   = CreateConVar(gsSentFile.."_conud", "460,0.2,1740//1.2,1,1", bulFlgVar, "Air gap controller parameters")
local varConLR   = CreateConVar(gsSentFile.."_conlr", "2500,0,2600//1.5,1,1.4", bulFlgVar, "Side deviation controller parameters")
local varConAP   = CreateConVar(gsSentFile.."_conap", "100,0,250//", bulFlgVar, "Pitch controller marameters")
local varConAY   = CreateConVar(gsSentFile.."_conay", "510,0,450//", bulFlgVar, "Yaw controller parameters")
local varConAR   = CreateConVar(gsSentFile.."_conar", "32,0,1200//1.2,1,1.2", bulFlgVar, "Roll controller parameters")
local varClasHit = CreateConVar(gsSentFile.."_clhit", "prop_physics        ,      prop_static   ,prop_dynamic,prop_detail", bulFlgVar, "Entity calss filter")
local varSrSetup = CreateConVar(gsSentFile.."_srset", "base", bulFlgVar, "Entity calss filter")

function loglog(anyMsg, ...)
  if(varLogEnab:GetBool()) then
    local sInst = (CLIENT and "CLIENT") or (SERVER and "SERVER") or "NOINST"
    local sLogs = "["..sInst.."] : "..tostring(anyMsg)
    if(varLogFile:GetBool()) then
      fileAppend(gsSentFile.."/system_log.txt", sLogs.."\n")
    else io.write(sLogs.."\n"); end
  end; return ...
end

local logStatus = loglog

  local function getVectorString(sVec)
    local arVec = stringExplode(",",sVec)
    return Vector(tonumber(arVec[1]) or 0,
                  tonumber(arVec[2]) or 0,
                  tonumber(arVec[3]) or 0) end

  local enField = {["sensor"]  = {["Len"]= true, ["Org"] = true, ["Dir"] = true},
                   ["control"] = {["ID"] = true,["Ref"] = true, ["Tun"] = true, ["Cmb"] = true, ["Rev"] = true, ["Dev"] = true}}
  
  local function typEnabled(sTyp)
    return (sTyp and enField[sTyp]) and true or false end
  
  local function colEnabled(sTyp, sCol)
   if(typEnabled(sTyp)) then
     local tItem = enField[sTyp]
     return (sCol and tItem[sCol])
    end; return false
  end
   
  --[[
    * Transforms a setup line to initialization table
    * sLine  >  The line to transform
    * tBase  >  Base table to store the stuff
  ]]--
  function makLineFile(sLine, tBase)
    local sBase = stringTrim(sLine)
    if(sBase:sub(1,1) == "#") then return true end
    local exp, tab, cnt, typ, key = nil, nil, 1
    for v in sBase:gmatch("{(.-)}") do -- All the items in curly brackets
      local exp = stringExplode(":",v)    -- Explode on : to get key-value pairs
      if(tostring(exp[1] or "") == "") then
        return logStatus("makLineFile: Key missing <["..tostring(cnt).."],"..sBase..">", false) end
      if(exp[1] and not exp[2]) then
        return logStatus("makLineFile: Value missing <["..tostring(cnt).."],"..sBase..">", false) end
      if(cnt == 1) then
        if(not tBase[exp[1]]) then tBase[exp[1]] = {} end
         tBase[exp[1]][exp[2]] = {}; tab = tBase[exp[1]][exp[2]]
        typ, key = exp[1], exp[2]; if(not typEnabled(typ)) then
          return logStatus("makLineFile: Type ["..tostring(cnt).."] <"..exp[1].."> missing", false) end
      else
        if(colEnabled(typ, exp[1])) then
          tab[exp[1]] = stringTrim(exp[2])
        else logStatus("makLineFile: Column <"..exp[1].."> ["..typ.."]"..key.." skipped") end
      end; cnt = cnt + 1
    end; return true
  end

  --[[
    * Transforms a file to initialization table
    * sName  >  The file name to process
  ]]--
  local function getInitFile(sName)
    local ioF = fileOpen(sName, "r", "DATA")
      if(not ioF) then return logStatus("getInitFile: Failed to load source file <"..tostring(sName)..">", nil) end
    local i, tRes, ln, pk = 1, {}, "", false
    while(true) do
      local rd = ioF:read(1)
      if(not rd) then break end
      if(rd == "\n" ) then
        if(not makLineFile(ln,tRes)) then
          return logStatus("getInitFile: Process line <"..ln..">", nil) end
        i, ln = (i + 1), ""
      else; ln = ln..rd end
    end; if(ln ~= "") then
      if(not makLineFile(ln,tRes)) then
        return logStatus("getInitFile: Process last line <"..ln..">", nil) end end
    ioF:close(); return tRes
  end

  function getStringDev(sBase, sRep)
    return sBase:gsub(sRep, "oSens[\""..tostring(sRep).."\"].Val")
  end

  function getInit()
    local arHit = stringExplode(",",varClasHit:GetString());
      for i = 1, #arHit, 1 do arHit[i] = stringGsub(arHit[i],"%s","") end
    local sNam = varSrSetup:GetString()
    if(sNam:sub(1,1) ~= "#") then
      local sSrc, tID = gsSentFile.."/"..sNam.."_init.txt", {}
      if(not fileExists(sSrc, "DATA")) then
        return logStatus("getInit(file): Missing: "..sSrc, nil) end
      local tSet = getInitFile(sSrc); if(not tSet) then
        return logStatus("getInit(file): Failed: "..sSrc, nil) end
      local tSen, tCon = tSet[mtSensor.__type], tSet[mtControl.__type]
      if(not tSen) then return logStatus("getInit(file): Sensors missing: "..sSrc, nil) end
      if(not tCon) then return logStatus("getInit(file): Control missing: "..sSrc, nil) end
      for key, rec in pairs(tSen) do -- Process sensors
        if(not rec["Org"]) then return logStatus("getInit(file): Sensor <"..key.."> invalid origin", nil) end
        if(not rec["Dir"]) then return logStatus("getInit(file): Sensor <"..key.."> invalid direct", nil) end
        rec["Org"], rec["Val"] = getVectorString(rec["Org"]), 0
        rec["Len"] = tonumber(rec["Len"]); if(not (rec["Len"] and rec["Len"] ~= 0)) then
          return logStatus("getInit(file): Sensor <"..key.."> invalid length", nil) end
        if(rec["Hit"]) then -- If the hit list is avalable hire the hitman :D
          rec["Hit"] = stringExplode("/",rec["Hit"])
          for id = 1, #rec["Hit"], 1 do rec["Hit"][id] = stringTrim(rec["Hit"][id]) end
        else rec["Hit"] = arHit end -- If the list is lissing use the console variable
      end -- Sensors done
      for key, rec in pairs(tCon) do -- Process controllers
        rec["Cmb"], rec["Rev"] = tobool(rec["Cmb"]), tobool(rec["Rev"])
        rec["ID"]  = (tonumber(rec["ID"]) or 0); if(rec["ID"] < 1) then
          return logStatus("getInit: Controller <"..key.."> invalid ID", nil) end
        if(tID[rec["ID"]]) then -- Check if the ID is already occupied for deviation
          return logStatus("getInit: Controller <"..key.."> ID #"..rec["ID"].." occupied by "..tID[rec["ID"]], nil) end
        tID[rec["ID"]], rec["Ref"] = key, stringExplode("/",rec["Ref"])
        rec["Ref"][1] = tonumber(stringTrim(rec["Ref"][1])) or 0
        rec["Ref"][2] = (((not rec["Ref"][2]) or (rec["Ref"][2] ~= "")) and rec["Ref"][2] or nil)
        for nam, sen in pairs(tSen) do rec["Dev"] = getStringDev(rec["Dev"], nam) end
        rec["Dev"] = CompileString("function(oSens) return "..rec["Dev"].." end", gsSentFile.."_"..key)
      end; local iID = 1; while(tID[iID]) do tSen[iID], tCon[iID] = 0, 0; iID = iID + 1 end
      collectgarbage(); return logStatus("getInit(file): Success", tSen, tCon)
    else
      local tSen = {0,0,0,0,0,0, -- Actually the error deviations
        ["DFR"] = {Val = 0, Len =  12, Org = Vector( 17,-47,-4.3), Dir = "Up", Hit = arHit},
        ["DBR"] = {Val = 0, Len =  12, Org = Vector(-17,-47,-4.3), Dir = "Up", Hit = arHit},
        ["DFL"] = {Val = 0, Len =  12, Org = Vector( 17, 47,-4.3), Dir = "Up", Hit = arHit},
        ["DBL"] = {Val = 0, Len =  12, Org = Vector(-17, 47,-4.3), Dir = "Up", Hit = arHit},
        ["SFR"] = {Val = 0, Len = -15, Org = Vector( 17,-62, 4.0), Dir = "Rg", Hit = arHit},
        ["SBR"] = {Val = 0, Len = -15, Org = Vector(-17,-62, 4.0), Dir = "Rg", Hit = arHit},
        ["SFL"] = {Val = 0, Len =  15, Org = Vector( 17, 62, 4.0), Dir = "Rg", Hit = arHit},
        ["SBL"] = {Val = 0, Len =  15, Org = Vector(-17, 62, 4.0), Dir = "Rg", Hit = arHit}
      }
      local tCon = {0,0,0,0,0,0, -- Actually the control signal states
        ["UR"] = {ID = 1, Ref = {4.5}, Tun = stringExplode("/",varConUD:GetString()), Cmb = true, Rev = true, -- Positive when falls down (Up-Down-Right)
          Dev = function(oSens) return ((oSens["DFR"].Val < oSens["DBR"].Val) and oSens["DFR"].Val or oSens["DBR"].Val) end
        }, -- Reverse the gap error to avoid positive feedback
        ["UL"] = {ID = 2, Ref = {4.5}, Tun = stringExplode("/",varConUD:GetString()), Cmb = true, Rev = true, -- Positive when falls down (Up-Down-Left)
          Dev = function(oSens) return ((oSens["DFL"].Val < oSens["DBL"].Val) and oSens["DFL"].Val or oSens["DBL"].Val) end
        }, -- Reverse the gap error to avoid positive feedback
        ["LR"] = {ID = 3, Ref = {0.0}, Tun = stringExplode("/",varConLR:GetString()), Cmb = true, Rev = true, -- Positive right (Right-Left)
          Dev = function(oSens) return (((oSens["SFR"].Val < oSens["SBR"].Val) and oSens["SFR"].Val or oSens["SBR"].Val) -
                                        ((oSens["SFL"].Val < oSens["SBL"].Val) and oSens["SFL"].Val or oSens["SBL"].Val)) end
        }, -- Positive entity Y axis is to the left
        ["AP"] = {ID = 4, Ref = {0.0}, Tun = stringExplode("/",varConAP:GetString()), Cmb = true, Rev = true, -- Positive front (Pitch)
          Dev = function(oSens) return (4 * (((oSens["DBR"].Val < oSens["DBL"].Val) and oSens["DBR"].Val or oSens["DBL"].Val) -
                                             ((oSens["DFR"].Val < oSens["DFL"].Val) and oSens["DFR"].Val or oSens["DFL"].Val))) end
        }, -- Use the internal error negation as the reference must be zero
        ["AY"] = {ID = 5, Ref = {0.0}, Tun = stringExplode("/",varConAY:GetString()), Cmb = true, Rev = false, -- Positive right (Yaw)
          Dev = function(oSens) return (4 * (((oSens["SFR"].Val < oSens["SBL"].Val) and oSens["SFR"].Val or oSens["SBL"].Val) -
                                             ((oSens["SFL"].Val < oSens["SBR"].Val) and oSens["SFL"].Val or oSens["SBR"].Val))) end
        }, -- Use the internal error negation as the reference must be zero
        ["AR"] = {ID = 6, Ref = {0.0}, Tun = stringExplode("/",varConAR:GetString()), Cmb = true, Rev = true, -- Positive right (Roll)
          Dev = function(oSens) return (4 * (((oSens["DFL"].Val < oSens["DBL"].Val) and oSens["DFL"].Val or oSens["DBL"].Val) -
                                             ((oSens["DFR"].Val < oSens["DBR"].Val) and oSens["DFR"].Val or oSens["DBR"].Val))) end
        }  -- Use the internal error negation as the reference must be zero
      }; collectgarbage(); return logStatus("getInit(struct): Success", tSen, tCon)
    end
  end

local a, b = getInit()
--logTable(a, "sensors")
--logTable(b, "control")


if(false) then


local DataMGL = getInitSetup(dir.."setup_sensors.txt")

function getDeviation(sBase, sRep)
  return sBase:gsub(sRep, "oSens[\""..tostring(sRep).."\"].Val")
end
-- DataMGL["control"]["AP"]["Dev"] = "(4 * (((DBR < DBL) and DBR or DBL) - ((DFR < DFL) and DFR or DFL)))"

-- logTable(DataMGL,"DataMGL")

logStatus(nil,"")
logStatus(nil,"")
logStatus(nil,"")

local stmt = DataMGL["control"]["AP"]["Dev"]

-- logStatus(nil,stmt)

for k, v in pairs(DataMGL["sensor"]) do
  stmt = getDeviation(stmt, k)
end
--logStatus(nil,"")
--logStatus(nil,"")
--logStatus(nil, stmt)

a,b,c,d = pcall(stringTrim, " asdasd  asdasd ", "dfg dfg")

logStatus(nil,"---Pcall---")
logStatus(nil,"<"..stringTrim("   sdfsdfsdf")..">")
logStatus(nil,a)
logStatus(nil,"#"..b)
logStatus(nil,c)
logStatus(nil,d)

end












