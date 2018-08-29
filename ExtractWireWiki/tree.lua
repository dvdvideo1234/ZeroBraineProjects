local sProg   = "ExtractWireWiki/"
local wikilib = require(sProg.."lib/wikilib")
local common  = require('common')


local sP = "E:/Documents/Lua-Projs/SVN/ControlSystemsE2"

local tD = wikilib.readFolderStructure(sP)

-- common.logTable(tD, "tDIR")

wikilib.drawFolderTreeASCII(tD, 2)
