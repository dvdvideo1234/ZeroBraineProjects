-- Source File https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/lua/autorun/z_autorun_%5Bshinji85_s_rails%5D.lua

local asmlib = trackasmlib
local myAddon = "Ron's 2ft track pack"
local myType = myAddon
local myError = ErrorNoHalt
local myPrefix = myAddon:gsub("[^%w]","_")
local myScript = tostring(debug.getinfo(1).source or "N/A")
      myScript = "@"..myScript:gsub("^%W+", ""):gsub("\\","/")

local function myThrowError(vMesg)
  local sMesg = (myScript.." > ("..myAddon.."): "..tostring(vMesg))
  if(asmlib) then asmlib.LogInstance(sMesg) end; -- myError(sMesg)
end

if(not asmlib) then myThrowError("Failed loading the required module!"); return end

local function mySyncTable(sName, tData, bRepl)
  if(not asmlib.IsEmpty(tData)) then
    asmlib.LogInstance("SynchronizeDSV START <"..myPrefix..">")
    if(not asmlib.SynchronizeDSV(sName, tData, bRepl, myPrefix)) then
      myThrowError("Failed to synchronize: "..sName)
    else
      asmlib.LogInstance("TranslateDSV START <"..myPrefix..">")
      if(not asmlib.TranslateDSV(sName, myPrefix)) then
        myThrowError("Failed to translate DSV: "..sName) end
      asmlib.LogInstance("TranslateDSV OK <"..myPrefix..">")
    end
  else asmlib.LogInstance("SynchronizeDSV EMPTY <"..myPrefix..">") end
end

local function myRegisterDSV(bSkip)
  asmlib.LogInstance("RegisterDSV START <"..myPrefix..">")
  if(bSkip) then
    asmlib.LogInstance("RegisterDSV SKIP <"..myPrefix..">")
  else
    if(not asmlib.RegisterDSV(myScript, myPrefix)) then
      myThrowError("Failed to register DSV")
    end
    asmlib.LogInstance("RegisterDSV OK <"..myPrefix..">")
  end
end

local function myExportCategory(tCatg)
  asmlib.LogInstance("ExportCategory START <"..myPrefix..">")
  if(CLIENT) then
    if(not asmlib.IsEmpty(tCatg)) then
      if(not asmlib.ExportCategory(3, tCatg, myPrefix)) then
        myThrowError("Failed to synchronize category")
      end; asmlib.LogInstance("ExportCategory OK <"..myPrefix..">")
    else asmlib.LogInstance("ExportCategory SKIP <"..myPrefix..">") end
  else asmlib.LogInstance("ExportCategory SERVER <"..myPrefix..">") end
end

local gsMissDB = asmlib.MISS_NOSQL
local gsToolPF = asmlib.TOOLNAME_PU
local gsSymOff = asmlib.OPSYM_DISABLE
local gsFormPF = asmlib.FORM_PREFIXDSV
local myDsv = asmlib.DIRPATH_BAS..
              asmlib.DIRPATH_DSV..
              gsFormPF:format(myPrefix, gsToolPF.."PIECES")
local myFlag = file.Exists(myDsv, "DATA")
asmlib.LogInstance(">>> "..myScript.." ("..tostring(myFlag).."): {"..myAddon..", "..myPrefix.."}")
asmlib.WorkshopID(myAddon, "1512053748")
myRegisterDSV(myFlag)

local myCategory = {
  [myType] = {Txt = [[function(m)
  local function conv(x) return " "..x:sub(2,2):upper() end
  local r = m:gsub("models/ron/2ft/","")
  local s, o, n = r:find("/")
  local g = s and r:sub(1,s-1) or "other"
  if(g == "luajunctions") then
    o = {g}; local e
    n = m:gsub("models/ron/2ft/luajunctions/","")
    n = n:gsub("/junction.mdl",""):gsub("junctions/","junction_")
    e = n:find("/"); n = e and n:sub(1,e-1) or n
  elseif(g == "straight") then
    n, o = r:sub(s+1,-1):gsub("straight_",""):gsub("%.mdl",""), {g}
  elseif(g == "embankment") then
    local e = r:sub(s+1,-1):gsub("embankment_","")
    local s = e:find("%A")
    n, o = e:gsub("%.mdl",""), {g,((s > 1) and (e:sub(1,s-1)) or nil)}
  elseif(g == "ramps") then
    n, o = r:sub(s+1,-1):gsub("ramp_",""):gsub("%.mdl",""), {g}
  elseif(g == "tram") then
    n, o = r:sub(s+1,-1):gsub("tram_",""):gsub("%.mdl",""), {g}
  elseif(g == "turntable") then
    n, o = r:sub(s+1,-1):gsub("turntable_",""):gsub("%.mdl",""), {g}
  elseif(g == "viaduct") then
    n, o = r:sub(s+1,-1):gsub("viaduct_",""):gsub("%.mdl",""), {g}
  elseif(g == "road_crossings") then
    n, o = r:sub(s+1,-1):gsub("road_",""):gsub("%.mdl",""), {g}
  elseif(g == "curves") then
    n, o = r:sub(s+1,-1):gsub("curve_",""):gsub("%.mdl",""), {g}
  else o = {g} end; n = n and ("_"..n):gsub("_%w",conv):sub(2,-1)
  for i = 1, #o do o[i] = ("_"..o[i]):gsub("_%w", conv):sub(2,-1) end; return o, n end]]}
}

myExportCategory(myCategory)

local myPieces = {
  -----------------Misc-----------------
  ["models/ron/2ft/misc/track_bump.mdl"] = {
    {myType ,"Track Bump", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Track Bump", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/misc/buffer.mdl"] = {
    {myType ,"Buffer", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
  },
  ["models/ron/2ft/misc/buffer_2.mdl"] = {
    {myType ,"Buffer Sh2", gsSymOff, "","32,0,6.016","0,0,0",gsMissDB},
    {myType ,"Buffer Sh2", gsSymOff, "","-32,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/misc/buffer_3.mdl"] = {
    {myType ,"Buffer 2", gsSymOff, "","32,0,6.016","0,0,0",gsMissDB},
    {myType ,"Buffer 2", gsSymOff, "","-32,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/misc/rerailer.mdl"] = {
    {myType ,"Rerailer", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"Rerailer", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/misc/passenger_crossing.mdl"] = {
    {myType ,"Passenger Crossing", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Passenger Crossing", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/misc/shed.mdl"] = {
    {myType ,"Shed", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB},
  },
  ["models/ron/2ft/misc/shed_middle.mdl"] = {
    {myType ,"Shed Middle", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB},
  },
  ["models/ron/2ft/misc/shed_left.mdl"] = {
    {myType ,"Shed Left", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB},
  },
  ["models/ron/2ft/misc/shed_right.mdl"] = {
    {myType ,"Shed Right", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB},
  },
  ["models/ron/2ft/misc/90crossing.mdl"] = {
    {myType ,"90 Crossing", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 Crossing", gsSymOff, "","0,64,6.016","0,90,0",gsMissDB},
    {myType ,"90 Crossing", gsSymOff, "","-64,0,6.016","0,-180,0",gsMissDB},
    {myType ,"90 Crossing", gsSymOff, "","0,-64,6.016","0,-90,0",gsMissDB},
  },
  ["models/ron/2ft/misc/track_damaged.mdl"] = {
    {myType ,"Track Damaged", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Track Damaged", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/misc/track_barrier_opened.mdl"] = {
    {myType ,"Track Barrier Open", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Track Barrier Open", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/misc/track_barrier_closed.mdl"] = {
    {myType ,"Track Barrier Closed", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Track Barrier Closed", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Straight-----------------
  ["models/ron/2ft/straight/straight_32.mdl"] = {
    {myType ,"Straight 32", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB},
    {myType ,"Straight 32", gsSymOff, "","-16,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/straight/straight_32_2tracks.mdl"] = {
    {myType ,"Straight 32 2 Tracks", gsSymOff, "","16,-62,6.016","0,0,0",gsMissDB},
    {myType ,"Straight 32 2 Tracks", gsSymOff, "","16,62,6.016","0,0,0",gsMissDB},
    {myType ,"Straight 32 2 Tracks", gsSymOff, "","-16,-62,6.016","0,180,0",gsMissDB},
    {myType ,"Straight 32 2 Tracks", gsSymOff, "","-16,62,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/straight/straight_64.mdl"] = {
    {myType ,"Straight 64", gsSymOff, "","32,0,6.016","0,0,0",gsMissDB},
    {myType ,"Straight 64", gsSymOff, "","-32,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/straight/straight_128.mdl"] = {
    {myType ,"Straight 128", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Straight 128", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/straight/straight_256.mdl"] = {
    {myType ,"Straight 256", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"Straight 256", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/straight/straight_320_junction.mdl"] = {
    {myType ,"Straight 320 Junction", gsSymOff, "","160,0,6.016","0,0,0",gsMissDB},
    {myType ,"Straight 320 Junction", gsSymOff, "","-160,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/straight/straight_512.mdl"] = {
    {myType ,"Straight 512", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"Straight 512", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/straight/straight_1024.mdl"] = {
    {myType ,"Straight 1024", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"Straight 1024", gsSymOff, "","-512,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Bridge -----------------
  ["models/ron/2ft/bridges/bridge_pillar.mdl"] = {
    {myType ,"W Pillar", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"W Pillar", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_end.mdl"] = {
    {myType ,"W End", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"W End", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_128.mdl"] = {
    {myType ,"W 128", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"W 128", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_256.mdl"] = {
    {myType ,"W 256", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"W 256", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_512.mdl"] = {
    {myType ,"W 512", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"W 512", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_1024.mdl"] = {
    {myType ,"W 1024", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"W 1024", gsSymOff, "","-512,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Bridge 2-----------------
  ["models/ron/2ft/bridges/bridge_2_pillar.mdl"] = {
    {myType ,"C Pillar", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Pillar", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_end.mdl"] = {
    {myType ,"C End", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"C End", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_32.mdl"] = {
    {myType ,"C 32", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB},
    {myType ,"C 32", gsSymOff, "","-16,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_64.mdl"] = {
    {myType ,"C 64", gsSymOff, "","32,0,6.016","0,0,0",gsMissDB},
    {myType ,"C 64", gsSymOff, "","-32,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_128.mdl"] = {
    {myType ,"C 128", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"C 128", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_256.mdl"] = {
    {myType ,"C 256", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"C 256", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_512.mdl"] = {
    {myType ,"C 512", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"C 512", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_1024.mdl"] = {
    {myType ,"C 1024", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"C 1024", gsSymOff, "","-512,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Bridges Curve-----------------
  ["models/ron/2ft/bridges/bridge_2_curve_90_1.mdl"] = {
    {myType ,"C Curve 90 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 90 1", gsSymOff, "","-1024,-1024,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_90_2.mdl"] = {
    {myType ,"C Curve 90 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 90 2", gsSymOff, "","-1148,-1148,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_90_3.mdl"] = {
    {myType ,"C Curve 90 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 90 3", gsSymOff, "","-1272,-1272,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_90_4.mdl"] = {
    {myType ,"C Curve 90 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 90 4", gsSymOff, "","-1396,-1396,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_45_left_1.mdl"] = {
    {myType ,"C Curve 45 Left 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 45 Left 1", gsSymOff, "","-724.122,-299.876,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_45_left_2.mdl"] = {
    {myType ,"C Curve 45 Left 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 45 Left 2", gsSymOff, "","-811.77,-336.23,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_45_left_3.mdl"] = {
    {myType ,"C Curve 45 Left 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 45 Left 3", gsSymOff, "","-899.503,-372.497,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_45_left_4.mdl"] = {
    {myType ,"C Curve 45 Left 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 45 Left 4", gsSymOff, "","-987.115,-408.885,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_45_right_1.mdl"] = {
    {myType ,"C Curve 45 Right 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 45 Right 1", gsSymOff, "","-724.122,299.876,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_45_right_2.mdl"] = {
    {myType ,"C Curve 45 Right 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 45 Right 2", gsSymOff, "","-811.77,336.23,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_45_right_3.mdl"] = {
    {myType ,"C Curve 45 Right 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 45 Right 3", gsSymOff, "","-899.503,372.497,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/bridges/bridge_2_curve_45_right_4.mdl"] = {
    {myType ,"C Curve 45 Right 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"C Curve 45 Right 4", gsSymOff, "","-987.115,408.885,6.016","0,135,0",gsMissDB}
  },
  -----------------Ramps-----------------
  ["models/ron/2ft/ramps/ramp_32_1.mdl"] = {
    {myType ,"32 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"32 1", gsSymOff, "","-32,0,8.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_64_1.mdl"] = {
    {myType ,"64 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"64 1", gsSymOff, "","-64,0,10.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_128_1.mdl"] = {
    {myType ,"128 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 1", gsSymOff, "","-128,0,14.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_256_1.mdl"] = {
    {myType ,"256 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"256 1", gsSymOff, "","-256,0,22.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_512_1.mdl"] = {
    {myType ,"512 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"512 1", gsSymOff, "","-512,0,38.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_1024_1.mdl"] = {
    {myType ,"1024 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024 1", gsSymOff, "","-1024,0,70.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_start_1.mdl"] = {
    {myType ,"Start 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start 1", gsSymOff, "","-64,0,9.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_end_1.mdl"] = {
    {myType ,"End 1", gsSymOff, "","64,0,3.016","0,0,0",gsMissDB},
    {myType ,"End 1", gsSymOff, "","0,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Embankments-----------------
  ["models/ron/2ft/embankment/embankment_1024.mdl"] = {
    {myType ,"1024", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024", gsSymOff, "","-512,0,6.016","0,-180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_512.mdl"] = {
    {myType ,"512", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"512", gsSymOff, "","-256,0,6.016","0,-180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_256.mdl"] = {
    {myType ,"256", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"256", gsSymOff, "","-128,0,6.016","0,-180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_128.mdl"] = {
    {myType ,"128", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128", gsSymOff, "","-64,0,6.016","0,-180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_64.mdl"] = {
    {myType ,"64", gsSymOff, "","32,0,6.016","0,0,0",gsMissDB},
    {myType ,"64", gsSymOff, "","-32,0,6.016","0,-180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_32.mdl"] = {
    {myType ,"32", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB},
    {myType ,"32", gsSymOff, "","-16,0,6.016","0,-180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_bridge.mdl"] = {
    {myType ,"Bridge", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Bridge", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Embankments Sided-----------------
  ["models/ron/2ft/embankment/embankment_1024_sided.mdl"] = {
    {myType ,"1024 sided", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024 sided", gsSymOff, "","-512,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_512_sided.mdl"] = {
    {myType ,"512 sided", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"512 sided", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_256_sided.mdl"] = {
    {myType ,"256 sided", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"256 sided", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_128_sided.mdl"] = {
    {myType ,"128 sided", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 sided", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_64_sided.mdl"] = {
    {myType ,"64 sided", gsSymOff, "","32,0,6.016","0,0,0",gsMissDB},
    {myType ,"64 sided", gsSymOff, "","-32,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_32_sided.mdl"] = {
    {myType ,"32 sided", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB},
    {myType ,"32 sided", gsSymOff, "","-16,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_bridge_sided.mdl"] = {
    {myType ,"Bridge sided", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Bridge sided", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_bridge_sided_m.mdl"] = {
    {myType ,"Bridge sided M", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Bridge sided M", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Embankments Sided Double-----------------
  ["models/ron/2ft/embankment/embankment_1024_sidedd.mdl"] = {
    {myType ,"1024 double sided", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024 double sided", gsSymOff, "","-512,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_512_sidedd.mdl"] = {
    {myType ,"512 double sided", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"512 double sided", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_256_sidedd.mdl"] = {
    {myType ,"256 double sided", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"256 double sided", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_128_sidedd.mdl"] = {
    {myType ,"128 double sided", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 double sided", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_64_sidedd.mdl"] = {
    {myType ,"64 double sided", gsSymOff, "","32,0,6.016","0,0,0",gsMissDB},
    {myType ,"64 double sided", gsSymOff, "","-32,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_32_sidedd.mdl"] = {
    {myType ,"32 double sided", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB},
    {myType ,"32 double sided", gsSymOff, "","-16,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_bridge_sidedd.mdl"] = {
    {myType ,"Bridge double sided", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Bridge double sided", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Embankments Fittings-----------------
  ["models/ron/2ft/embankment/embankment_fitting.mdl"] = {
    {myType ,"Fitting", gsSymOff, "","0,0,6.016","0,180,0",gsMissDB},
    {myType ,"Fitting", gsSymOff, "","8,0,6.016","0,0,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_fitting_sided.mdl"] = {
    {myType ,"Fitting Sided", gsSymOff, "","0,0,6.016","0,180,0",gsMissDB},
    {myType ,"Fitting Sided", gsSymOff, "","8,0,6.016","0,0,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_fitting_sided_m.mdl"] = {
    {myType ,"Fitting Sided M", gsSymOff, "","0,0,6.016","0,180,0",gsMissDB},
    {myType ,"Fitting Sided M", gsSymOff, "","8,0,6.016","0,0,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_fitting_sidedd.mdl"] = {
    {myType ,"Fitting Double Sided", gsSymOff, "","0,0,6.016","0,180,0",gsMissDB},
    {myType ,"Fitting Double Sided", gsSymOff, "","8,0,6.016","0,0,0",gsMissDB}
  },
  -----------------Embankments Buffers-----------------
  ["models/ron/2ft/embankment/embankment_buffer.mdl"] = {
    {myType ,"Buffer", gsSymOff, "","-40,0,6.016","0,180,0",gsMissDB},
  },
  ["models/ron/2ft/embankment/embankment_buffer_sided.mdl"] = {
    {myType ,"Buffer Sided", gsSymOff, "","-40,0,6.016","0,180,0",gsMissDB},
  },
  ["models/ron/2ft/embankment/embankment_buffer_sided_m.mdl"] = {
    {myType ,"Buffer Sided m", gsSymOff, "","-40,0,6.016","0,180,0",gsMissDB},
  },
  ["models/ron/2ft/embankment/embankment_buffer_sidedd.mdl"] = {
    {myType ,"Buffer Sidedd", gsSymOff, "","-40,0,6.016","0,180,0",gsMissDB},
  },
  -----------------Embankments Ramps-----------------
  ["models/ron/2ft/ramps/ramp_1024_embankment_1.mdl"] = {
    {myType ,"1024 Embankment 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024 Embankment 1", gsSymOff, "","-1024,0,70.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_512_embankment_1.mdl"] = {
    {myType ,"512 Embankment 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"512 Embankment 1", gsSymOff, "","-512,0,38.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_256_embankment_1.mdl"] = {
    {myType ,"256 Embankment 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"256 Embankment 1", gsSymOff, "","-256,0,22.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_128_embankment_1.mdl"] = {
    {myType ,"128 Embankment 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Embankment 1", gsSymOff, "","-128,0,14.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_64_embankment_1.mdl"] = {
    {myType ,"64 Embankment 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"64 Embankment 1", gsSymOff, "","-64,0,10.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_32_embankment_1.mdl"] = {
    {myType ,"32 Embankment 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"32 Embankment 1", gsSymOff, "","-32,0,8.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_start_embankment_1.mdl"] = {
    {myType ,"Start Embankment 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start Embankment 1", gsSymOff, "","-64,0,9.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_end_embankment_1.mdl"] = {
    {myType ,"End Embankment 1", gsSymOff, "","64,0,3.016","0,0,0",gsMissDB},
    {myType ,"End Embankment 1", gsSymOff, "","0,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Embankments Ramps Sided-----------------
  ["models/ron/2ft/ramps/ramp_1024_embankment_sided_1.mdl"] = {
    {myType ,"1024 Embankment Sided 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024 Embankment Sided 1", gsSymOff, "","-1024,0,70.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_512_embankment_sided_1.mdl"] = {
    {myType ,"512 Embankment Sided 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"512 Embankment Sided 1", gsSymOff, "","-512,0,38.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_256_embankment_sided_1.mdl"] = {
    {myType ,"256 Embankment Sided 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"256 Embankment Sided 1", gsSymOff, "","-256,0,22.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_128_embankment_sided_1.mdl"] = {
    {myType ,"128 Embankment Sided 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Embankment Sided 1", gsSymOff, "","-128,0,14.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_64_embankment_sided_1.mdl"] = {
    {myType ,"64 Embankment Sided 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"64 Embankment Sided 1", gsSymOff, "","-64,0,10.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_32_embankment_sided_1.mdl"] = {
    {myType ,"32 Embankment Sided 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"32 Embankment Sided 1", gsSymOff, "","-32,0,8.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_start_embankment_sided_1.mdl"] = {
    {myType ,"Start Embankment Sided 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start Embankment Sided 1", gsSymOff, "","-64,0,9.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_end_embankment_sided_1.mdl"] = {
    {myType ,"End Embankment Sided 1", gsSymOff, "","64,0,3.016","0,0,0",gsMissDB},
    {myType ,"End Embankment Sided 1", gsSymOff, "","0,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Embankments Ramps Sided M-----------------
  ["models/ron/2ft/ramps/ramp_1024_embankment_sided_m_1.mdl"] = {
    {myType ,"1024 Embankment Sided M 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024 Embankment Sided M 1", gsSymOff, "","-1024,0,70.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_512_embankment_sided_m_1.mdl"] = {
    {myType ,"512 Embankment Sided M 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"512 Embankment Sided M 1", gsSymOff, "","-512,0,38.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_256_embankment_sided_m_1.mdl"] = {
    {myType ,"256 Embankment Sided M 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"256 Embankment Sided M 1", gsSymOff, "","-256,0,22.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_128_embankment_sided_m_1.mdl"] = {
    {myType ,"128 Embankment Sided M 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Embankment Sided M 1", gsSymOff, "","-128,0,14.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_64_embankment_sided_m_1.mdl"] = {
    {myType ,"64 Embankment Sided M 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"64 Embankment Sided M 1", gsSymOff, "","-64,0,10.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_32_embankment_sided_m_1.mdl"] = {
    {myType ,"32 Embankment Sided M 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"32 Embankment Sided M 1", gsSymOff, "","-32,0,8.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_start_embankment_sided_m_1.mdl"] = {
    {myType ,"Start Embankment Sided M 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start Embankment Sided M 1", gsSymOff, "","-64,0,9.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_end_embankment_sided_m_1.mdl"] = {
    {myType ,"End Embankment Sided M 1", gsSymOff, "","64,0,3.016","0,0,0",gsMissDB},
    {myType ,"End Embankment Sided M 1", gsSymOff, "","0,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Embankments Ramps Sided Double-----------------
  ["models/ron/2ft/ramps/ramp_1024_embankment_sidedd_1.mdl"] = {
    {myType ,"1024 Embankment Sided Double 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024 Embankment Sided Double 1", gsSymOff, "","-1024,0,70.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_512_embankment_sidedd_1.mdl"] = {
    {myType ,"512 Embankment Sided Double 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"512 Embankment Sided Double 1", gsSymOff, "","-512,0,38.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_256_embankment_sidedd_1.mdl"] = {
    {myType ,"256 Embankment Sided Double 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"256 Embankment Sided Double 1", gsSymOff, "","-256,0,22.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_128_embankment_sidedd_1.mdl"] = {
    {myType ,"128 Embankment Sided Double 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Embankment Sided Double 1", gsSymOff, "","-128,0,14.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_64_embankment_sidedd_1.mdl"] = {
    {myType ,"64 Embankment Sided Double 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"64 Embankment Sided Double 1", gsSymOff, "","-64,0,10.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_32_embankment_sidedd_1.mdl"] = {
    {myType ,"32 Embankment Sided Double 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"32 Embankment Sided Double 1", gsSymOff, "","-32,0,8.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_start_embankment_sidedd_1.mdl"] = {
    {myType ,"Start Embankment Sided Double 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start Embankment Sided Double 1", gsSymOff, "","-64,0,9.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/ramps/ramp_end_embankment_sidedd_1.mdl"] = {
    {myType ,"End Embankment Sided Double 1", gsSymOff, "","64,0,3.016","0,0,0",gsMissDB},
    {myType ,"End Embankment Sided Double 1", gsSymOff, "","0,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Embankments Curves 45 Left-----------------
  ["models/ron/2ft/embankment/embankment_curve_45_left_1.mdl"] = {
    {myType ,"45 Left 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Left 1", gsSymOff, "","-724.122,-299.876,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_2.mdl"] = {
    {myType ,"45 Left 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Left 2", gsSymOff, "","-811.77,-336.23,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_3.mdl"] = {
    {myType ,"45 Left 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Left 3", gsSymOff, "","-899.503,-372.497,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_4.mdl"] = {
    {myType ,"45 Left 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Left 4", gsSymOff, "","-987.115,-408.885,6.016","0,-135,0",gsMissDB}
  },
  -----------------Embankments Curves 45 Left Sided-----------------
  ["models/ron/2ft/embankment/embankment_curve_45_left_sided_1.mdl"] = {
    {myType ,"Sided 45 Left 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 45 Left 1", gsSymOff, "","-724.122,-299.876,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_sided_2.mdl"] = {
    {myType ,"Sided 45 Left 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 45 Left 2", gsSymOff, "","-811.77,-336.23,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_sided_3.mdl"] = {
    {myType ,"Sided 45 Left 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 45 Left 3", gsSymOff, "","-899.503,-372.497,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_sided_4.mdl"] = {
    {myType ,"Sided 45 Left 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 45 Left 4", gsSymOff, "","-987.115,-408.885,6.016","0,-135,0",gsMissDB}
  },
  -----------------Embankments Curves 45 Left Sided M-----------------
  ["models/ron/2ft/embankment/embankment_curve_45_left_sided_m_1.mdl"] = {
    {myType ,"Sided M 45 Left 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 45 Left 1", gsSymOff, "","-724.122,-299.876,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_sided_m_2.mdl"] = {
    {myType ,"Sided M 45 Left 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 45 Left 2", gsSymOff, "","-811.77,-336.23,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_sided_m_3.mdl"] = {
    {myType ,"Sided M 45 Left 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 45 Left 3", gsSymOff, "","-899.503,-372.497,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_sided_m_4.mdl"] = {
    {myType ,"Sided M 45 Left 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 45 Left 4", gsSymOff, "","-987.115,-408.885,6.016","0,-135,0",gsMissDB}
  },
  -----------------Embankments Curves 45 Left Sided Double-----------------
  ["models/ron/2ft/embankment/embankment_curve_45_left_sidedd_1.mdl"] = {
    {myType ,"Sided Double 45 Left 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 45 Left 1", gsSymOff, "","-724.122,-299.876,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_sidedd_2.mdl"] = {
    {myType ,"Sided Double 45 Left 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 45 Left 2", gsSymOff, "","-811.77,-336.23,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_sidedd_3.mdl"] = {
    {myType ,"Sided Double 45 Left 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 45 Left 3", gsSymOff, "","-899.503,-372.497,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_left_sidedd_4.mdl"] = {
    {myType ,"Sided Double 45 Left 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 45 Left 4", gsSymOff, "","-987.115,-408.885,6.016","0,-135,0",gsMissDB}
  },
  -----------------Embankments Curves 45 Right-----------------
  ["models/ron/2ft/embankment/embankment_curve_45_Right_1.mdl"] = {
    {myType ,"45 Right 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Right 1", gsSymOff, "","-724.122,299.876,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_2.mdl"] = {
    {myType ,"45 Right 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Right 2", gsSymOff, "","-811.77,336.23,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_3.mdl"] = {
    {myType ,"45 Right 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Right 3", gsSymOff, "","-899.503,372.497,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_4.mdl"] = {
    {myType ,"45 Right 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Right 4", gsSymOff, "","-987.115,408.885,6.016","0,135,0",gsMissDB}
  },
  -----------------Embankments Curves 45 Right Sided-----------------
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sided_1.mdl"] = {
    {myType ,"Sided 45 Right 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 45 Right 1", gsSymOff, "","-724.122,299.876,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sided_2.mdl"] = {
    {myType ,"Sided 45 Right 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 45 Right 2", gsSymOff, "","-811.77,336.23,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sided_3.mdl"] = {
    {myType ,"Sided 45 Right 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 45 Right 3", gsSymOff, "","-899.503,372.497,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sided_4.mdl"] = {
    {myType ,"Sided 45 Right 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 45 Right 4", gsSymOff, "","-987.115,408.885,6.016","0,135,0",gsMissDB}
  },
  -----------------Embankments Curves 45 Right Sided M-----------------
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sided_m_1.mdl"] = {
    {myType ,"Sided M 45 Right 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 45 Right 1", gsSymOff, "","-724.122,299.876,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sided_m_2.mdl"] = {
    {myType ,"Sided M 45 Right 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 45 Right 2", gsSymOff, "","-811.77,336.23,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sided_m_3.mdl"] = {
    {myType ,"Sided M 45 Right 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 45 Right 3", gsSymOff, "","-899.503,372.497,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sided_m_4.mdl"] = {
    {myType ,"Sided M 45 Right 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 45 Right 4", gsSymOff, "","-987.115,408.885,6.016","0,135,0",gsMissDB}
  },
  -----------------Embankments Curves 45 Right Sided Double-----------------
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sidedd_1.mdl"] = {
    {myType ,"Sided Double 45 Right 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 45 Right 1", gsSymOff, "","-724.122,299.876,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sidedd_2.mdl"] = {
    {myType ,"Sided Double 45 Right 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 45 Right 2", gsSymOff, "","-811.77,336.23,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sidedd_3.mdl"] = {
    {myType ,"Sided Double 45 Right 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 45 Right 3", gsSymOff, "","-899.503,372.497,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_45_Right_sidedd_4.mdl"] = {
    {myType ,"Sided Double 45 Right 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 45 Right 4", gsSymOff, "","-987.115,408.885,6.016","0,135,0",gsMissDB}
  },
  -----------------Embankments Junciton-----------------
  ["models/ron/2ft/embankment/embankment_junction_n_left.mdl"] = {
    {myType ,"N Left", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"N Left", gsSymOff, "","-704,0,6.016","0,180,0",gsMissDB},
    {myType ,"N Left", gsSymOff, "","-704,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_sided_junction_n_left.mdl"] = {
    {myType ,"N Left Sided", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"N Left Sided", gsSymOff, "","-704,0,6.016","0,180,0",gsMissDB},
    {myType ,"N Left Sided", gsSymOff, "","-704,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_sided_m_junction_n_left.mdl"] = {
    {myType ,"N Left Sided m", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"N Left Sided m", gsSymOff, "","-704,0,6.016","0,180,0",gsMissDB},
    {myType ,"N Left Sided m", gsSymOff, "","-704,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_sidedd_junction_n_left.mdl"] = {
    {myType ,"N Left Sidedd", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"N Left Sidedd", gsSymOff, "","-704,0,6.016","0,180,0",gsMissDB},
    {myType ,"N Left Sidedd", gsSymOff, "","-704,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_junction_n_right.mdl"] = {
    {myType ,"N Right", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"N Right", gsSymOff, "","-704,0,6.016","0,180,0",gsMissDB},
    {myType ,"N Right", gsSymOff, "","-704,124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_sided_junction_n_right.mdl"] = {
    {myType ,"N Right Sided", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"N Right Sided", gsSymOff, "","-704,0,6.016","0,180,0",gsMissDB},
    {myType ,"N Right Sided", gsSymOff, "","-704,124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_sided_m_junction_n_right.mdl"] = {
    {myType ,"N Right Sided m", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"N Right Sided m", gsSymOff, "","-704,0,6.016","0,180,0",gsMissDB},
    {myType ,"N Right Sided m", gsSymOff, "","-704,124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_sidedd_junction_n_right.mdl"] = {
    {myType ,"N Right Sidedd", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"N Right Sidedd", gsSymOff, "","-704,0,6.016","0,180,0",gsMissDB},
    {myType ,"N Right Sidedd", gsSymOff, "","-704,124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_junction_s_x.mdl"] = {
    {myType ,"X", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"X", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"X", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB},
    {myType ,"X", gsSymOff, "","  0 ,-62,6.016","0,0,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_sided_junction_s_x.mdl"] = {
    {myType ,"X Sided", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"X Sided", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"X Sided", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB},
    {myType ,"X Sided", gsSymOff, "","  0 ,-62,6.016","0,0,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_sidedd_junction_s_x.mdl"] = {
    {myType ,"X Sidedd", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"X Sidedd", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"X Sidedd", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB},
    {myType ,"X Sidedd", gsSymOff, "","  0 ,-62,6.016","0,0,0",gsMissDB}
  },
  -----------------Embankments Curves 90-----------------
  ["models/ron/2ft/embankment/embankment_curve_90_1.mdl"] = {
    {myType ,"90 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 1", gsSymOff, "","-1024,-1024,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_2.mdl"] = {
    {myType ,"90 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 2", gsSymOff, "","-1148,-1148,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_3.mdl"] = {
    {myType ,"90 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 3", gsSymOff, "","-1272,-1272,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_4.mdl"] = {
    {myType ,"90 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 4", gsSymOff, "","-1396,-1396,6.016","0,-90,0",gsMissDB}
  },
  -----------------Embankments Curves 90 sided-----------------
  ["models/ron/2ft/embankment/embankment_curve_90_sided_1.mdl"] = {
    {myType ,"Sided 90 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 90 1", gsSymOff, "","-1024,-1024,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_sided_2.mdl"] = {
    {myType ,"Sided 90 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 90 2", gsSymOff, "","-1148,-1148,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_sided_3.mdl"] = {
    {myType ,"Sided 90 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 90 3", gsSymOff, "","-1272,-1272,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_sided_4.mdl"] = {
    {myType ,"Sided 90 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided 90 4", gsSymOff, "","-1396,-1396,6.016","0,-90,0",gsMissDB}
  },
  -----------------Embankments Curves 90 Sided M-----------------
  ["models/ron/2ft/embankment/embankment_curve_90_sided_m_1.mdl"] = {
    {myType ,"Sided M 90 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 90 1", gsSymOff, "","-1024,-1024,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_sided_m_2.mdl"] = {
    {myType ,"Sided M 90 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 90 2", gsSymOff, "","-1148,-1148,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_sided_m_3.mdl"] = {
    {myType ,"Sided M 90 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 90 3", gsSymOff, "","-1272,-1272,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_sided_m_4.mdl"] = {
    {myType ,"Sided M 90 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided M 90 4", gsSymOff, "","-1396,-1396,6.016","0,-90,0",gsMissDB}
  },
  -----------------Embankments Curves 90 sided Double-----------------
  ["models/ron/2ft/embankment/embankment_curve_90_sidedd_1.mdl"] = {
    {myType ,"Sided Double 90 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 90 1", gsSymOff, "","-1024,-1024,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_sidedd_2.mdl"] = {
    {myType ,"Sided Double 90 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 90 2", gsSymOff, "","-1148,-1148,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_sidedd_3.mdl"] = {
    {myType ,"Sided Double 90 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 90 3", gsSymOff, "","-1272,-1272,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/embankment/embankment_curve_90_sidedd_4.mdl"] = {
    {myType ,"Sided Double 90 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Sided Double 90 4", gsSymOff, "","-1396,-1396,6.016","0,-90,0",gsMissDB}
  },
  -----------------22.5 Left-----------------
  ["models/ron/2ft/curves/curve_225_left_1.mdl"] = {
    {myType ,"22.5 Left 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"22.5 Left 1", gsSymOff, "","-391.846,-77.978,6.016","0,-157.5,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_225_left_2.mdl"] = {
    {myType ,"22.5 Left 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"22.5 Left 2", gsSymOff, "","-439.352,-87.36,6.016","0,-157.5,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_225_left_3.mdl"] = {
    {myType ,"22.5 Left 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"22.5 Left 3", gsSymOff, "","-486.814,-96.707,6.016","0,-157.5,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_225_left_4.mdl"] = {
    {myType ,"22.5 Left 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"22.5 Left 4", gsSymOff, "","-532.889,-105.687,6.016","0,-157.5,0",gsMissDB}
  },
  -----------------22.5 Right-----------------
  ["models/ron/2ft/curves/curve_225_Right_1.mdl"] = {
    {myType ,"22.5 Right 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"22.5 Right 1", gsSymOff, "","-391.846,77.978,6.016","0,157.5,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_225_Right_2.mdl"] = {
    {myType ,"22.5 Right 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"22.5 Right 2", gsSymOff, "","-439.352,87.36,6.016","0,157.5,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_225_Right_3.mdl"] = {
    {myType ,"22.5 Right 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"22.5 Right 3", gsSymOff, "","-486.814,96.707,6.016","0,157.5,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_225_Right_4.mdl"] = {
    {myType ,"22.5 Right 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"22.5 Right 4", gsSymOff, "","-532.866,105.763,6.016","0,157.5,0",gsMissDB}
  },
  -----------------45 Left-----------------
  ["models/ron/2ft/curves/curve_45_left_1.mdl"] = {
    {myType ,"45 Left 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Left 1", gsSymOff, "","-724.122,-299.876,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_45_left_2.mdl"] = {
    {myType ,"45 Left 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Left 2", gsSymOff, "","-811.77,-336.23,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_45_left_3.mdl"] = {
    {myType ,"45 Left 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Left 3", gsSymOff, "","-899.503,-372.497,6.016","0,-135,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_45_left_4.mdl"] = {
    {myType ,"45 Left 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Left 4", gsSymOff, "","-987.115,-408.885,6.016","0,-135,0",gsMissDB}
  },
  -----------------45 Right-----------------
  ["models/ron/2ft/curves/curve_45_Right_1.mdl"] = {
    {myType ,"45 Right 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Right 1", gsSymOff, "","-724.122,299.876,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_45_Right_2.mdl"] = {
    {myType ,"45 Right 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Right 2", gsSymOff, "","-811.77,336.23,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_45_Right_3.mdl"] = {
    {myType ,"45 Right 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Right 3", gsSymOff, "","-899.503,372.497,6.016","0,135,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_45_Right_4.mdl"] = {
    {myType ,"45 Right 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"45 Right 4", gsSymOff, "","-987.115,408.885,6.016","0,135,0",gsMissDB}
  },
  -----------------90-----------------
  ["models/ron/2ft/curves/curve_90_1.mdl"] = {
    {myType ,"90 1", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 1", gsSymOff, "","-1024,-1024,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_90_2.mdl"] = {
    {myType ,"90 2", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 2", gsSymOff, "","-1148,-1148,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_90_3.mdl"] = {
    {myType ,"90 3", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 3", gsSymOff, "","-1272,-1272,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/curves/curve_90_4.mdl"] = {
    {myType ,"90 4", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 4", gsSymOff, "","-1396,-1396,6.016","0,-90,0",gsMissDB}
  },
  -----------------S-----------------
  ["models/ron/2ft/curves/s_curve_left.mdl"] = {
    {myType ,"S Left", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"S Left", gsSymOff, "","-704,-62,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/curves/s_curve_right.mdl"] = {
    {myType ,"S Right", gsSymOff, "","0,-62,6.016","0,0,0",gsMissDB},
    {myType ,"S Right", gsSymOff, "","-704,62,6.016","0,180,0",gsMissDB}
  },
  -----------------Y Junction-----------------
  ["models/ron/2ft/yjunction/y_junction_switched_1.mdl"] = {
    {myType ,"Y Switched", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Y Switched", gsSymOff, "","-391.763031, 78.046341,6.016","0,157.5,0",gsMissDB},
    {myType ,"Y Switched", gsSymOff, "","-391.763031, -78.046341,6.016","0,-157.5,0",gsMissDB}
  },
  ["models/ron/2ft/yjunction/y_junction_unswitched_1.mdl"] = {
    {myType ,"Y Unswitched", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Y Unswitched", gsSymOff, "","-391.763031, -78.046341,6.016","0,-157.5,0",gsMissDB},
    {myType ,"Y Unswitched", gsSymOff, "","-391.763031, 78.046341,6.016","0,157.5,0",gsMissDB}
  },
  -----------------Left Junction-----------------
  ["models/ron/2ft/junctions/left_switched_1.mdl"] = {
    {myType ,"Left Switched", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Left Switched", gsSymOff, "","-384,0,6.016","0,180,0",gsMissDB},
    {myType ,"Left Switched", gsSymOff, "","-391.842,-77.994,6.016","0,-157.5,0",gsMissDB},
  },
  ["models/ron/2ft/junctions/left_unswitched_1.mdl"] = {
    {myType ,"Left Unswitched", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Left Unswitched", gsSymOff, "","-384,0,6.016","0,180,0",gsMissDB},
    {myType ,"Left Unswitched", gsSymOff, "","-391.842,-77.994,6.016","0,-157.5,0",gsMissDB}
  },
  -----------------Right Junction-----------------
  ["models/ron/2ft/junctions/Right_switched_1.mdl"] = {
    {myType ,"Right Switched", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Right Switched", gsSymOff, "","-384,0,6.016","0,180,0",gsMissDB},
    {myType ,"Right Switched", gsSymOff, "","-391.842,77.994,6.016","0,157.5,0",gsMissDB},
  },
  ["models/ron/2ft/junctions/Right_unswitched_1.mdl"] = {
    {myType ,"Right Unswitched", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"Right Unswitched", gsSymOff, "","-384,0,6.016","0,180,0",gsMissDB},
    {myType ,"Right Unswitched", gsSymOff, "","-391.842,77.994,6.016","0,157.5,0",gsMissDB}
  },
  -----------------S Junction-----------------
  ["models/ron/2ft/sjunctions/s_junction_left_switched.mdl"] = {
    {myType ,"Left Switched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"Left Switched", gsSymOff, "","0,-62,6.016","0,0,0",gsMissDB},
    {myType ,"Left Switched", gsSymOff, "","-384,62,6.016","0,180,0",gsMissDB},
    {myType ,"Left Switched", gsSymOff, "","-704,-62,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/sjunctions/s_junction_left_unswitched.mdl"] = {
    {myType ,"Left Unswitched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"Left Unswitched", gsSymOff, "","0,-62,6.016","0,0,0",gsMissDB},
    {myType ,"Left Unswitched", gsSymOff, "","-384,62,6.016","0,180,0",gsMissDB},
    {myType ,"Left Unswitched", gsSymOff, "","-704,-62,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/sjunctions/s_junction_right_switched.mdl"] = {
    {myType ,"Right Switched", gsSymOff, "","0,-62,6.016","0,0,0",gsMissDB},
    {myType ,"Right Switched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"Right Switched", gsSymOff, "","-384,-62,6.016","0,180,0",gsMissDB},
    {myType ,"Right Switched", gsSymOff, "","-704,62,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/sjunctions/s_junction_right_unswitched.mdl"] = {
    {myType ,"Right Unswitched", gsSymOff, "","0,-62,6.016","0,0,0",gsMissDB},
    {myType ,"Right Unswitched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"Right Unswitched", gsSymOff, "","-384,-62,6.016","0,180,0",gsMissDB},
    {myType ,"Right Unswitched", gsSymOff, "","-704,62,6.016","0,180,0",gsMissDB}
  },
  -----------------N Junction-----------------
  ["models/ron/2ft/njunctions/n_junction_left_switched.mdl"] = {
    {myType ,"Left Switched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"Left Switched", gsSymOff, "","-384,62,6.016","0,180,0",gsMissDB},
    {myType ,"Left Switched", gsSymOff, "","-704,-62,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/njunctions/n_junction_left_unswitched.mdl"] = {
    {myType ,"Left Unswitched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"Left Unswitched", gsSymOff, "","-384,62,6.016","0,180,0",gsMissDB},
    {myType ,"Left Unswitched", gsSymOff, "","-704,-62,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/njunctions/n_junction_right_switched.mdl"] = {
    {myType ,"Right Switched", gsSymOff, "","0,-62,6.016","0,0,0",gsMissDB},
    {myType ,"Right Switched", gsSymOff, "","-384,-62,6.016","0,180,0",gsMissDB},
    {myType ,"Right Switched", gsSymOff, "","-704,62,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/njunctions/n_junction_right_unswitched.mdl"] = {
    {myType ,"Right Unswitched", gsSymOff, "","0,-62,6.016","0,0,0",gsMissDB},
    {myType ,"Right Unswitched", gsSymOff, "","-384,-62,6.016","0,180,0",gsMissDB},
    {myType ,"Right Unswitched", gsSymOff, "","-704,62,6.016","0,180,0",gsMissDB}
  },
  -----------------X Junction-----------------
  ["models/ron/2ft/xjunctions/x_junction_switched.mdl"] = {
    {myType ,"X Switched", gsSymOff, "","0,-62,6.016","0,0,0",gsMissDB},
    {myType ,"X Switched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"X Switched", gsSymOff, "","-704,-62,6.016","0,180,0",gsMissDB},
    {myType ,"X Switched", gsSymOff, "","-704,62,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/xjunctions/x_junction_unswitched.mdl"] = {
    {myType ,"X Unswitched", gsSymOff, "","0,-62,6.016","0,0,0",gsMissDB},
    {myType ,"X Unswitched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"X Unswitched", gsSymOff, "","-704,-62,6.016","0,180,0",gsMissDB},
    {myType ,"X Unswitched", gsSymOff, "","-704,62,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform-----------------
  ["models/ron/2ft/station/platform_128.mdl"] = {
    {myType ,"128", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_256.mdl"] = {
    {myType ,"256", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"256", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_512.mdl"] = {
    {myType ,"512", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"512", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_1024.mdl"] = {
    {myType ,"1024", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024", gsSymOff, "","-512,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform Roof-----------------
  ["models/ron/2ft/station/platform_128_roof.mdl"] = {
    {myType ,"128 Roof", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Roof", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_256_roof.mdl"] = {
    {myType ,"256 Roof", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"256 Roof", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_512_roof.mdl"] = {
    {myType ,"512 Roof", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"512 Roof", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_1024_roof.mdl"] = {
    {myType ,"1024 Roof", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024 Roof", gsSymOff, "","-512,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform 2 Track-----------------
  ["models/ron/2ft/station/platform_1024_2_track.mdl"] = {
    {myType ,"1024 2 Track", gsSymOff, "","512,124,6.016","0,0,0",gsMissDB},
    {myType ,"1024 2 Track", gsSymOff, "","512,-124,6.016","0,0,0",gsMissDB},
    {myType ,"1024 2 Track", gsSymOff, "","-512,124,6.016","0,180,0",gsMissDB},
    {myType ,"1024 2 Track", gsSymOff, "","-512,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_512_2_track.mdl"] = {
    {myType ,"512 2 Track", gsSymOff, "","256,124,6.016","0,0,0",gsMissDB},
    {myType ,"512 2 Track", gsSymOff, "","256,-124,6.016","0,0,0",gsMissDB},
    {myType ,"512 2 Track", gsSymOff, "","-256,124,6.016","0,180,0",gsMissDB},
    {myType ,"512 2 Track", gsSymOff, "","-256,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_256_2_track.mdl"] = {
    {myType ,"256 2 Track", gsSymOff, "","128,124,6.016","0,0,0",gsMissDB},
    {myType ,"256 2 Track", gsSymOff, "","128,-124,6.016","0,0,0",gsMissDB},
    {myType ,"256 2 Track", gsSymOff, "","-128,124,6.016","0,180,0",gsMissDB},
    {myType ,"256 2 Track", gsSymOff, "","-128,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_128_2_track.mdl"] = {
    {myType ,"128 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"128 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"128 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"128 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform 2 Track Roof-----------------
  ["models/ron/2ft/station/platform_1024_roof_2_track.mdl"] = {
    {myType ,"1024 Roof 2 Track", gsSymOff, "","512,124,6.016","0,0,0",gsMissDB},
    {myType ,"1024 Roof 2 Track", gsSymOff, "","512,-124,6.016","0,0,0",gsMissDB},
    {myType ,"1024 Roof 2 Track", gsSymOff, "","-512,124,6.016","0,180,0",gsMissDB},
    {myType ,"1024 Roof 2 Track", gsSymOff, "","-512,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_512_roof_2_track.mdl"] = {
    {myType ,"512 Roof 2 Track", gsSymOff, "","256,124,6.016","0,0,0",gsMissDB},
    {myType ,"512 Roof 2 Track", gsSymOff, "","256,-124,6.016","0,0,0",gsMissDB},
    {myType ,"512 Roof 2 Track", gsSymOff, "","-256,124,6.016","0,180,0",gsMissDB},
    {myType ,"512 Roof 2 Track", gsSymOff, "","-256,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_256_roof_2_track.mdl"] = {
    {myType ,"256 Roof 2 Track", gsSymOff, "","128,124,6.016","0,0,0",gsMissDB},
    {myType ,"256 Roof 2 Track", gsSymOff, "","128,-124,6.016","0,0,0",gsMissDB},
    {myType ,"256 Roof 2 Track", gsSymOff, "","-128,124,6.016","0,180,0",gsMissDB},
    {myType ,"256 Roof 2 Track", gsSymOff, "","-128,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_128_roof_2_track.mdl"] = {
    {myType ,"128 Roof 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"128 Roof 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"128 Roof 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"128 Roof 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform Start-----------------
  ["models/ron/2ft/station/platform_start.mdl"] = {
    {myType ,"Start", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_start_ramp.mdl"] = {
    {myType ,"Start Ramp", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start Ramp", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_start_stairs.mdl"] = {
    {myType ,"Start Stairs", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start Stairs", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform Start Roof-----------------
  ["models/ron/2ft/station/platform_start_roof.mdl"] = {
    {myType ,"Start Roof", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start Roof", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_start_ramp_roof.mdl"] = {
    {myType ,"Start Ramp Roof", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start Ramp Roof", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_start_stairs_roof.mdl"] = {
    {myType ,"Start Stairs Roof", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"Start Stairs Roof", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform Start 2 Track-----------------
  ["models/ron/2ft/station/platform_start_2_track.mdl"] = {
    {myType ,"Start 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"Start 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"Start 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"Start 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_start_ramp_2_track.mdl"] = {
    {myType ,"Start Ramp 2 Track", gsSymOff, "","128,124,6.016","0,0,0",gsMissDB},
    {myType ,"Start Ramp 2 Track", gsSymOff, "","128,-124,6.016","0,0,0",gsMissDB},
    {myType ,"Start Ramp 2 Track", gsSymOff, "","-128,124,6.016","0,180,0",gsMissDB},
    {myType ,"Start Ramp 2 Track", gsSymOff, "","-128,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_start_stairs_2_track.mdl"] = {
    {myType ,"Start Stairs 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"Start Stairs 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"Start Stairs 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"Start Stairs 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform Start Roof 2 Track-----------------
  ["models/ron/2ft/station/platform_start_roof_2_track.mdl"] = {
    {myType ,"Start Roof 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"Start Roof 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"Start Roof 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"Start Roof 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_start_ramp_roof_2_track.mdl"] = {
    {myType ,"Start Ramp Roof 2 Track", gsSymOff, "","128,124,6.016","0,0,0",gsMissDB},
    {myType ,"Start Ramp Roof 2 Track", gsSymOff, "","128,-124,6.016","0,0,0",gsMissDB},
    {myType ,"Start Ramp Roof 2 Track", gsSymOff, "","-128,124,6.016","0,180,0",gsMissDB},
    {myType ,"Start Ramp Roof 2 Track", gsSymOff, "","-128,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_start_stairs_roof_2_track.mdl"] = {
    {myType ,"Start Roof Stairs 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"Start Roof Stairs 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"Start Roof Stairs 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"Start Roof Stairs 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform End-----------------
  ["models/ron/2ft/station/platform_end.mdl"] = {
    {myType ,"End", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"End", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_end_ramp.mdl"] = {
    {myType ,"End Ramp", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"End Ramp", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_end_stairs.mdl"] = {
    {myType ,"End Stairs", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"End Stairs", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform End Roof-----------------
  ["models/ron/2ft/station/platform_end_roof.mdl"] = {
    {myType ,"End Roof", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"End Roof", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_end_ramp_roof.mdl"] = {
    {myType ,"End Ramp Roof", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"End Ramp Roof", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_end_stairs_roof.mdl"] = {
    {myType ,"End Stairs Roof", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"End Stairs Roof", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform Bench-----------------
  ["models/ron/2ft/station/platform_128_bench.mdl"] = {
    {myType ,"128 Bench", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Bench", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_128_bench_roof.mdl"] = {
    {myType ,"128 Bench Roof", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Bench Roof", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform Bench 2 Track-----------------
  ["models/ron/2ft/station/platform_128_bench_2_track.mdl"] = {
    {myType ,"128 Bench 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"128 Bench 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"128 Bench 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"128 Bench 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_128_bench_roof_2_track.mdl"] = {
    {myType ,"128 Bench Roof 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"128 Bench Roof 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"128 Bench Roof 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"128 Bench Roof 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform End 2 Track-----------------
  ["models/ron/2ft/station/platform_end_2_track.mdl"] = {
    {myType ,"End 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"End 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"End 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"End 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_end_ramp_2_track.mdl"] = {
    {myType ,"End Ramp 2 Track", gsSymOff, "","128,124,6.016","0,0,0",gsMissDB},
    {myType ,"End Ramp 2 Track", gsSymOff, "","128,-124,6.016","0,0,0",gsMissDB},
    {myType ,"End Ramp 2 Track", gsSymOff, "","-128,124,6.016","0,180,0",gsMissDB},
    {myType ,"End Ramp 2 Track", gsSymOff, "","-128,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_end_stairs_2_track.mdl"] = {
    {myType ,"End Stairs 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"End Stairs 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"End Stairs 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"End Stairs 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform End 2 Track Roof-----------------
  ["models/ron/2ft/station/platform_end_roof_2_track.mdl"] = {
    {myType ,"End Roof 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"End Roof 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"End Roof 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"End Roof 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_end_ramp_roof_2_track.mdl"] = {
    {myType ,"End Ramp Roof 2 Track", gsSymOff, "","128,124,6.016","0,0,0",gsMissDB},
    {myType ,"End Ramp Roof 2 Track", gsSymOff, "","128,-124,6.016","0,0,0",gsMissDB},
    {myType ,"End Ramp Roof 2 Track", gsSymOff, "","-128,124,6.016","0,180,0",gsMissDB},
    {myType ,"End Ramp Roof 2 Track", gsSymOff, "","-128,-124,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_end_stairs_roof_2_track.mdl"] = {
    {myType ,"End Roof Stairs 2 Track", gsSymOff, "","64,124,6.016","0,0,0",gsMissDB},
    {myType ,"End Roof Stairs 2 Track", gsSymOff, "","64,-124,6.016","0,0,0",gsMissDB},
    {myType ,"End Roof Stairs 2 Track", gsSymOff, "","-64,124,6.016","0,180,0",gsMissDB},
    {myType ,"End Roof Stairs 2 Track", gsSymOff, "","-64,-124,6.016","0,180,0",gsMissDB}
  },
  -----------------Platform Exit-----------------
  ["models/ron/2ft/station/platform_128_exit_roof.mdl"] = {
    {myType ,"128 Roof Exit", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Roof Exit", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/station/platform_128_exit.mdl"] = {
    {myType ,"128 Exit", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Exit", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Road Crossing-----------------
  ["models/ron/2ft/road_crossings/road_crossing_middle.mdl"] = {
    {myType ,"Road Crossing Middle", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"Road Crossing Middle", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/road_crossings/road_crossing_side.mdl"] = {
    {myType ,"Road Crossing Side", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"Road Crossing Side", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/road_crossings/road_crossing.mdl"] = {
    {myType ,"Road Crossing", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"Road Crossing", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Lua Junctions-----------------
  ["models/ron/2ft/luajunctions/junctions/left/junction.mdl"] = {
    {myType ,"Left", gsSymOff, "","0,0,6.016","0,-90,0","r2ftp_junction_left"},
    {myType ,"Left", gsSymOff, "","-0,384,6.016","0,90,0","r2ftp_junction_left"},
    {myType ,"Left", gsSymOff, "","-77.994,391.842,6.016","0,112.5,0","r2ftp_junction_left"},
  },
  ["models/ron/2ft/luajunctions/junctions/right/junction.mdl"] = {
    {myType ,"Right", gsSymOff, "","0,0,6.016","0,-90,0","r2ftp_junction_right"},
    {myType ,"Right", gsSymOff, "","0,384,6.016","0,90,0","r2ftp_junction_right"},
    {myType ,"Right", gsSymOff, "","77.994,391.842,6.016","0,67.5,0","r2ftp_junction_right"}
  },
  ["models/ron/2ft/luajunctions/y_junctions/y_junction.mdl"] = {
    {myType ,"Y", gsSymOff, "","0,0,6.016", "0,-90,0", "r2ftp_junction_y"},
    {myType ,"Y", gsSymOff, ""," 77.969124,391.794891,6.016","0, 67.5,0","r2ftp_junction_y"},
    {myType ,"Y", gsSymOff, "","-77.969093,391.794952,6.016","0,112.5,0","r2ftp_junction_y"}
  },
  ["models/ron/2ft/luajunctions/x_junctions/x_junction.mdl"] = {
    {myType ,"X", gsSymOff, "","62,0,6.016", "0,-90,0", "r2ftp_junction_x"},
    {myType ,"X", gsSymOff, "","62,704,6.016","0,90,0","r2ftp_junction_x"},
    {myType ,"X", gsSymOff, "","-62,704,6.016","0,90,0","r2ftp_junction_x"},
    {myType ,"X", gsSymOff, "","-62,0,6.016","0,-90,0","r2ftp_junction_x"}
  },
  ["models/ron/2ft/luajunctions/s_junctions/left/s_junction.mdl"] = {
    {myType ,"S Left", gsSymOff, "","0,0,6.016","0,-90,0","r2ftp_junction_s_left"},
    {myType ,"S Left", gsSymOff, "","0,384,6.016","0,90,0","r2ftp_junction_s_left"},
    {myType ,"S Left", gsSymOff, "","-124,704,6.016","0,90,0","r2ftp_junction_s_left"},
    {myType ,"S Left", gsSymOff, "","-124,320,6.016","0,-90,0","r2ftp_junction_s_left"}
  },
  ["models/ron/2ft/luajunctions/s_junctions/right/s_junction.mdl"] = {
    {myType ,"S Right", gsSymOff, "","0,0,6.016","0,-90,0","r2ftp_junction_s_right"},
    {myType ,"S Right", gsSymOff, "","0,384,6.016","0, 90,0","r2ftp_junction_s_right"},
    {myType ,"S Right", gsSymOff, "","124,704,6.016","0, 90,0","r2ftp_junction_s_right"},
    {myType ,"S Right", gsSymOff, "","124,320,6.016","0,-90,0","r2ftp_junction_s_right"}
  },
  ["models/ron/2ft/luajunctions/n_junctions/right/n_junction.mdl"] = {
    {myType ,"N Right", gsSymOff, "","0,0,6.016","0,-90,0","r2ftp_junction_n_right"},
    {myType ,"N Right", gsSymOff, "","0,384,6.016","0,90,0","r2ftp_junction_n_right"},
    {myType ,"N Right", gsSymOff, "","124,704,6.016","0,90,0","r2ftp_junction_n_right"}
  },
  ["models/ron/2ft/luajunctions/n_junctions/left/n_junction.mdl"] = {
    {myType ,"N Left", gsSymOff, "","0,0,6.016","0,-90,0","r2ftp_junction_n_left"},
    {myType ,"N Left", gsSymOff, "","0,384,6.016","0,90,0","r2ftp_junction_n_left"},
    {myType ,"N Left", gsSymOff, "","-124,704,6.016","0,90,0","r2ftp_junction_n_left"}
  },
  -----------------Viaduct-----------------
  ["models/ron/2ft/viaduct/viaduct_1024.mdl"] = {
    {myType ,"1024", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024", gsSymOff, "","-512,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/viaduct/viaduct_512.mdl"] = {
    {myType ,"512", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"512", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Tram Grass-----------------
  ["models/ron/2ft/tram/tram_32_grass.mdl"] = {
    {myType ,"32 Grass", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB},
    {myType ,"32 Grass", gsSymOff, "","-16,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_64_grass.mdl"] = {
    {myType ,"64 Grass", gsSymOff, "","32,0,6.016","0,0,0",gsMissDB},
    {myType ,"64 Grass", gsSymOff, "","-32,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_128_grass.mdl"] = {
    {myType ,"128 Grass", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Grass", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_256_grass.mdl"] = {
    {myType ,"256 Grass", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"256 Grass", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_512_grass.mdl"] = {
    {myType ,"512 Grass", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"512 Grass", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_1024_grass.mdl"] = {
    {myType ,"1024 Grass", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024 Grass", gsSymOff, "","-512,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Tram Street-----------------
  ["models/ron/2ft/tram/tram_32_Street.mdl"] = {
    {myType ,"32 Street", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB},
    {myType ,"32 Street", gsSymOff, "","-16,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_64_Street.mdl"] = {
    {myType ,"64 Street", gsSymOff, "","32,0,6.016","0,0,0",gsMissDB},
    {myType ,"64 Street", gsSymOff, "","-32,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_128_Street.mdl"] = {
    {myType ,"128 Street", gsSymOff, "","64,0,6.016","0,0,0",gsMissDB},
    {myType ,"128 Street", gsSymOff, "","-64,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_256_Street.mdl"] = {
    {myType ,"256 Street", gsSymOff, "","128,0,6.016","0,0,0",gsMissDB},
    {myType ,"256 Street", gsSymOff, "","-128,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_512_Street.mdl"] = {
    {myType ,"512 Street", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"512 Street", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_1024_Street.mdl"] = {
    {myType ,"1024 Street", gsSymOff, "","512,0,6.016","0,0,0",gsMissDB},
    {myType ,"1024 Street", gsSymOff, "","-512,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Tram Transition-----------------
  ["models/ron/2ft/tram/tram_grass_normal.mdl"] = {
    {myType ,"Transition Grass Normal", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB},
    {myType ,"Transition Grass Normal", gsSymOff, "","-16,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_grass_street.mdl"] = {
    {myType ,"Transition Grass Street", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB},
    {myType ,"Transition Grass Street", gsSymOff, "","-16,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_normal_street.mdl"] = {
    {myType ,"Transition Normal Street", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB},
    {myType ,"Transition Normal Street", gsSymOff, "","-16,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Tram Curve Grass-----------------
  ["models/ron/2ft/tram/tram_curve_90_1_grass.mdl"] = {
    {myType ,"90 1 Grass", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 1 Grass", gsSymOff, "","-1024,-1024,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_curve_90_2_grass.mdl"] = {
    {myType ,"90 2 Grass", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 2 Grass", gsSymOff, "","-1148,-1148,6.016","0,-90,0",gsMissDB}
  },
  -----------------Tram Curve Street-----------------
  ["models/ron/2ft/tram/tram_curve_90_1_Street.mdl"] = {
    {myType ,"90 1 Street", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 1 Street", gsSymOff, "","-1024,-1024,6.016","0,-90,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_curve_90_2_Street.mdl"] = {
    {myType ,"90 2 Street", gsSymOff, "","0,0,6.016","0,0,0",gsMissDB},
    {myType ,"90 2 Street", gsSymOff, "","-1148,-1148,6.016","0,-90,0",gsMissDB}
  },
  -----------------Tram Buffer-----------------
  ["models/ron/2ft/tram/tram_buffer_grass.mdl"] = {
    {myType ,"Buffer Grass", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_buffer_street.mdl"] = {
    {myType ,"Buffer Street", gsSymOff, "","16,0,6.016","0,0,0",gsMissDB}
  },
  -----------------Tram Station-----------------
  ["models/ron/2ft/tram/tram_station_grass.mdl"] = {
    {myType ,"Station Grass", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"Station Grass", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_station_grass_m.mdl"] = {
    {myType ,"Station M Grass", gsSymOff, "","256,0,6.016","0,0,0",gsMissDB},
    {myType ,"Station M Grass", gsSymOff, "","-256,0,6.016","0,180,0",gsMissDB}
  },
  -----------------Tram S Junction-----------------
  ["models/ron/2ft/tram/tram_s_junction_left_switched.mdl"] = {
    {myType ,"S Left Switched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"S Left Switched", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"S Left Switched", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB},
    {myType ,"S Left Switched", gsSymOff, "","  0 ,-62,6.016","0,0,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_s_junction_left_unswitched.mdl"] = {
    {myType ,"S Left Unswitched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"S Left Unswitched", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"S Left Unswitched", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB},
    {myType ,"S Left Unswitched", gsSymOff, "","  0 ,-62,6.016","0,0,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_s_junction_right_switched.mdl"] = {
    {myType ,"S Right Switched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"S Right Switched", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"S Right Switched", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB},
    {myType ,"S Right Switched", gsSymOff, "","  0 ,-62,6.016","0,0,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_s_junction_right_unswitched.mdl"] = {
    {myType ,"S Right Unswitched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"S Right Unswitched", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"S Right Unswitched", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB},
    {myType ,"S Right Unswitched", gsSymOff, "","  0 ,-62,6.016","0,0,0",gsMissDB}
  },
  -----------------Tram N Junction-----------------
  ["models/ron/2ft/tram/tram_n_junction_left_switched.mdl"] = {
    {myType ,"N Left Switched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"N Left Switched", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"N Left Switched", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_n_junction_left_unswitched.mdl"] = {
    {myType ,"N Left Unswitched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"N Left Unswitched", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"N Left Unswitched", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_n_junction_right_switched.mdl"] = {
    {myType ,"N Right Switched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"N Right Switched", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"N Right Switched", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_n_junction_right_unswitched.mdl"] = {
    {myType ,"N Right Unswitched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"N Right Unswitched", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"N Right Unswitched", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB}
  },
  -----------------Tram X Junction-----------------
  ["models/ron/2ft/tram/tram_x_junction_switched.mdl"] = {
    {myType ,"X Switched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"X Switched", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"X Switched", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB},
    {myType ,"X Switched", gsSymOff, "","  0 ,-62,6.016","0,0,0",gsMissDB}
  },
  ["models/ron/2ft/tram/tram_x_junction_unswitched.mdl"] = {
    {myType ,"X Unswitched", gsSymOff, "","0,62,6.016","0,0,0",gsMissDB},
    {myType ,"X Unswitched", gsSymOff, "","-704, 62,6.016", "0,-180,0",gsMissDB},
    {myType ,"X Unswitched", gsSymOff, "","-704,-62,6.016", "0,-180,0",gsMissDB},
    {myType ,"X Unswitched", gsSymOff, "","  0 ,-62,6.016","0,0,0",gsMissDB}
  },
  -----------------Turntable Small-----------------
  ["models/ron/2ft/turntable/turntable_small_base_90.mdl"] = {
    {myType ,"Small Base", gsSymOff, "","192,0,6.016", "0,0,0",gsMissDB},
    {myType ,"Small Base", gsSymOff, "","0,192,6.016", "0,90,0",gsMissDB},
    {myType ,"Small Base", gsSymOff, "","-192,0,6.016","0,-180,0",gsMissDB},
    {myType ,"Small Base", gsSymOff, "","0,-192,6.016","0,-90,0",gsMissDB},
    {myType ,"Small Base", gsSymOff, "","64,0,10.516","0,-180,0",gsMissDB},
    {myType ,"Small Base", gsSymOff, "","0,64,10.516","0,-90,0",gsMissDB},
    {myType ,"Small Base", gsSymOff, "","-64,0,10.516","0,0,0",gsMissDB},
    {myType ,"Small Base", gsSymOff, "","0,-64,10.516","0,90,0",gsMissDB}
  },
  ["models/ron/2ft/turntable/turntable_small.mdl"] = {
    {myType ,"Small", gsSymOff, "","64,0,10.516","0,0,0",gsMissDB},
    {myType ,"Small", gsSymOff, "","-64,0,10.516","0,180,0",gsMissDB}
  },
  -----------------Turntable Narrow-----------------
  ["models/ron/2ft/turntable/turntable_narrow_base_90.mdl"] = {
    {myType ,"Narrow Base", gsSymOff, "","96,0,6.016", "0,0,0",gsMissDB},
    {myType ,"Narrow Base", gsSymOff, "","0,96,6.016", "0,90,0",gsMissDB},
    {myType ,"Narrow Base", gsSymOff, "","-96,0,6.016","0,-180,0",gsMissDB},
    {myType ,"Narrow Base", gsSymOff, "","0,-96,6.016","0,-90,0",gsMissDB},
    {myType ,"Narrow Base", gsSymOff, "","32,0,6.016","0,180,0",gsMissDB},
    {myType ,"Narrow Base", gsSymOff, "","0,32,6.016","0,-90,0",gsMissDB},
    {myType ,"Narrow Base", gsSymOff, "","-32,0,6.016","0,0,0",gsMissDB},
    {myType ,"Narrow Base", gsSymOff, "","0,-32,6.016","0,90,0",gsMissDB}
  },
  ["models/ron/2ft/turntable/turntable_narrow.mdl"] = {
    {myType ,"Narrow", gsSymOff, "","0,32,6.016","0,90,0",gsMissDB},
    {myType ,"Narrow", gsSymOff, "","0,-32,6.016","0,-90,0",gsMissDB}
  },
}
mySyncTable("PIECES", myPieces, true)
asmlib.LogInstance("<<< "..myScript)
