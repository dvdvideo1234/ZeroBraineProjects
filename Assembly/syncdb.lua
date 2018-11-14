require("dvdlualib/common")
require("dvdlualib/gmodlib")
require("dvdlualib/asmlib")
local asmlib = trackasmlib
local string = string
      string.Trim = stringTrim
local stringExplode = string.Explode
local stringSub   =  string.sub
local stringFind  = string.find
local stringFormat = string.format
local gaTimerSet = ("CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1"):Explode("/")

asmlib.InitBase("track","assembly")
asmlib.SetOpVar("MODE_DATABASE" , "LUA")
asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("WV",1,2,3)
asmlib.SetIndexes("WA",1,2,3)

asmlib.SetLogControl(1000,false)
asmlib.SetOpVar("DIRPATH_BAS", "E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/Assembly/")

asmlib.CreateTable("PIECES",{
  Timer = gaTimerSet[1],
  Index = {{1},{4},{1,4}},
  Trigs = {
    InsertRecord = function(stRow) 
      local trCls = asmlib.GetOpVar("TRACE_CLASS")
      stRow[2] = asmlib.DisableString(stRow[2],asmlib.DefaultType(),"TYPE")
      stRow[3] = asmlib.DisableString(stRow[3],asmlib.ModelToName(stRow[1]),"MODEL")
      stRow[8] = asmlib.DisableString(stRow[8],"NULL","NULL")
      if(not ((stRow[8] == "NULL") or trCls[stRow[8]] or asmlib.IsBlank(stRow[8]))) then
        trCls[stRow[8]] = true; asmlib.LogInstance("Register trace <"..tostring(stRow[8]).."@"..stRow[1]..">") end
    end -- Register the class provided to the trace hit list
  },
  Query = {
    InsertRecord = {"%s","%s","%s","%d","%s","%s","%s","%s"},
    ExportDSV = {2,3,1,4},
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

asmlib.CreateTable("ADDITIONS",{
  Timer = gaTimerSet[2],
  Index = {{1},{4},{1,4}},
  Query = {
    InsertRecord = {"%s","%s","%s","%d","%s","%s","%d","%d","%d","%d","%d","%d"},
    ExportDSV = {1,4},
  },
  [1]  = {"MODELBASE", "TEXT"   , "LOW", "QMK"},
  [2]  = {"MODELADD" , "TEXT"   , "LOW", "QMK"},
  [3]  = {"ENTCLASS" , "TEXT"   ,  nil ,  nil },
  [4]  = {"LINEID"   , "INTEGER", "FLR",  nil },
  [5]  = {"POSOFF"   , "TEXT"   ,  nil ,  nil },
  [6]  = {"ANGOFF"   , "TEXT"   ,  nil ,  nil },
  [7]  = {"MOVETYPE" , "INTEGER", "FLR",  nil },
  [8]  = {"PHYSINIT" , "INTEGER", "FLR",  nil },
  [9]  = {"DRSHADOW" , "INTEGER", "FLR",  nil },
  [10] = {"PHMOTION" , "INTEGER", "FLR",  nil },
  [11] = {"PHYSLEEP" , "INTEGER", "FLR",  nil },
  [12] = {"SETSOLID" , "INTEGER", "FLR",  nil },
},true,true)


asmlib.DefaultTable("PIECES")
asmlib.DefaultType("Minis")
asmlib.InsertRecord({"models/minitrains/straight_16.mdl",   "#", "#", 1, "", "", ""})
asmlib.InsertRecord({"models/minitrains/straight_16.mdl",   "#", "#", 2, "", "", ""})
asmlib.DefaultType("PHX Monorail")
asmlib.InsertRecord({"models/props_phx/trains/monorail1.mdl", "#", "Straight Short", 1, "", "", ""})
asmlib.InsertRecord({"models/props_phx/trains/monorail1.mdl", "#", "Straight Short", 2, "", "-", ""})


local myTable = {
  ["models/props_phx/construct/metal_plate1x2.mdl"] = { -- Here goes the model of your pack
    {myType ,"#", 1, "","0,-47.455105,1.482965","0,-90,0",""}, -- The first point parameter
    {myType ,"#", 2, "","0, 47.455105,1.482965","0, 90,0",""}  -- The second point parameter
  },
  ["models/props_phx/construct/windows/window1x2.mdl"] = {
    {myType ,"#", 1, "","0,-23.73248,1.482965","0,-90,0",""},
    {myType ,"#", 2, "","0, 71.17773,1.482965","0, 90,0",""}
  }
}
local myPrefix = "phx_test"
if(not asmlib.SynchronizeDSV("PIECES", myTable, true, myPrefix)) then
  error("Failed to synchronize track pieces")
else -- You are saving me from all the work for manually generating these
  asmlib.LogInstance("TranslateDSV start <"..myPrefix..">")
  if(not asmlib.TranslateDSV("PIECES", myPrefix)) then
    error("Failed to translate DSV into Lua") end
  asmlib.LogInstance("TranslateDSV done <"..myPrefix..">")
end -- Now we have Lua inserts and DSV

