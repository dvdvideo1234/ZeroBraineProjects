package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

local com = require('common')
local sProg = "ExtractWireWiki"
local wikilib = require(sProg.."/lib/wikilib")
local sP = "E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/"..sProg.."/"

wikilib.folderSet("D:/SystemTemp")

local sSVN = "SpinnerTool"

local sD = "E:/Documents/Lua-Projs/SVN/"..sSVN
local fO, oE = io.open(sProg.."/out/tree.md", "wb")
if(fO) then io.output(fO)
  -- Setup flags
  wikilib.folderFlag("size", true)
  wikilib.folderFlag("urls", true)
  -- Tell the api to use file URL
  wikilib.folderReplaceURL(sD,"https://github.com/dvdvideo1234/SpinnerTool/blob/master/")
  -- Tell the read application we are using UTF-8 by writing a BOM
  wikilib.writeBOM("UTF8")
  -- Read structure
  local tS = wikilib.folderReadStructure((sD):gsub("\\","/"))
  -- com.logTable(tS)
  -- Write the tree
  wikilib.folderDrawTree(tS, 2)
else
  error("Output error: "..oE)
end
