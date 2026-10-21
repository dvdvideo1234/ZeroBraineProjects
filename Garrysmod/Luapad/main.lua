local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
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

rawset(_G, "CLIENT", false)
rawset(_G, "SERVER", (not CLIENT))
require("gmodlib")

print(math.ease.InBack( 0.1 ))

local fC = assert(io.open(rps[ibs].."/lua/autorun/luapad.lua", "rb"))
local sC = fC:read("*all"):gsub("local COLOR_STATUS = {", "luapad.GLOB_CONFIG = GLOB_CONFIG\nGLOB_CONFIG.FOLDER = \""..chk.."\"..GLOB_CONFIG.FOLDER\nlocal COLOR_STATUS = {")
local bS, sE = pcall(CompileString(sC))
if(not bS) then print(sC .. sE) else print(sC) end

