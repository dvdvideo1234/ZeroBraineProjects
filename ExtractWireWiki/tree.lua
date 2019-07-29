package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

local common = require('common')
local sProg  = ""
local sExp   = "trackasmlib"

local wikilib = require(sProg.."lib/wikilib")
local API     = require(sProg.."api/"..sExp)
local sP = "E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/"..sProg

wikilib.folderSet("D:/SystemTemp")

local sSVN = "TrackAssemblyTool_GIT_master"

local sD = "E:/Documents/Lua-Projs/SVN/"..sSVN
local fO, oE = io.open(sProg.."out/tree.md", "wb")
if(fO and API) then io.output(fO)
  -- Setup flags
  wikilib.folderFlag("size", true)
  wikilib.folderFlag("urls", true)
  -- Tell the api to use file URL
  wikilib.folderReplaceURL(sD,API.FILE.blob)
  -- Tell the read application we are using UTF-8 by writing a BOM
  wikilib.writeBOM("UTF8")
  -- Read structure
  local tS = wikilib.folderReadStructure((sD):gsub("\\","/"))
  -- Write the tree
  wikilib.folderDrawTree(tS, 2, nil, nil, API.FILE.desc)
else
  error("Output error: "..oE)
end
