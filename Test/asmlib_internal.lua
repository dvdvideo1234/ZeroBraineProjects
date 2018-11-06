require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
local common = require("../dvdlualib/common")
local asmlib = trackasmlib

asmlib.InitBase("track","assembly")
asmlib.SetOpVar("MODE_DATABASE", "SQL")
asmlib.SetLogControl(10000, false)


asmlib.CreateTable("PIECES",{
  Index = {{1},{"4"},{1,4}},
  [1] = {"MODEL" , "TEXT"   , "LOW", "QMK"},
  [2] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [3] = {"NAME"  , "TEXT"   ,  nil , "QMK"},
  [4] = {"LINEID", "INTEGER", "FLR",  nil },
  [5] = {"POINT" , "TEXT"   ,  nil ,  nil },
  [6] = {"ORIGIN", "TEXT"   ,  nil ,  nil },
  [7] = {"ANGLE" , "TEXT"   ,  nil ,  nil },
  [8] = {"CLASS" , "TEXT"   ,  nil ,  nil }
},true,true)

local a = asmlib.GetTest("PIECES")

print("ZZZZ", a:Select(1,2):Order():Get():format("'Batman'"))

common.logTable(a:GetCommand())

local g = "asdasdasdasd"

print()




