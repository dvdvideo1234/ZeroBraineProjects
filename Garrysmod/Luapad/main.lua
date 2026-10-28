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

drpath.ersRec("sv_syntax_globals.txt", com.normFolder(chk).."luapad")
drpath.ersRec("cl_syntax_globals.txt", com.normFolder(chk).."luapad")

function runScript()
  local bO = true
  local sP = SERVER and "sv_" or (CLIENT and "cl_" or "na_")
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
        bH = false
      end
      fO:write(vF.."\n")
      if(vF:find("^end$") or vF:find("end%)$")) then
        fO:write("\n")
      end
    end
    fO:flush()
    fO:close()
  end

  dofile(chk.."out.lua")
  
  if(SERVER) then 
    RunString(file.Read(luapad.GLOB_CONFIG.FOLDER.."sv_syntax_globals.txt", "DATA"))
  end
  
  fC:close()
end

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", (not CLIENT))
runScript()

if(luapad._sG) then
  print("CLIENT --- Source:", luapad.GLOB_CONFIG.FOLDER, luapad._sG["AddCSLuaFile"])
else
  print("CLIENT --- Source:", luapad.GLOB_CONFIG.FOLDER, "The syntax _sG is missing for "..tostring(luapad).."!")
end

rawset(_G, "CLIENT", false)
rawset(_G, "SERVER", (not CLIENT))
runScript()

if(luapad._sG) then
  print("SERVER --- Source:", luapad.GLOB_CONFIG.FOLDER, luapad._sG["AddCSLuaFile"])
else
  print("SERVER --- Source:", luapad.GLOB_CONFIG.FOLDER, "The syntax _sG is missing for "..tostring(luapad).."!")
end
