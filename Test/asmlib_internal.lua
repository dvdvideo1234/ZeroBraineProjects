require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
local common = require("../dvdlualib/common")
local asmlib = trackasmlib

if(asmlib.InitBase("track","assembly")) then
asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("WV",1,2,3)
asmlib.SetIndexes("WA",1,2,3)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.SetOpVar("LOG_DEBUGEN",nil)
asmlib.SetLogControl(10000, false)


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

local a = asmlib.GetTable("PIECES")
local d = a:GetDefinition()
local c = a:GetCommand()

asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 1, "", "", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 2, "", "", "", "aaa"})
local p = asmlib.CacheQueryPiece("models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl")

--[[
common.logTable(asmlib.GetTable())
common.logTable(c,"CMD")
common.logTable(p,"RECORD")
]]
print(("N/A"):gsub("^%W+", ""):gsub("\\","/"))

print(a:GetColumnID("LINEID"))

end