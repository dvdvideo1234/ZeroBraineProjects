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
local chk = com.stringGetChunkPath():gsub("\\", "/"):match(".-/ZeroBraineProjects/(.*)")
local rps = {
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/Luapad-ME",
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/Luapad-ME"
}

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", (not CLIENT))
require("gmodlib")

drpath.ersRec("sv_syntax_globals.txt", com.normFolder(chk).."luapad/settings")
drpath.ersRec("cl_syntax_globals.txt", com.normFolder(chk).."luapad/settings")

function configureLuapad()
  local bO = true
  local sP = SERVER and "sv_" or (CLIENT and "cl_" or "na_")
  local fC = assert(io.open(rps[ibs].."/lua/autorun/luapad.lua", "rb"))
  if(bO) then
    local tF = com.stringExplodePattern(fC:read("*all"), "[\r\n]+")
    if(not tF) then print("Nothing to do!"); return end
    local fO, bH = assert(io.open(chk.."out.lua", "wb")), true
    for iF = 1, #tF do
      local vF = tF[iF]
      if(bH and vF:find("COLOR_STATUS", 1, true)) then
        fO:write("----------------------------\n")
        fO:write("\n")
        fO:write("luapad.GLOB_CONFIG = GLOB_CONFIG\n")
        fO:write("GLOB_CONFIG.DATADR[2] = \""..chk.."\"..GLOB_CONFIG.DATADR[2]\n")
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
  drpath.ersRec("out.lua", com.normFolder(chk))
  fC:close()
end

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", (not CLIENT))
configureLuapad()

if(luapad._sG) then
  print("CLIENT --- Source:", luapad.GLOB_CONFIG.DATADR[2], luapad._sG["AddCSLuaFile"])
else
  print("CLIENT --- Source:", luapad.GLOB_CONFIG.DATADR[2], "The syntax _sG is missing for "..tostring(luapad).."!")
end

rawset(_G, "CLIENT", false)
rawset(_G, "SERVER", (not CLIENT))
configureLuapad()

if(SERVER and file.Exists(luapad.GLOB_CONFIG.DATADR[2]..table.concat(luapad.GLOB_CONFIG.SYNTAX):format("sv"), "DATA")) then 
  RunString(file.Read(luapad.GLOB_CONFIG.DATADR[2]..table.concat(luapad.GLOB_CONFIG.SYNTAX):format("sv"), "DATA"))
end

if(luapad._sG) then
  print("SERVER --- Source:", luapad.GLOB_CONFIG.DATADR[2], luapad._sG["AddCSLuaFile"])
else
  print("SERVER --- Source:", luapad.GLOB_CONFIG.DATADR[2], "The syntax _sG is missing for "..tostring(luapad).."!")
end
