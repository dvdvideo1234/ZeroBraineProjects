require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")
require("ZeroBraineProjects/dvdlualib/asmlib")

local stringExplode = string.Explode
local stringSub   =  string.sub
local stringFind  = string.find
local stringFormat = string.format

asmlib.InitAssembly("track")

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
 


local Q  = "select * from pieces where model = 'models/test.mdl' and id = 1 and kookoo = 54 order by lineid;"



-- local stRec = asmlib.CacheQueryPiece("models/test.mdl")

logStatus(nil,"STMT: <"..tostring(Q)..">")
logStatus(nil,"INP: <"..tostring(asmlib.SQLStoreSelect("test_", Q).Stmt)..">")
logStatus(nil,"OUT: <"..tostring(asmlib.SQLFetchSelect("test_", "models/test.mdl", 1,6))..">")

--asmlib.Print(defTable,"defTable")

logTable(asmlib.GetOpVar("QUERY_STORE"),"Store")



