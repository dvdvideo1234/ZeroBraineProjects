local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local code = "trackassembly"
local com = require("common")
local prop = require("gmodlib/custom/properties")
io.stdout:setvbuf("no")

local ssrc, isrc = dir.getBase()
local src = {
  "D:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons",
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl"
}

local par = require("GmodLanguage/Sync/parameters/"..code)
      par.run_pth = dir.getNorm(com.stringGetChunkPath())
      par.run_src = src[isrc], -- Data source addon folder

dir.ersDir("orig", par.run_pth.."/localization")
dir.newDir("orig", par.run_pth.."/localization")
dir.ersDir("sync", par.run_pth.."/localization")
dir.newDir("sync", par.run_pth.."/localization")

local res = prop.syncLocalizations(par)

local lst = prop.newList()
      lst:setBase(par.run_src)
      lst:recItem(par.prf_src[1], par.prf_src[2], unpack(res.__index))
      lst:isItems()