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

"models/scene_building/sewer_system/arch_hall_3way.mdl",
"models/scene_building/sewer_system/arch_hall_4way.mdl",
"models/scene_building/sewer_system/arch_hall_corner.mdl",
"models/scene_building/sewer_system/arch_small_door1.mdl",
"models/scene_building/sewer_system/arch_small_door2.mdl",
"models/scene_building/sewer_system/arch_small_hall.mdl",
"models/scene_building/sewer_system/arch_small_hall_med.mdl",
"models/scene_building/sewer_system/arch_small_hall_small.mdl",
"models/scene_building/sewer_system/beam_door.mdl",
"models/scene_building/sewer_system/beam_hall.mdl",
"models/scene_building/sewer_system/beam_hall_sky.mdl",
"models/scene_building/sewer_system/beam_hall_sky_dip.mdl",
"models/scene_building/sewer_system/comp_roundroom.mdl",
"models/scene_building/sewer_system/tunnel_2door.mdl",
"models/scene_building/sewer_system/tunnel_2sec.mdl",
"models/scene_building/sewer_system/tunnel_3sec.mdl",
"models/scene_building/sewer_system/tunnel_big_bend.mdl",
"models/scene_building/sewer_system/tunnel_door.mdl",
"models/scene_building/sewer_system/tunnel_pipe_2sec.mdl",
"models/scene_building/sewer_system/tunnel_pipe_3sec.mdl",
"models/scene_building/sewer_system/tunnel_pipe_bend.mdl",
"models/scene_building/sewer_system/tunnel_pipe_bend_half.mdl",
"models/scene_building/sewer_system/tunnel_pipe_ent.mdl",
"models/scene_building/sewer_system/tunnel_pipe_ent_gate.mdl",
"models/scene_building/sewer_system/tunnel_pipe_long.mdl",
"models/scene_building/sewer_system/tunnel_pipe_mid.mdl",
"models/scene_building/sewer_system/tunnel_pipe_short.mdl",
"models/scene_building/sewer_system/tunnel_straight.mdl",
"models/scene_building/small_hallways/hall_1door.mdl",
"models/scene_building/small_hallways/hall_1door_med.mdl",
"models/scene_building/small_hallways/hall_1door_side.mdl",
"models/scene_building/small_hallways/hall_1door_sml.mdl",
"models/scene_building/small_hallways/hall_2door_l.mdl",
"models/scene_building/small_hallways/hall_2door_opp.mdl",
"models/scene_building/small_hallways/hall_2door_opp_small.mdl",
"models/scene_building/small_hallways/hall_2door_r.mdl",
"models/scene_building/small_hallways/hall_2door_side.mdl",
"models/scene_building/small_hallways/hall_3door.mdl",
"models/scene_building/small_hallways/hall_connector.mdl",
"models/scene_building/small_hallways/hall_connector_3way.mdl",
"models/scene_building/small_hallways/hall_connector_4way.mdl",
"models/scene_building/small_hallways/hall_connector_corner.mdl",
"models/scene_building/small_hallways/hall_connector_deadend.mdl",
"models/scene_building/small_rooms/1door.mdl",
"models/scene_building/small_rooms/1door_l.mdl",
"models/scene_building/small_rooms/1door_r.mdl",
"models/scene_building/small_rooms/2door_opp.mdl",
"models/scene_building/small_rooms/2door_opposites.mdl",
"models/scene_building/small_rooms/2door_opp_l.mdl",
"models/scene_building/small_rooms/2door_opp_ml.mdl",
"models/scene_building/small_rooms/2door_opp_mr.mdl",
"models/scene_building/small_rooms/2door_opp_r.mdl",
"models/scene_building/small_rooms/2door_sides.mdl",
"models/scene_building/small_rooms/3door.mdl",
"models/scene_building/small_rooms/4door.mdl",
"models/scene_building/small_rooms/stairs_straight.mdl"

}
-- function self:TimerSetup(vTim)
asmlib.Categorize(sT, [[function(m)
    local g = m:gsub("models/scene_building/","")
    local r = g:gsub("/.+$",""); return r end]])

local dat = asmlib.GetOpVar("TABLE_CATEGORIES")[sT]

com.logTable(dat, "CAT")

local out = assert(io.open("Assembly/trackassembly/trackasmlib_nodes.txt", "wb"))

for i = 1, #tD do
  local mod = tD[i]
  
  local nam = com.stringGetFileName(mod)
        nam = com.stringStripExtension(nam)
        nam = "# "..asmlib.GetBeautifyName(nam)
  local suc, cat, ovr = pcall(dat.Cmp, mod)
  if(not suc) then error(cat) end; if(not istable(cat)) then cat = {cat} end
  for i = 1, #cat do cat[i] = asmlib.GetBeautifyName(cat[i]) end; cat = "("..table.concat(cat,"|")..")"
  out:write(com.stringPadR(mod, 80, " ").." > "..com.stringPadR(cat, 35, " ").." > "..tostring(ovr or nam).."\n")
end

out:flush()
out:close()
