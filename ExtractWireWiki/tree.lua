local sProg   = "ExtractWireWiki/"
local treelib = require(sProg.."lib/treelib")
local common  = require('common')


local sP = "E:/Documents/Lua-Projs/SVN/ControlSystemsE2"

local tD = treelib.readPath(sP)

common.logTable(tD, "tDIR")

treelib.drawPath(tD)


--[[

addons
└───gmod-fakeoverlay
    ├───lua
    │   └───autorun
    │       └───client
    │       └───server
    └───materials
        └───fakeover

]]