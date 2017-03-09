require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")
require("ZeroBraineProjects/dvdlualib/asmlib")
local string = string
      string.Trim = stringTrim
local stringExplode = string.Explode
local stringSub   =  string.sub
local stringFind  = string.find
local stringFormat = string.format

asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("S",4,5,6,7)
asmlib.InitBase("track","assembly")
asmlib.SetOpVar("MODE_DATABASE" , "LUA")

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

asmlib.CreateTable("ADDITIONS",{
  Index = {{1},{4},{1,4}},
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

asmlib.CreateTable("PHYSPROPERTIES",{
  Index = {{1},{2},{1,2}},
  [1] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [2] = {"LINEID", "INTEGER", "FLR",  nil },
  [3] = {"NAME"  , "TEXT"   ,  nil ,  nil }
},true,true)
asmlib.DefaultTable("PIECES")
asmlib.DefaultType("Minis")
asmlib.InsertRecord({"models/minitrains/straight_16.mdl",   "#", "#", 1, "", "", ""})
asmlib.InsertRecord({"models/minitrains/straight_16.mdl",   "#", "#", 2, "", "", ""})
asmlib.DefaultType("PHX Monorail")
asmlib.InsertRecord({"models/props_phx/trains/monorail1.mdl", "#", "Straight Short", 1, "", "", ""})
asmlib.InsertRecord({"models/props_phx/trains/monorail1.mdl", "#", "Straight Short", 2, "", "-", ""})

logTable(164)
local tCache = asmlib.GetCache(asmlib.GetOpVar("DEFTABLE_PIECES").Name)
local tSorted = asmlib.Sort(tCache,nil,{"Type","Name"})
local defTable = asmlib.GetOpVar("DEFTABLE_PIECES")


local stPanel = {}

      stPanel.Kept = 0; local iCnt = 1
      while(tSorted[iCnt]) do
        local vSort = tSorted[iCnt]
        stPanel[iCnt] = {
          [defTable[1][1]] = vSort.Key,
          [defTable[2][1]] = tCache[vSort.Key].Type,
          [defTable[3][1]] = tCache[vSort.Key].Name
        }; stPanel.Kept, iCnt = iCnt, (iCnt + 1)
      end

logTable(stPanel,"stPanel")
logStatus(nil,iID)
