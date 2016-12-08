require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")
require("ZeroBraineProjects/dvdlualib/asmlib")

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
  [7] = {"ANGLE" , "TEXT"   ,  nil ,  nil }
},true,true)

local defTable = asmlib.GetOpVar("DEFTABLE_PIECES")


local sModel = "models/track_32.mdl"

local Q = asmlib.SQLFetchSelect("CacheQueryPiece", sModel)
if(not Q) then
  Q = asmlib.SQLBuildSelect(defTable,nil,{{1,sModel}},{4})
      logTable(asmlib.SQLStoreSelect("CacheQueryPiece", Q),"OUT")
else  logStatus(nil, "GET: <"..Q..">") end


local Q = asmlib.SQLFetchSelect("CacheQueryPiece", sModel)
if(not Q) then
  Q = asmlib.SQLBuildSelect(defTable,nil,{{1,sModel}},{4})
      logTable(asmlib.SQLStoreSelect("CacheQueryPiece", Q),"OUT")
else  logStatus(nil, "GET: <"..Q..">") end

