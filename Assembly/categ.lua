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

local defTable = asmlib.GetOpVar("DEFTABLE_PIECES")




local mod = [[

models/bobsters_trains/rails/2ft/switches/switch_right_switched.mdl
]]

function strBorder(s1, s2) return s2..s1..s2 end
--[[

]]
local foo = 


function(m)
    local function conv(x) return " "..x:sub(2,2):upper() end
    local r, o = m:gsub("models/bobsters_trains/rails/2ft/",""):gsub("_","/")
    local s = r:find("/"); g = (s and r:sub(1,s-1) or "");
    if(g == "") then return nil end
    if(g == "straight") then
      local r = r:sub(s+1,-1)
      local e = r:find("/"); r = e and r:sub(1,e-1) or nil; o = {g,r}
    elseif(g == "curves") then
      local r = r:sub(s+1,-1); r = r:gsub("curve/","")
      local e = r:find("/"); r = (not tonumber(r:sub(1,1))) and (e and r:sub(1,e-1) or nil) or nil; o = {g,r}
    elseif(g == "switches") then
      local r = r:sub(s+1,-1); r = r:gsub("switch/","")
      local e = r:find("/"); r = e and r:sub(1,e-1) or nil; o = {g,r}
    else o = {g} end
    for i = 1, #o do o[i] = ("_"..o[i]):gsub("_%w", conv):sub(2,-1) end; return o
  end

local path, name = foo(mod:Trim("%s"))

logTable(path); asmlib.StatusLog(nil,asmlib.IsString(nil))
