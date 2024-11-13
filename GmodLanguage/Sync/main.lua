local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local com = require("common")
local prop = require("gmodlib/custom/properties")
io.stdout:setvbuf("no")

local ssrc, isrc = dir.getBase()
local src = {
  "D:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons",
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl"
}

local par = {
  -- Key patterns being ignored when searching dor dupes
  dup_all = { en = true, all = true,-- Enable ot disable the ignore
    "left%.%d", "right_use%.%d",
    "reload%.%d", "right%.%d", "reload_use%.%d"
  }, -- Forlder prefixes for data source
  dup_any = { en = true, any = false, -- Enable ot disable the ignore
    "pn_contextm_"
  }, -- Forlder prefixes for data source
  run_pth = dir.getNorm(com.stringGetChunkPath()),
  run_src = src[isrc], -- Data source addon folder
  prf_src = {"TrackAssemblyTool_GIT", "trackassembly"},
  prm_lng = "en",    -- English is primary gmod language
  cnt_len = 2,       -- How many symbols to display dupes count
  key_len = 60       -- How many symbols to display keys
}

prop.syncLocalizations(par)
