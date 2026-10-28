local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/Garrysmod",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)
     

local com = require("common")
local cmp = require("colormap")
local sbs, ibs = drpath.getBase()
local chk = com.stringGetChunkPath():gsub("\\", "/")
local rps = {
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/garrysmod-luapad",
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/garrysmod-luapad"
}

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", (not CLIENT))
require("gmodlib")
local bO = true
local sP = SERVER and "sv_" or (CLIENT and "cl_" or "na_")
drpath.ersRec("sv_syntax_globals.txt", com.normFolder(chk).."luapad")
drpath.ersRec("cl_syntax_globals.txt", com.normFolder(chk).."luapad")
local fC = assert(io.open(rps[ibs].."/lua/autorun/luapad.lua", "rb"))
if(bO) then
  local tF = common.stringExplodePattern(fC:read("*all"), "[\r\n]+")
  if(not tF) then print("Nothing to do!"); return end
  local fO, bH = assert(io.open(chk.."out.lua", "wb")), true
  for iF = 1, #tF do
    local vF = tF[iF]
    if(bH and vF:find("COLOR_STATUS", 1, true)) then
      fO:write("----------------------------\n")
      fO:write("\n")
      fO:write("luapad.GLOB_CONFIG = GLOB_CONFIG\n")
      fO:write("GLOB_CONFIG.FOLDER = \""..chk.."\"..GLOB_CONFIG.FOLDER\n")
      fO:write("\n")
      fO:write("print(\"L1\", 1, RunString)\n\n")
      bH = false
    end
    fO:write(vF.."\n")
  end
  fO:flush()
  fO:close()
end

dofile(chk.."out.lua")

fC:close()

