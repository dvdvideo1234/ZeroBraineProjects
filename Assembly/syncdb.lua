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
  asmlib.RegisterDSV("Test","ex_")
end 

--asmlib.SynchronizeDSV("PIECES", myTable, true, "ex_")


Data = {}
Data["TRACKASSEMBLY_PHYSPROPERTIES"] = {}
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_TYPES"] = {}
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_TYPES"][1] = "Wood"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_TYPES"][2] = "Terrain"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_TYPES"][3] = "Liquid"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_TYPES"][4] = "Frozen"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_TYPES"]["Kept"] = 4
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"] = {}
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Frozen"] = {}
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Frozen"][1] = "snow"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Frozen"][2] = "ice"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Frozen"][3] = "gmod_ice"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Frozen"]["Kept"] = 3
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Terrain"] = {}
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Terrain"][1] = "dirt"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Terrain"][2] = "grass"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Terrain"][3] = "gravel"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Terrain"][4] = "mud"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Terrain"][5] = "quicksand"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Terrain"][6] = "sand"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Terrain"][7] = "slipperyslime"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Terrain"][8] = "antlionsand"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Terrain"]["Kept"] = 8
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Liquid"] = {}
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Liquid"][1] = "slime"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Liquid"][2] = "water"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Liquid"][3] = "wade"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Liquid"]["Kept"] = 3
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Wood"] = {}
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Wood"][1] = "wood"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Wood"][2] = "Wood_Box"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Wood"][3] = "Wood_Furniture"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Wood"][4] = "Wood_Plank"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Wood"][5] = "Wood_Panel"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Wood"][6] = "Wood_Solid"
Data["TRACKASSEMBLY_PHYSPROPERTIES"]["PROPERTY_NAMES"]["Wood"]["Kept"] = 6
Data["TRACKASSEMBLY_PIECES"] = {}
Data["TRACKASSEMBLY_ADDITIONS"] = {}

--asmlib.ImportDSV("PHYSPROPERTIES",true,"ex_"); asmlib.Print(asmlib.GetCache())

asmlib.GetCache()["TRACKASSEMBLY_PHYSPROPERTIES"] = Data["TRACKASSEMBLY_PHYSPROPERTIES"]

asmlib.ExportDSV("PHYSPROPERTIES","ex_")
