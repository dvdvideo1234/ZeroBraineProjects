package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

local common = require("common")
require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
require("../dvdlualib/common")

asmlib.InitBase("track", "assembly")
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.SetOpVar("DATE_FORMAT","%d-%m-%y")
asmlib.SetOpVar("TIME_FORMAT","%H:%M:%S")
asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("S",4,5,6,7)
asmlib.SetOpVar("DIRPATH_BAS", "Assembly/")

asmlib.CreateTable("PIECES",{
  Timer = asmlib.TimerSetting("CQT@10@1@1"),
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


local data = asmlib.GetCache("TRACKASSEMBLY_PIECES")

asmlib.ImportDSV("PIECES", true, "ex_")

local sArg = "#1,@2,@-3"
local nT = 400

local function f1(sA)
  local t = asmlib.DecodePOA(sA)
  if(t) then t[7] = tostring(t[7]) end
  return (t and table.concat(t, ",") or "nil")
end

local function f2(sA)
  local t = asmlib.NewDecodePOA(sA)
  if(t) then t[7] = tostring(t[7]) end
  return (t and table.concat(t, ",") or "nil")
end

local function f3(sA)
  local t = asmlib.ComDecodePOA(sA)
  if(t) then t[7] = tostring(t[7]) end
  return (t and table.concat(t, ",") or "nil")
end

local stCard = {
  {nil     , "nil" , "NIL", nT, nT, .2},
  {""      , "0,0,0,1,1,1,false" , "0", nT, nT, .2},
  {"1"     , "1,0,0,1,1,1,false" , "1", nT, nT, .2},
  {"1,2"   , "1,2,0,1,1,1,false" , "2", nT, nT, .2},
  {"1,2,3" , "1,2,3,1,1,1,false" , "3", nT, nT, .2},
  {"@1,2,3", "1,2,3,-1,1,1,false" , "4", nT, nT, .2},
  {"1,@2,3", "1,2,3,1,-1,1,false" , "5", nT, nT, .2},
  {"1,2,@3", "1,2,3,1,1,-1,false" , "6", nT, nT, .2},
  {"#"      , "0,0,0,1,1,1,true" , "7", nT, nT, .2},
  {"#1"     , "1,0,0,1,1,1,true" , "8", nT, nT, .2},
  {"#1,2"   , "1,2,0,1,1,1,true" , "9", nT, nT, .2},
  {"#1,2,3" , "1,2,3,1,1,1,true" , "10", nT, nT, .2},
  {"#@1,2,3", "1,2,3,-1,1,1,true" , "11", nT, nT, .2},
  {"#1,@2,3", "1,2,3,1,-1,1,true" , "12", nT, nT, .2},
  {"#1,2,@3", "1,2,3,1,1,-1,true" , "13", nT, nT, .2}
}

local stEstim = {
  addEstim(f1, "DecodePOA"),
  addEstim(f2, "NewDecodePOA"),
  addEstim(f3, "ComDecodePOA")
}

testPerformance(stCard, stEstim, nil, 0.1)










