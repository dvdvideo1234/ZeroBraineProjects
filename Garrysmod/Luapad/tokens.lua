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

dofile(rps[ibs].."/lua/autorun/luapad.lua")

dofile(rps[ibs].."/lua/autorun/luapad_editor.lua")

local tx = vgui.Create("DLuapadEditor")
tx:SetText(file.Read(chk.."/luapad/test.txt"))
tx:Paint(800, 400)
