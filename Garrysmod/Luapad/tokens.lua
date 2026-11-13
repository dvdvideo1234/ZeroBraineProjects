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

dofile(rps[ibs].."/lua/autorun/luapad_editor.lua")

print(Vector(), Angle(), Matrix(), Color(0,0,0,0), ents.Create("asdasd"))

local tx = vgui.Create("DLuapadEditor")

tx:Paint(800, 400)
