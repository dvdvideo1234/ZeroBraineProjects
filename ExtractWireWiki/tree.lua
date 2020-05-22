require("directories")
local drpath = require("directories")
local common = require("common")
local sProject = "ExtractWireWiki"

local sEXP = "physprop_adv"
local sSVN = "PhysPropertiesAdv"
local dSVN = "E:/Documents/Lua-Projs/SVN/"..sSVN

local wikilib = require("wikilib")
local API     = require("api/"..sEXP)

local sB = sBase..common.normFolder(sProject)
local sD = common.normFolder(dSVN)
local fO, oE = io.open(sB.."out/tree.md", "wb")
if(fO and API) then io.output(fO)
  -- Setup flags
  -- wikilib.folderFlag("prnt", true)
  wikilib.folderFlag("size", true)
  wikilib.folderFlag("urls", true)
  wikilib.folderFlag("namr", true)
  wikilib.folderFlag("ufbr", true)
  -- Tell the api to use file URL
  wikilib.folderReplaceURL(sD, API.FILE.repo, API.FILE.blob)
  -- Tell the read application we are using UTF-8 by writing a BOM
  wikilib.writeBOM("UTF8")
  -- Read structure
  local tS = wikilib.folderReadStructure(sD)
  -- common.logTable(tS)
  -- Write the tree
  wikilib.folderDrawTree(tS, 2, nil, nil, API.FILE.desc, API.FILE.repo, API.REPLACE)
  wikilib.folderDrawTreeRef()
else
  print("API:", API)
  error("Output error: "..oE)
end

