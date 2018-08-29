local sProg   = "ExtractWireWiki/"
local wikilib = require(sProg.."lib/wikilib")
local common  = require('common')


local sP = "E:/Documents/Lua-Projs/SVN/ControlSystemsE2"

local tD = wikilib.readFolderStructure(sP)

-- common.logTable(tD, "tDIR")

wikilib.drawFolderTreeASCII(tD)


--[[

addons
├───gmod-fakeoverlay
│   ├───lua
│   │   └───autorun
│   │       ├───client
│   │       └───server
│   ├───materials
│   │   └───fakeover
│   ├───file3
│   └───file4
└───file1
]]