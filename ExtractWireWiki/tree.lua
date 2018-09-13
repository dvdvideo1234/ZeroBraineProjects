local sProg = "ExtractWireWiki"
local wikilib = require(sProg.."/lib/wikilib")
local sP = "E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/"..sProg.."/"

-- Switch encoding to UTF8
wikilib.folderSet(sP, "out/")

local sD = "E:/Documents/Lua-Projs/SVN/TrackAssemblyTool_GIT_master"
local fO, oE = io.open(sProg.."/out/tree.md", "wb")
if(fO) then io.output(fO)
  -- Tell the read application we are using UTF-8 by writing a BOM
  wikilib.writeBOM("UTF8")
  -- Write the tree
  wikilib.folderDrawTree(wikilib.folderReadStructure((sD):gsub("\\","/")), 2)
else
  error("Output error: "..oE)
end
