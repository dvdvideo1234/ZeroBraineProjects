local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
                
local com = require("common")

rawset(_G, "CLIENT", true)

require("gmodlib")
require("trackasmlib")

asmlib = trackasmlib
local com = require("common")
if(not asmlib) then error("No library") end
asmlib.IsModel = function(m) return isstring(m) end
if(not asmlib.InitBase("track","assembly")) then error("Init fail") end
asmlib.NewAsmConvar("timermode", "CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1", nil, gnIndependentUsed, "Memory management setting when DB mode is SQL")
CreateConVar("gmod_language")
require("Assembly/autorun/config")

local tD = {
"models/propper/dingles_modular_streets/highway_ramp_street1024x768.mdl",
"models/propper/dingles_modular_streets/highway_ramp_street2048x768_tall.mdl",
"models/propper/dingles_modular_streets/highway_ramp_street768_short_tall_connector.mdl",
"models/propper/dingles_modular_streets/highway_street1024x768.mdl",
"models/propper/dingles_modular_streets/highway_street1024x768_tall.mdl",
"models/propper/dingles_modular_streets/highway_street2048x768.mdl",
"models/propper/dingles_modular_streets/highway_street2048x768_overpass.mdl",
"models/propper/dingles_modular_streets/highway_street2048x768_tall.mdl",
"models/propper/dingles_modular_streets/highway_street768x768.mdl",
"models/propper/dingles_modular_streets/highway_street768x768_tall.mdl",
"models/propper/dingles_modular_streets/highway_street_768rampconnector.mdl",
"models/propper/dingles_modular_streets/highway_street_768rampconnector_double.mdl",
"models/propper/dingles_modular_streets/highway_street_768rampconnector_double_tall.mdl",
"models/propper/dingles_modular_streets/highway_street_768rampconnector_mirrored.mdl",
"models/propper/dingles_modular_streets/highway_street_768rampconnector_mirrored_tall.mdl",
"models/propper/dingles_modular_streets/highway_street_768rampconnector_tall.mdl",
"models/propper/dingles_modular_streets/highway_street_768turn.mdl",
"models/propper/dingles_modular_streets/highway_street_768turn_tall.mdl",
"models/propper/dingles_modular_streets/street1024x512.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated128high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated192high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated256high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated64high.mdl",
"models/propper/dingles_modular_streets/street1024x768.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated128high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated192high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated256high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated64high.mdl",
"models/propper/dingles_modular_streets/street128x512.mdl",
"models/propper/dingles_modular_streets/street128x512_crosswalk.mdl",
"models/propper/dingles_modular_streets/street128x768.mdl",
"models/propper/dingles_modular_streets/street128x768_crosswalk.mdl",
"models/propper/dingles_modular_streets/street2048x512.mdl",
"models/propper/dingles_modular_streets/street2048x768.mdl",
"models/propper/dingles_modular_streets/street256x512.mdl",
"models/propper/dingles_modular_streets/street256x768.mdl",
"models/propper/dingles_modular_streets/street512_endcap_fancy1.mdl",
"models/propper/dingles_modular_streets/street512_endcap_fancy2.mdl",
"models/propper/dingles_modular_streets/street512_endcap_simple1.mdl",
"models/propper/dingles_modular_streets/street512_endcap_simple2.mdl",
"models/propper/dingles_modular_streets/street512x512.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated128high.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated192high.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated256high.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated64high.mdl",
"models/propper/dingles_modular_streets/street512x768.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated128high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated192high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated256high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated64high.mdl",
"models/propper/dingles_modular_streets/street64x512.mdl",
"models/propper/dingles_modular_streets/street64x768.mdl",
"models/propper/dingles_modular_streets/street768_endcap_fancy1.mdl",
"models/propper/dingles_modular_streets/street768_endcap_fancy2.mdl",
"models/propper/dingles_modular_streets/street768_endcap_simple1.mdl",
"models/propper/dingles_modular_streets/street768_endcap_simple2.mdl",
"models/propper/dingles_modular_streets/street768_fork.mdl",
"models/propper/dingles_modular_streets/street768x512.mdl",
"models/propper/dingles_modular_streets/street768x768.mdl",
"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector1.mdl",
"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector2.mdl",
"models/propper/dingles_modular_streets/street_4wayintersection512x512.mdl",
"models/propper/dingles_modular_streets/street_4wayintersection768x768.mdl",
"models/propper/dingles_modular_streets/street_512_to_768_connector1.mdl",
"models/propper/dingles_modular_streets/street_512_to_768_connector2.mdl",
"models/propper/dingles_modular_streets/street_tjunction512x512.mdl",
"models/propper/dingles_modular_streets/street_tjunction768x768.mdl",
"models/propper/dingles_modular_streets/street_turn512x512.mdl",
"models/propper/dingles_modular_streets/street_turn768x768.mdl"
}
-- function self:TimerSetup(vTim)
asmlib.Categorize("Modular city street",{ "@highway",
                                          "@street" ,
                                          "endcap"       ,
                                          "turn"         ,
                                          "ramp"         ,
                                          "connector"    ,
                                          "tjunction"    ,
                                          "intersection" ,
                                          "elevated"     }, "models/propper/dingles_modular_streets/")

--[===[
asmlib.Categorize("Modular city street",[[
  function(m)
    local o = {}
    function setBranch(v, p, b)
      if(v:find(p)) then
        local e = v:gsub("%W*"..p.."%W*", "_")
        if(b and o.Base) then return e end
        if(b and not o.Base) then o.Base = p end
        table.insert(o, p)
        return e
      end
      return v
    end
    local r = m:gsub("models/propper/dingles_modular_streets/",""):gsub("%.mdl$","")
    r = setBranch(r, "highway", true)
    r = setBranch(r, "street" , true)
    r = setBranch(r, "endcap")
    r = setBranch(r, "turn")
    r = setBranch(r, "ramp")
    r = setBranch(r, "connector")
    r = setBranch(r, "tjunction")
    r = setBranch(r, "intersection")
    r = setBranch(r, "elevated")
    o.Base = nil; return o, r:gsub("^_+", ""):gsub("_+$", "")
  end
]])

asmlib.Categorize("Modular city street",[[
  function(m)
    local o = {}
    function setBranch(v, p, b)
      if(v:find(p)) then
        local e = v:gsub("%W*"..p.."%W*", "_")
        if(b and o.Base) then return e end
        if(b and not o.Base) then o.Base = p end
        table.insert(o, p)
        return e
      end
      return v
    end
    local r = m:gsub("models/propper/dingles_modular_streets/",""):gsub("%.mdl$","")
    r = setBranch(r, "highway", true)
    r = setBranch(r, "street" , true)
    r = setBranch(r, "endcap")
    r = setBranch(r, "turn")
    r = setBranch(r, "ramp")
    r = setBranch(r, "connector")
    r = setBranch(r, "tjunction")
    r = setBranch(r, "intersection")
    r = setBranch(r, "elevated")
    o.Base = nil; return o, r:gsub("^_+", ""):gsub("_+$", "")
  end
]])


asmlib.Categorize("Modular city street", 3, "models/propper/dingles_modular_", "_", "/")
]===]

local dat = asmlib.GetOpVar("TABLE_CATEGORIES")["Modular city street"]

com.logTable(dat, "CAT")

local new = dat.Cmp

local out = assert(io.open("Assembly/trackassembly/trackasmlib_nodes.txt", "wb"))

for i = 1, #tD do
  local mod = tD[i]
  local cat, nam = new(mod)
  if(istable(cat)) then cat = "("..table.concat(cat,"|")..")" end
  out:write(com.stringPadR(mod, 100, " ").." > "..com.stringPadR(cat, 35, " ").." > "..nam.."\n")
end

out:flush()
out:close()
