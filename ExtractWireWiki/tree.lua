local sProg   = "ExtractWireWiki/"
local wikilib = require(sProg.."lib/wikilib")

local sP = ("E:\\Documents\\Lua-Projs\\SVN\\TrackAssemblyTool_GIT_master"):gsub("\\","/")

wikilib.folderDrawTree(wikilib.folderReadStructure(sP), 2)
