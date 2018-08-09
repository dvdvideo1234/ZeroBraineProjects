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

-- common.logTable(data, "CACHE")





--[[
common.logTable(asmlib.newSort1(data, {"Type", "Slot"}), "CACHE")
common.logTable(asmlib.newSort2(data, {"Type", "Slot"}), "CACHE")

local function quick(tA)
  if(not asmlib.newSort1(unpack(tA))) then return 0 end
  return 1
end

local function table1(tA)
  if(not asmlib.newSort2(unpack(tA))) then return 0 end
  return 1
end

local function table2(tA)
  if(not asmlib.newSort3(unpack(tA))) then return 0 end
  return 1
end

local stEstim = {
  addEstim(quick , "quick"),
  addEstim(table1, "table"),
  addEstim(table2, "local")
}

local stCard = {
  {{data, {"AAA", "Slot"}}  , 1 , "Speed", 10, 10, .2}
}

testPerformance(stCard,stEstim,nil,0.01)

]]

