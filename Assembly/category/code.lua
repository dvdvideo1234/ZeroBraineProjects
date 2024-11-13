local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(1)
                
local com = require("common")

rawset(_G, "CLIENT", true)

require("gmodlib")
require("trackasmlib")

asmlib = trackasmlib
if(not asmlib) then error("No library") end

asmlib.IsModel = function(m) return isstring(m) end

if(not asmlib.InitBase("track","assembly")) then error("Init fail") end

asmlib.NewAsmConvar("timermode", "CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1", nil, gnIndependentUsed, "Memory management setting when DB mode is SQL")
CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetLogControl(20000, false)

local sT = "Plarail"

local tD = {


"models/ron/plarail/scenery/aj01.mdl",
"models/ron/plarail/scenery/aj01_2.mdl",
"models/ron/plarail/scenery/aj02.mdl",
"models/ron/plarail/scenery/aj03.mdl",
"models/ron/plarail/scenery/aj03_bridge.mdl",
"models/ron/plarail/scenery/aj03_top.mdl",
"models/ron/plarail/scenery/aj04.mdl",
"models/ron/plarail/scenery/j14_grey.mdl",
"models/ron/plarail/scenery/j14_yellow.mdl",
"models/ron/plarail/scenery/j15_grey.mdl",
"models/ron/plarail/scenery/j15_yellow.mdl",
"models/ron/plarail/scenery/j22_grey.mdl",
"models/ron/plarail/scenery/j22_yellow.mdl",
"models/ron/plarail/scenery/pa_pole.mdl",
"models/ron/plarail/tracks/curve/r03_left.mdl",
"models/ron/plarail/tracks/curve/r03_right.mdl",
"models/ron/plarail/tracks/curve/r05_left.mdl",
"models/ron/plarail/tracks/curve/r05_right.mdl",
"models/ron/plarail/tracks/curve/r09_left.mdl",
"models/ron/plarail/tracks/curve/r09_right.mdl",
"models/ron/plarail/tracks/curve/r18_a.mdl",
"models/ron/plarail/tracks/curve/r18_b.mdl",
"models/ron/plarail/tracks/curve/r27_left.mdl",
"models/ron/plarail/tracks/curve/r27_right.mdl",
"models/ron/plarail/tracks/misc/ar01.mdl",
"models/ron/plarail/tracks/misc/ar02.mdl",
"models/ron/plarail/tracks/misc/ar03.mdl",
"models/ron/plarail/tracks/misc/ar04_1.mdl",
"models/ron/plarail/tracks/misc/ar04_2.mdl",
"models/ron/plarail/tracks/misc/ar04_3.mdl",
"models/ron/plarail/tracks/misc/ar05_1.mdl",
"models/ron/plarail/tracks/misc/ar05_2.mdl",
"models/ron/plarail/tracks/misc/ar06.mdl",
"models/ron/plarail/tracks/misc/ar06_1.mdl",
"models/ron/plarail/tracks/misc/ar06_2.mdl",
"models/ron/plarail/tracks/misc/connector_female.mdl",
"models/ron/plarail/tracks/misc/connector_male.mdl",
"models/ron/plarail/tracks/misc/connector_male2.mdl",
"models/ron/plarail/tracks/misc/custom_1.mdl",
"models/ron/plarail/tracks/misc/custom_16.mdl",
"models/ron/plarail/tracks/misc/custom_2.mdl",
"models/ron/plarail/tracks/misc/custom_4.mdl",
"models/ron/plarail/tracks/misc/custom_8.mdl",
"models/ron/plarail/tracks/misc/r06.mdl",
"models/ron/plarail/tracks/straight/r01.mdl",
"models/ron/plarail/tracks/straight/r02.mdl",
"models/ron/plarail/tracks/straight/r04.mdl",
"models/ron/plarail/tracks/straight/r07.mdl",
"models/ron/plarail/tracks/straight/r20_01.mdl",
"models/ron/plarail/tracks/straight/r20_02.mdl",
"models/ron/plarail/tracks/straight/r20_03.mdl",
"models/ron/plarail/tracks/straight/r26.mdl",

}
-- function self:TimerSetup(vTim)
asmlib.Categorize(sT, [[function(m)
    local g = m:gsub("models/ron/plarail","")
    local g, o = g:gsub("[0-9_]+.+",""), {}
    for w in g:gmatch("/[^/]+") do table.insert(o, w:sub(2, -1)) end
    local n = #o; local r = o[n]
      if(r == "ar") then o[n] = "special"
      elseif(r == "aj") then o[n] = "scenery"
      elseif(r == "r") then o[n] = "plain"
      elseif(r == "j") then o[n] = "support"
      elseif(r == "pa") then o[n] = "support"
      end; return o
    end]])

local dat = asmlib.GetOpVar("TABLE_CATEGORIES")[sT]

com.logTable(dat, "CAT")

local out = assert(io.open("Assembly/trackassembly/trackasmlib_nodes.txt", "wb"))

for i = 1, #tD do
  local mod = tD[i]
  local suc, cat, nam = pcall(dat.Cmp, mod)
  if(not suc) then error(cat) end
  if(istable(cat)) then cat = "("..table.concat(cat,"|")..")" end
  out:write(com.stringPadR(mod, 100, " ").." > "..com.stringPadR(cat, 35, " ").." > "..tostring(nam).."\n")
end

out:flush()
out:close()
