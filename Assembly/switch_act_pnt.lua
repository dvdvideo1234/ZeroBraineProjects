require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
local common = require("../dvdlualib/common")
local asmlib = trackasmlib

if(asmlib.InitBase("track","assembly")) then
asmlib.SetIndexes("V","x","y","z")
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("WV",1,2,3)
asmlib.SetIndexes("WA",1,2,3)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
-- asmlib.SetOpVar("LOG_DEBUGEN",true)
asmlib.SetLogControl(10000, false)
asmlib.SetOpVar("TRACE_MARGIN", 0.5)
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")

asmlib.CreateTable("PIECES",{
  Timer = "CQT@1800@1@1",
  Index = {{1},{4},{1,4}},
  Trigs = {
    InsertRecord = function(stRow) 
      local trCls = asmlib.GetOpVar("TRACE_CLASS")
      stRow[2] = asmlib.DisableString(stRow[2],asmlib.DefaultType(),"TYPE")
      stRow[3] = asmlib.DisableString(stRow[3],asmlib.ModelToName(stRow[1]),"MODEL")
      stRow[8] = asmlib.DisableString(stRow[8],"NULL","NULL")
      if(not ((stRow[8] == "NULL") or trCls[stRow[8]] or asmlib.IsBlank(stRow[8]))) then
        trCls[stRow[8]] = true ; asmlib.LogInstance("Register trace <"..tostring(stRow[8]).."@"..stRow[1]..">") end
    end -- Register the class provided to the trace hit list
  },
  Query = {
    InsertRecord = {"%s","%s","%s","%d","%s","%s","%s","%s"},
    ExportDSV = {2,3,1,4}
  },
  [1] = {"MODEL" , "TEXT"   , "LOW", "QMK"},
  [2] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [3] = {"NAME"  , "TEXT"   ,  nil , "QMK"},
  [4] = {"LINEID", "INTEGER", "FLR",  nil },
  [5] = {"POINT" , "TEXT"   ,  nil ,  nil },
  [6] = {"ORIGIN", "TEXT"   ,  nil ,  nil },
  [7] = {"ANGLE" , "TEXT"   ,  nil ,  nil },
  [8] = {"CLASS" , "TEXT"   ,  nil ,  nil }
},true,true)

asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 1, "", "!test", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 2, "", "1,2,4", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 3, "", "1,2,4", "!test", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 4, "", "1,2,4", "!test", "aaa"})

local p = asmlib.CacheQueryPiece("models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl")
common.logTable(p,"RECORD")

local TOOL = makeTool(asmlib.GetOpVar("TOOLNAME_NL"))
TOOL.ClientConVar = {
  ["pointid"] = 2,
  ["pnextid"] = 1,
  ["model"] = "models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl",
}

function TOOL:GetPointID()
  return (self:GetClientNumber("pointid") or 1), (self:GetClientNumber("pnextid") or 2)
end

function TOOL:GetModel()
  return tostring(self:GetClientInfo("model") or "")
end

function TOOL:SwitchPoint(vDir, bNxt)
  local oRec = asmlib.CacheQueryPiece(self:GetModel()); if(not oRec) then
    asmlib.LogInstance("Invalid record",gtArgsLogs); return 1, 2 end
  local nDir = (tonumber(vDir) or 0) -- Normalize switch direction
  local pointid, pnextid = self:GetPointID()
  if(bNxt) then pnextid = asmlib.SwitchID(pnextid,nDir,oRec)
  else          pointid = asmlib.SwitchID(pointid,nDir,oRec) end
  if(pnextid == pointid) then pnextid = asmlib.SwitchID(pnextid,nDir,oRec) end
  RunConsoleCommand(gsToolPrefL.."pnextid", pnextid)
  RunConsoleCommand(gsToolPrefL.."pointid", pointid)
  asmlib.LogInstance("("..nDir..","..tostring(bNxt)..") Success",gtArgsLogs)
  return pointid, pnextid
end

print(TOOL:SwitchPoint(1,false))
print(TOOL:SwitchPoint(1,false))
print(TOOL:SwitchPoint(1,false))
print(TOOL:SwitchPoint(1,false))

end