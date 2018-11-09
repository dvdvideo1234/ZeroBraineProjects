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
asmlib.SetOpVar("LOG_DEBUGEN", true)
asmlib.SetLogControl(10000, false)


print(asmlib.CreateTable("PIECES",{
  Timer = "CQT@1800@1@1",
  Index = {{1},{4},{1,4}},
  Query = {
    InsertRecord = {"%s","%s","%s","%d","%s","%s","%s","%s"}
  },
  [1] = {"MODEL" , "TEXT"   , "LOW", "QMK"},
  [2] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [3] = {"NAME"  , "TEXT"   ,  nil , "QMK"},
  [4] = {"LINEID", "INTEGER", "FLR",  nil },
  [5] = {"POINT" , "TEXT"   ,  nil ,  nil },
  [6] = {"ORIGIN", "TEXT"   ,  nil ,  nil },
  [7] = {"ANGLE" , "TEXT"   ,  nil ,  nil },
  [8] = {"CLASS" , "TEXT"   ,  nil ,  nil }
},true,true))
end

local a = asmlib.GetTable("PIECES")
local d = a:GetDefinition()
print("DONE0")
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 1, "", "", "", ""})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 2, "", "", "", ""})
print("DONE1")
common.logTable(asmlib.CacheQueryPiece("models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"))
print("DONE2")