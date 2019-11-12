package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local basepg = "E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects"
local common = require("common")
common.addLibrary(basepg, "ExtractWireWiki")

local sEXP = "prop"
local sSVN = "Wire"

local wikilib = require("lib/wikilib")
local API     = require("api/"..sEXP)

local sD = wikilib.common.normFolder("E:/Documents/Lua-Projs/SVN/"..sSVN)
local fO, oE = io.open("out/tree.md", "wb")
if(fO and API) then io.output(fO)
  -- Setup flags
  wikilib.folderFlag("size", true)
  wikilib.folderFlag("urls", true)
  wikilib.folderFlag("namr", true)
  -- Tell the api to use file URL
  wikilib.folderReplaceURL(sD, API.FILE.repo, API.FILE.blob)
  -- Tell the read application we are using UTF-8 by writing a BOM
  wikilib.writeBOM("UTF8")
  -- Read structure
  local tS = wikilib.folderReadStructure(sD)
  common.logTable(tS)
  -- Write the tree
  wikilib.folderDrawTree(tS, 2, nil, nil, API.FILE.desc, API.FILE.repo)
else
  error("Output error: "..oE)
end
