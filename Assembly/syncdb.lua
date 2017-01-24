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

local defTable = asmlib.GetOpVar("DEFTABLE_PIECES")



local myTable = {
  ["models/props_phx/construct/metal_plate1x2.mdl"] = { -- Here goes the model of your pack
    {myType ,"#", 1, "","-0.02664,-47.455105,2.96593","0,-90,0",""}, -- The first point parameter
    {myType ,"#", 2, "","-0.02664, 47.455105,2.96593","0, 90,0",""}  -- The second point parameter
  },
  ["models/props_phx/construct/windows/window1x2.mdl"] = {
    {myType ,"#", 1, "","-0.02664,-23.73248,2.96593","0,-90,0",""},
    {myType ,"#", 2, "","-0.02664, 71.17773,2.96593","0, 90,0",""}
  }
}


local Nam = "E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/ZeroBraineProjects/Assembly/ex_sync.txt"

asmlib.SetOpVar("DIRPATH_BAS", "E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/ZeroBraineProjects/Assembly/")
asmlib.SetOpVar("DIRPATH_DSV", "dsv/")


local sPath = asmlib.GetOpVar("DIRPATH_BAS")..asmlib.GetOpVar("DIRPATH_DSV").."ex_"
                ..asmlib.GetOpVar("DEFTABLE_PIECES").Name..".txt"

asmlib.SetOpVar("GAME_SINGLE", true)
asmlib.SetOpVar("GAME_CLIENT", false)


if(not fileExists(sPath)) then
  asmlib.RegisterDSV("ex_","Test","\t")
end

asmlib.SynchronizeDSV("PIECES","\t",true,myTable,"ex_","Test")

asmlib.ProcessDSV("\t")

-- asmlib.ImportDSV("PIECES","\t",true,"ex_")

asmlib.Print(asmlib.GetCache())
