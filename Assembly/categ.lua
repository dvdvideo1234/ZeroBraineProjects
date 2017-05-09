require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")
require("ZeroBraineProjects/dvdlualib/asmlib")
local string = string
      string.Trim = stringTrim
local stringExplode = string.Explode
local stringSub   =  string.sub
local stringFind  = string.find
local stringFormat = string.format

asmlib.InitBase("track","assembly")

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


asmlib.SetOpVar("DIRPATH_BAS","E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/")
asmlib.SetOpVar("DIRPATH_DSV","ZeroBraineProjects/Assembly/")


asmlib.ImportCategory(4,"tst_")
asmlib.LogInstance("")
asmlib.Print(asmlib.GetOpVar("TABLE_CATEGORIES"))

local m1 = "models/ron/maglev/track/straight/straight_128.mdl"
local m2 = "models/ron/maglev/support/support_a.mdl"

local f = function(m)
    local function conv(x) return " "..x:sub(2,2):upper() end
    local r = m:gsub("models/ron/maglev/",""):gsub("[\\/]([^\\/]+)$","");
    logStatus(nil,r)
    local t, i, c = {r:rep(1)}, 1, true
    while(c) do
      local n = t[i]:find("[\\/]", 1)
      if(n) then
        t[i+1] = t[i]:sub(n+1,-1); t[i] = t[i]:sub(1,n-1)
        t[i] = (("_"..t[i]):gsub("_%w",conv):sub(2,-1)); i = (i + 1)
      else c, t[i] = false, (("_"..t[i]):gsub("_%w",conv):sub(2,-1)) end 
    end; return t
end
    
asmlib.Print(f(m3))
