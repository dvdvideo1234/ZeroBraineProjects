require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")
require("ZeroBraineProjects/dvdlualib/asmlib")

asmlib.InitBase("gear", "assembly")
asmlib.SetOpVar("MODE_DATABASE", "LUA")

asmlib.CreateTable("PIECES",{
    Timer = asmlib.TimerSetting("CQT@3600@1@1"),
    Index = {{1},{2},{3},{1,4},{1,2},{2,4},{1,2,3}},
    [1] = {"MODEL" , "TEXT", "LOW", "QMK"},
    [2] = {"TYPE"  , "TEXT",  nil , "QMK"},
    [3] = {"NAME"  , "TEXT",  nil , "QMK"},
    [4] = {"AMESH" , "REAL",  nil ,  nil },
    [5] = {"POINT" , "TEXT",  nil ,  nil },
    [6] = {"ORIGN" , "TEXT",  nil ,  nil },
    [7] = {"ANGLE" , "TEXT",  nil ,  nil },
    [8] = {"CLASS" , "TEXT",  nil ,  nil }
},true,true)

local tData = {
  ["models/props_trainstation/trainstation_clock001.mdl"] = {
    {"Ryuzu","Gearheart",0,"33.158,0,0","0.00034787258482538,0.01172979734838,0.00039185225614347","",""}
  }
}


asmlib.RegisterDSV("aaa","bbb", nil, true)
asmlib.RegisterDSV("aaaaaa","bbbgg", nil, true)
asmlib.RegisterDSV("aaaaaa","ssSSSS", nil, true)

asmlib.RegisterDSV("test","ssSSSS", nil, true)












