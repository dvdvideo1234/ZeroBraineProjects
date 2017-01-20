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
local varLogFile = CreateConVar(gsSentFile.."_logfile", "0", bulFlgVar, "Controls file output for the"..gsSentLogo:lower())
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
local varClasHit = CreateConVar(gsSentFile.."_clhit", "prop_physics/prop_static/prop_dynamic/prop_detail", bulFlgVar, "Entity calss filter")
local varSrSetup = CreateConVar(gsSentFile.."_srset", "#base", bulFlgVar, "Entity calss filter")

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
local gsDevItem  = "/"
local gsDevComp  = ","


  local function getVectorString(sVec)
    local arVec = stringExplode(",",sVec)
    return Vector(tonumber(arVec[1]) or 0,
                  tonumber(arVec[2]) or 0,
                  tonumber(arVec[3]) or 0) end

  -- This holds definitions for the maglev initialization OOP dependent

  local enField = {
    [mtSensor.__type]  = {["Len"] = true, ["Org"] = true, ["Dir"] = true, ["Hit"] = true},
    [mtControl.__type] = {["ID"]  = true, ["Ref"] = true, ["Tun"] = true,
                          ["Cmb"] = true, ["Neg"] = true, ["Err"] = true}}

  local function typEnabled(sTyp)
    return (sTyp and enField[sTyp]) end

  local function colEnabled(sTyp, sCol)
    if(typEnabled(sTyp)) then
      local tItem = enField[sTyp]
      return (sCol and tItem[sCol])
    end; return false
  end

  local function getStringDev(sBase, sRep)
    return tostring(sBase):gsub(sRep, "oSens[\""..tostring(sRep).."\"].Val") end

  --[[
    * Transforms a setup line to initialization table
    * sLine  >  The line to transform
    * tBase  >  Base table to store the stuff
  ]]--
  local function setTransform(sLine, tBase) -- Mecha henshin !
    local sBase = sLine:Trim("%s")
    if(sBase:sub(1,1) == "#") then return true end
    local cnt, tab, typ, key = 1
    for v in sBase:gmatch("{(.-)}") do -- All the items in curly brackets
      local exp = stringExplode(":",v) -- Explode on : to get key-value pairs
      local fld, val = exp[1], exp[2]
      if(tostring(fld or "") == "") then
        return logStatus("setTransform: Key missing <["..tostring(cnt).."],"..sBase..">", false) end
      if(fld and not val) then
        return logStatus("setTransform: Value missing <["..tostring(cnt).."],"..sBase..">", false) end
      if(cnt == 1) then
        if(not tBase[fld]) then tBase[fld] = {} end
         tBase[fld][val] = {}; tab = tBase[fld][val]
        typ, key = fld, val; if(not typEnabled(typ)) then
          return logStatus("setTransform: Type ["..tostring(cnt).."] <"..fld.."> missing", false) end
      else
        if(colEnabled(typ, fld)) then
          tab[fld] = val:Trim("%s")
        else logStatus("setTransform: Column <"..fld.."> ["..typ.."]"..key.." skipped") end
      end; cnt = cnt + 1
    end; return true
  end

  local function getDevError(sErr, sCon, stSen)
    local sCo = tostring(sCon) -- Copy a temporary error selection
    local sEr = tostring(sErr):rep(1):Trim("%s")
    for key, sen in pairs(stSen) do
      sEr = sEr:gsub(key, "oSens[\""..tostring(key).."\"].Val") end
    return CompileString("function(oSens) return "..sEr.." end", gsSentFile.."_"..sCo)
  end

  --[[
   * Retrieves the table hash hit list
   * Converts {[1] = " prop "} to {["prop"] = true}
  ]]--
  local function getHitList(sCls) -- And hire the hitman :D
    local arHit = stringExplode(gsDevItem,tostring(sCls))
    local arCnt = #arHit
    for iCnt = 1, arCnt, 1 do
      local cls = arHit[iCnt]:gsub("%s","")
      arHit[cls] = true; arHit[iCnt] = nil
    end; return arHit
  end

  --[[
   * Does a post-processing of an initialization parameterization
   * tSen > A table containing sensors parameterization
   * tCon > A table containing controllers parameterization
  ]]--
  local function postProcessInit(tSen, tCon, arHit)
    if(not (tSen and type(tSen) == "table")) then
      return logStatus("postProcessInit: Sensors missing", nil) end
    if(not (tCon and type(tCon) == "table")) then
      return logStatus("postProcessInit: Control missing", nil) end
    for key, rec in pairs(tSen) do -- Process sensors
      rec["Org"], rec["Val"] = getVectorString(rec["Org"]), 0
      rec["Len"] = tonumber(rec["Len"]); if(not (rec["Len"] and rec["Len"] ~= 0)) then
        return logStatus("postProcessInit: Sensor <"..key.."> invalid length", nil) end
      if(rec["Hit"]) then rec["Hit"] = getHitList(rec["Hit"])
      else -- If the hit list is avalable hire the hitman :D
        if(arHit) then rec["Hit"] = arHit else rec["Hit"] = {["prop_physics"] = true} end
      end -- If the list is missing use the console variable ( if given )
    end; local tID = {}-- Sensors done
    for key, rec in pairs(tCon) do -- Process controllers
      rec["Cmb"], rec["Neg"] = tobool(rec["Cmb"]), tobool(rec["Neg"])
      rec["ID"]  = (tonumber(rec["ID"]) or 0); if(rec["ID"] < 1) then
        return logStatus("postProcessInit: Controller <"..key.."> invalid ID", nil) end
      if(tID[rec["ID"]]) then -- Check if the ID is already occupied for deviation
        return logStatus("postProcessInit: Controller <"..key.."> ID #"..rec["ID"].." occupied by "..tID[rec["ID"]], nil) end
      tID[rec["ID"]], rec["Ref"] = key, stringExplode(gsDevItem,rec["Ref"])
      rec["Ref"][1] = tonumber(stringTrim(rec["Ref"][1])) or 0
      logStatus("In: "..tostring(rec["Ref"][2]))
      rec["Ref"][2] = (((not rec["Ref"][2]) or (rec["Ref"][2] ~= "")) and rec["Ref"][2] or nil)
      logStatus("Ou: "..tostring(rec["Ref"][2] or "NIL"))
      rec["Dev"] = getDevError(rec["Err"], key, tSen) -- Defune the deviation function for the error
    end; local iID = 1; while(tID[iID]) do tSen[iID], tCon[iID] = 0, 0; iID = iID + 1 end
    return logStatus("postProcessInit: Success", tSen, tCon)
  end

local stMaglevData = {} 


local function GetParameters(srSet, lsHit)
    local srSet, tSet  = tostring(srSet):Trim("%s"), {}
    local tySen, tyCon = mtSensor.__type, mtControl.__type
    local arHit = lsHit and getHitList(tostring(lsHit))
    logStatus("Hit: Begin "..tostring(lsHit))
    if(srSet:sub(1,1) == "#") then -- Use a file
      local sFile, tID = gsSentFile.."/"..srSet:sub(2,-1)..".txt", {}
      if(not fileExists(sFile, "DATA")) then
        return logStatus("ENT.InitSource(file): Missing: "..sFile, nil) end
      local ioF = fileOpen(sFile, "r", "DATA")
      if(not ioF) then
        return logStatus(nil, "ENT.InitSource(file): Failed to load source file <"..tostring(sName)..">") end
      local cnt, ln, pk = 1, "", false
      while(true) do
        local rd = ioF:read(1); if(not rd) then break end
        if(rd == "\n") then
          if(not setTransform(ln, tSet)) then
            return logStatus(nil, "ENT.InitSource(file): Process failed <"..ln..">") end
            cnt, ln = (cnt + 1), ""
        else ln = ln..rd end
      end
      if(ln ~= "") then
        if(not setTransform(ln, tSet)) then
          return logStatus(nil, "ENT.InitSource(file): Process last failed <"..ln..">") end
      end; ioF:close()
      local tSen, tCon = postProcessInit(tSet[tySen], tSet[tyCon], arHit)
      collectgarbage(); return logStatus("ENT.InitSource(file): Success", tSen, tCon)
    elseif(srSet:sub(1,1) == "@") then logStatus(srSet)
      local tInit = stringExplode("@",srSet)
        for iCnt  = 1, #tInit, 1 do
          local ln = tInit[iCnt]:Trim("%s")
          if(not setTransform(ln, tSet)) then
            return logStatus("ENT.InitSource(string): Process failed <"..ln..">",nil,nil) end
        end
      local tSen, tCon = postProcessInit(tSet[tySen], tSet[tyCon], arHit)
      collectgarbage(); return logStatus("ENT.InitSource(string): Success", tSen, tCon)
    else
      local tInit = {
        "{"..tySen..":DFR}{Len: 12}{Org: 17,-47,-4.3}{Dir:Up}",
        "{"..tySen..":DBR}{Len: 12}{Org:-17,-47,-4.3}{Dir:Up}",
        "{"..tySen..":DFL}{Len: 12}{Org: 17, 47,-4.3}{Dir:Up}",
        "{"..tySen..":DBL}{Len: 12}{Org:-17, 47,-4.3}{Dir:Up}",
        "{"..tySen..":SFR}{Len:-15}{Org: 17,-62, 4.0}{Dir:Rg}",
        "{"..tySen..":SBR}{Len:-15}{Org:-17,-62, 4.0}{Dir:Rg}",
        "{"..tySen..":SFL}{Len: 15}{Org: 17, 62, 4.0}{Dir:Rg}",
        "{"..tySen..":SBL}{Len: 15}{Org:-17, 62, 4.0}{Dir:Rg}",
        "{"..tyCon..":UR}{ID:1}{Ref:4.5}{Tun:"..varConUD:GetString().."}{Cmb:true}{Neg:true }{Err:((DFR < DBR) and DFR or DBR)}",
        "{"..tyCon..":UL}{ID:2}{Ref:4.5}{Tun:"..varConUD:GetString().."}{Cmb:true}{Neg:true }{Err:((DFL < DBL) and DFL or DBL)}",
        "{"..tyCon..":LR}{ID:3}{Ref:0.0}{Tun:"..varConLR:GetString().."}{Cmb:true}{Neg:true }{Err:(((SFR < SBR) and SFR or SBR) - ((SFL < SBL) and SFL or SBL))}",
        "{"..tyCon..":AP}{ID:4}{Ref:0.0}{Tun:"..varConAP:GetString().."}{Cmb:true}{Neg:true }{Err:(4 * (((DBR < DBL) and DBR or DBL) - ((DFR < DFL) and DFR or DFL)))}",
        "{"..tyCon..":AY}{ID:5}{Ref:0.0}{Tun:"..varConAY:GetString().."}{Cmb:true}{Neg:false}{Err:(4 * (((SFR < SBL) and SFR or SBL) - ((SFL < SBR) and SFL or SBR)))}",
        "{"..tyCon..":AR}{ID:6}{Ref:0.0}{Tun:"..varConAR:GetString().."}{Cmb:true}{Neg:true }{Err:(4 * (((DFL < DBL) and DFL or DBL) - ((DFR < DBR) and DFR or DBR)))}"
      }
      for iCnt = 1, #tInit, 1 do
        local ln = tInit[iCnt]
        if(not setTransform(ln, tSet)) then
          return logStatus("ENT.InitSource(table): Process failed <"..ln..">",nil,nil) end
      end
      local tSen, tCon = postProcessInit(tSet[tySen], tSet[tyCon], arHit)
      collectgarbage(); return logStatus("ENT.InitSource(table): Success", tSen, tCon)
    end
  end

ttStr = [[
  @{sensor:DFR}{Len: 12}{Org: 17,-47,-4.3}{Dir:Up}
  @{control:UR} {ID:1} {Ref:4.5} {Tun:460,0.2,1740//1.2,1,1}  {Cmb:true} {Neg:true}  {Err:((DFR < DBR) and DFR or DBR)}
]]

ttFil = "#base_init"
  
function ExpParameters(sFile)
   local self = {DataMGL={}}
  self.DataMGL.Sensors, self.DataMGL.Control = GetParameters(ttFil,varClasHit:GetString())

 --logTable(self.DataMGL.Sensors, "Sensors")
 logTable(self.DataMGL.Control, "Control")

    local sNm = gsSentFile.."/"..tostring(sFile or "default")..".txt"
    local ioF = fileOpen(sNm, "w+", "DATA")
    if(not ioF) then
      return logStatus(nil, "ENT.ExportSource: Failed to open file <"..sNm..">") end
    local tSen, tCon = self.DataMGL.Sensors, self.DataMGL.Control
    for key, sen in pairs(tSen) do
      if(not tonumber(sen)) then
        ioF:write("{"..mtSensor.__type..":"..key.."}")
        for col, val in pairs(sen) do
          if(col == "Hit") then
            local lst = "";  for hit, _ in pairs(val) do lst = lst.."/"..hit end
            ioF:write("{"..col..":"..lst:sub(2,-1).."}")
          elseif(col == "Org") then
            ioF:write("{"..col..":"..val.x..gsDevComp..val.y..gsDevComp..val.z.."}")
          elseif(colEnabled(mtSensor.__type, col)) then
            ioF:write("{"..col..":"..tostring(val or "").."}")
          end 
        end; ioF:write("\n")
      end
    end
    for key, con in pairs(tCon) do
      if(not tonumber(con)) then
        ioF:write("{"..mtControl.__type..":"..key.."}")
        for col, val in pairs(con) do
          if(col == "Ref") then
            ioF:write("{"..col..":"..tostring(val[1] or "").."/"..(val[2] and tostring(val[2]) or "").."}")
          elseif(con == "Tun") then
            ioF:write("{"..col..":"..tostring(val[1] or "").."/"..tostring(val[2] or "").."/"..tostring(val[3] or "").."}")
          elseif(colEnabled(mtControl.__type, col)) then
            ioF:write("{"..col..":"..tostring(val).."}")
          end
        end; ioF:write("\n")
      end
    end; ioF:flush() ioF:close()
  end

ExpParameters("base_comp")


local function loglogTable(tT,sS)
  local vS = type(sS)
  local vT = type(tT)
  local vK = ""
  if(vT ~= "table") then
    return logStatus("{"..vT.."}["..tostring(sS or "Data").."] = <"..tostring(tT)..">",nil) end
  if(next(tT) == nil) then
    return logStatus(vS.." = {}",nil) end
  logStatus(sS.." = {}",nil)
  for k,v in pairs(tT) do
    if(type(k) == "string") then vK = sS.."[\""..k.."\"]"
    else vK = sS.."["..tostring(k).."]" end
    if(type(v) ~= "table") then
      if(type(v) == "string") then logStatus(vK.." = \""..v.."\"",nil)
      else logStatus(vK.." = "..tostring(v),nil) end
    else loglogTable(v,vK) end
  end
end


local a = {1,2,{1,["a"]=4}}
local b = 20

loglogTable(nil,"a")
loglogTable(b,"b")
loglogTable("","c")
loglogTable("test","d")
loglogTable(a,"f")




