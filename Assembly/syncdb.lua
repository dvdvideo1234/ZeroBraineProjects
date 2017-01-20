require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")
require("ZeroBraineProjects/dvdlualib/asmlib")
local string = string
      string.Trim = stringTrim
local stringExplode = string.Explode
local stringSub   =  string.sub
local stringFind  = string.find
local stringFormat = string.format

asmlib.InitBase("track","assembly")

asmlib.SetOpVar("MODE_DATABASE" , "SQL")

asmlib.CreateTable("PIECES",{
  --Timer = asmlib.TimerSetting(gaTimerSet[1]),
  Index = {{1},{4},{1,4}},
  [1] = {"MODEL" , "TEXT"   , "LOW", "QMK"},
  [2] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [3] = {"NAME"  , "TEXT"   ,  nil , "QMK"},
  [4] = {"LINEID", "INTEGER", "FLR",  nil },
  [5] = {"POINT" , "TEXT"   ,  nil ,  nil },
  [6] = {"ORIGIN", "TEXT"   ,  nil ,  nil },
  [7] = {"ANGLE" , "TEXT"   ,  nil ,  nil },
  [8] = {"CLASS" , "TEXT"   ,  nil ,  nil }
},true,true)

local defTable = asmlib.GetOpVar("DEFTABLE_PIECES")

local tPieces = {
  [[TRACKASSEMBLY_PIECES	models/props_phx/construct/metal_wire1x2.mdl	"PHX Monorail"	#	1	"NULL"	"-0.02664,-23.73248,2.96593"	"0,-90,0"	""]],
  [[TRACKASSEMBLY_PIECES	models/props_phx/construct/metal_wire1x2.mdl	"PHX Monorail"	#	2	"NULL"	"-0.02664,71.17773,2.96593"	"0,90,0"	""]]
}

function loglog(anyMsg, ...)
    local sInst = (CLIENT and "CLIENT") or (SERVER and "SERVER") or "NOINST"
    local sLogs = "["..sInst.."] : "..tostring(anyMsg)
    io.write(sLogs.."\n")
  return ...
end

local function loglogTable(tT,sS)
  local vS = type(sS)
  local vT = type(tT)
  local vK = ""
  if(vT ~= "table") then
    return loglog("{"..vT.."}["..tostring(sS or "Data").."] = <"..tostring(tT)..">",nil) end
  if(next(tT) == nil) then
    return loglog(vS.." = {}",nil) end
  loglog(sS.." = {}",nil)
  for k,v in pairs(tT) do
    if(type(k) == "string") then vK = sS.."[\""..k.."\"]"
    else vK = sS.."["..tostring(k).."]" end
    if(type(v) ~= "table") then
      if(type(v) == "string") then logStatus(vK.." = \""..v.."\"",nil)
      else loglog(vK.." = "..tostring(v),nil) end
    else loglogTable(v,vK) end
  end
end


local Nam = "E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/ZeroBraineProjects/Assembly/ex_sync.txt"

local function SynchronizeDSV(sTable, sDelim, bCommit, sPrefix)
  if(not asmlib.IsString(sTable)) then
    return asmlib.StatusLog(false,"SynchronizeDSV: Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = asmlib.GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return asmlib.StatusLog(false,"SynchronizeDSV: Missing table definition for <"..sTable..">") end
  local F = io.open(Nam)
  if(not F) then return asmlib.StatusLog(false,"ImportDSV: fileOpen("..fName..".txt) Failed") end
  local sLine, tData = "X", {}
  while(sLine) do
    sLine = F:read()
    if(not sLine) then break end
    local tLine = stringExplode(sDelim,sLine)
    if(tLine[1] == defTable.Name) then
      for i = 1, #tLine do
        if(tLine[i]:sub( 1, 1) == "\"") then tLine[i] = tLine[i]:sub(2,-1) end
        if(tLine[i]:sub(-1,-1) == "\"") then tLine[i] = tLine[i]:sub(1,-2) end
        tLine[i] = tLine[i]:Trim()
      end
      local sModel = tLine[2]
      if(not tData[sModel]) then tData[sModel] = {Kept = 0} end
      tModel = tData[sModel]
      lModel = #tModel
      tModel.Kept = tonumber(tLine[5])
      if(not (tModel.Kept and tModel.Kept > 0 and tModel.Kept > lModel and (tModel.Kept-1) == lModel)) then
        return asmlib.StatusLog(false,"SynchronizeDSV: Pont ID desynchronized <"..sTable..">") end
      tModel[tModel.Kept] = {}
      local kModel = tModel[tModel.Kept]
      

      
    else return asmlib.StatusLog(false,"SynchronizeDSV: Table name mismatch <"..sTable..">") end
  end
  F:close()
         
  return tData
end

asmlib.Print(SynchronizeDSV("PIECES","\t",true,"ex_"),"Sync")

asmlib.Print(nil,"Sync")
asmlib.Print("","Sync")
asmlib.Print(1,"Sync")
asmlib.Print("test","Sync")
asmlib.Print({},"Sync")
