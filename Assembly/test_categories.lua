local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
                
require("gmodlib")
local com = require("common")
local cpx = require("complex")
local asmlib = require("trackasmlib")

local tD = {
"models/propper/dingles_modular_streets/street64x512.mdl",
"models/propper/dingles_modular_streets/street64x768.mdl",
"models/propper/dingles_modular_streets/street128x512.mdl",
"models/propper/dingles_modular_streets/street128x768.mdl",
"models/propper/dingles_modular_streets/street128x512_crosswalk.mdl",
"models/propper/dingles_modular_streets/street128x768_crosswalk.mdl",
"models/propper/dingles_modular_streets/street256x512.mdl",
"models/propper/dingles_modular_streets/street256x768.mdl",
"models/propper/dingles_modular_streets/street512x512.mdl",
"models/propper/dingles_modular_streets/street512x768.mdl",
"models/propper/dingles_modular_streets/street768x512.mdl",
"models/propper/dingles_modular_streets/street768x768.mdl",
"models/propper/dingles_modular_streets/street1024x512.mdl",
"models/propper/dingles_modular_streets/street1024x768.mdl",
"models/propper/dingles_modular_streets/street2048x512.mdl",
"models/propper/dingles_modular_streets/street2048x768.mdl",
"models/propper/dingles_modular_streets/street512_endcap_fancy1.mdl",
"models/propper/dingles_modular_streets/street512_endcap_fancy2.mdl",
"models/propper/dingles_modular_streets/street512_endcap_simple1.mdl",
"models/propper/dingles_modular_streets/street512_endcap_simple2.mdl",
"models/propper/dingles_modular_streets/street768_endcap_fancy1.mdl",
"models/propper/dingles_modular_streets/street768_endcap_fancy2.mdl",
"models/propper/dingles_modular_streets/street768_endcap_simple1.mdl",
"models/propper/dingles_modular_streets/street768_endcap_simple2.mdl",
"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector1.mdl",
"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector2.mdl",
"models/propper/dingles_modular_streets/street_512_to_768_connector1.mdl",
"models/propper/dingles_modular_streets/street_512_to_768_connector2.mdl",
"models/propper/dingles_modular_streets/street_tjunction512x512.mdl",
"models/propper/dingles_modular_streets/street_tjunction768x768.mdl",
"models/propper/dingles_modular_streets/street_turn512x512.mdl",
"models/propper/dingles_modular_streets/street_turn768x768.mdl",
"models/propper/dingles_modular_streets/street_4wayintersection512x512.mdl",
"models/propper/dingles_modular_streets/street_4wayintersection768x768.mdl",
"models/propper/dingles_modular_streets/street768_fork.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated64high.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated128high.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated192high.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated256high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated64high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated128high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated192high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated256high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated64high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated128high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated192high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated256high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated64high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated128high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated192high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated256high.mdl",
"models/propper/dingles_modular_streets/street64x512.mdl",
"models/propper/dingles_modular_streets/street64x768.mdl",
"models/propper/dingles_modular_streets/street128x512.mdl",
"models/propper/dingles_modular_streets/street128x768.mdl",
"models/propper/dingles_modular_streets/street128x512_crosswalk.mdl",
"models/propper/dingles_modular_streets/street128x768_crosswalk.mdl",
"models/propper/dingles_modular_streets/street256x512.mdl",
"models/propper/dingles_modular_streets/street256x768.mdl",
"models/propper/dingles_modular_streets/street512x512.mdl",
"models/propper/dingles_modular_streets/street512x768.mdl",
"models/propper/dingles_modular_streets/street768x512.mdl",
"models/propper/dingles_modular_streets/street768x768.mdl",
"models/propper/dingles_modular_streets/street1024x512.mdl",
"models/propper/dingles_modular_streets/street1024x768.mdl",
"models/propper/dingles_modular_streets/street2048x512.mdl",
"models/propper/dingles_modular_streets/street2048x768.mdl",
"models/propper/dingles_modular_streets/street512_endcap_fancy1.mdl",
"models/propper/dingles_modular_streets/street512_endcap_fancy2.mdl",
"models/propper/dingles_modular_streets/street512_endcap_simple1.mdl",
"models/propper/dingles_modular_streets/street512_endcap_simple2.mdl",
"models/propper/dingles_modular_streets/street768_endcap_fancy1.mdl",
"models/propper/dingles_modular_streets/street768_endcap_fancy2.mdl",
"models/propper/dingles_modular_streets/street768_endcap_simple1.mdl",
"models/propper/dingles_modular_streets/street768_endcap_simple2.mdl",
"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector1.mdl",
"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector2.mdl",
"models/propper/dingles_modular_streets/street_512_to_768_connector1.mdl",
"models/propper/dingles_modular_streets/street_512_to_768_connector2.mdl",
"models/propper/dingles_modular_streets/street_tjunction512x512.mdl",
"models/propper/dingles_modular_streets/street_tjunction768x768.mdl",
"models/propper/dingles_modular_streets/street_turn512x512.mdl",
"models/propper/dingles_modular_streets/street_turn768x768.mdl",
"models/propper/dingles_modular_streets/street_4wayintersection512x512.mdl",
"models/propper/dingles_modular_streets/street_4wayintersection768x768.mdl",
"models/propper/dingles_modular_streets/street768_fork.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated64high.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated128high.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated192high.mdl",
"models/propper/dingles_modular_streets/street512x512_elevated256high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated64high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated128high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated192high.mdl",
"models/propper/dingles_modular_streets/street512x768_elevated256high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated64high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated128high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated192high.mdl",
"models/propper/dingles_modular_streets/street1024x512_elevated256high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated64high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated128high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated192high.mdl",
"models/propper/dingles_modular_streets/street1024x768_elevated256high.mdl",
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
"models/propper/dingles_modular_streets/highway_street_768turn_tall.mdl"
}

local fnc = [[
  function(m)
    local o = {}
    local r = m:gsub("models/propper/dingles_modular_streets/",""):gsub("%.mdl$","")
    r = trackasmlib.RegisterBranch(o, r, "highway", true)
    r = trackasmlib.RegisterBranch(o, r, "street" , true)
    r = trackasmlib.RegisterBranch(o, r, "endcap")
    r = trackasmlib.RegisterBranch(o, r, "turn")
    r = trackasmlib.RegisterBranch(o, r, "ramp")
    r = trackasmlib.RegisterBranch(o, r, "connector")
    r = trackasmlib.RegisterBranch(o, r, "tjunction")
    r = trackasmlib.RegisterBranch(o, r, "intersection")
    r = trackasmlib.RegisterBranch(o, r, "elevated")
    return o, r:gsub("^_+", ""):gsub("_+$", "")
  end
]]

local new, err = load("return ("..fnc..")")
if not new then error("Compile error: "..err) end

local suc, new = pcall(new)
if not suc then error("Factory error: "..new) end

for i = 1, #tD do
  local mod = tD[i]
  local cat, nam = new(mod)
  if(istable(cat)) then cat = "("..table.concat(cat,"|")..")" end
  print(com.stringPadR(mod, 100, " ")..":", cat, nam)
end
