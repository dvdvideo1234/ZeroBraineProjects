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
     
common = require("common")
local cmp = require("colormap")
local sbs, ibs = drpath.getBase()
local chk = common.stringGetChunkPath():gsub("\\", "/"):match(".-/ZeroBraineProjects/(.*)")
local rps = {
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/Luapad-ME",
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/Luapad-ME"
}

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", (not CLIENT))
require("gmodlib")

function configureLuapad()
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
  dofile(rps[ibs].."/lua/autorun/luapad_editor.lua")
  drpath.ersRec("out.lua", common.normFolder(chk))
  fC:close()
end

configureLuapad()

local tx = vgui.Create("DLuapadEditor")
tx:SetText(file.Read(chk.."/luapad/test.txt"))
tx:SetSize(800, 400)
tx:PerformLayout()
print("Size:", table.concat(tx:GetTable().Size, "|"))
tx:Paint(tx:GetSize())
