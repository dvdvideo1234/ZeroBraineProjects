local sInstDir = "D:/LuaIDE/"

package.path = package.path..";"..sInstDir.."myprograms/?.lua"
local common = require("common")
local sProject = "ExtractWireWiki"
local sBase = common.normFolder(sInstDir.."ZeroBraineProjects")
common.addLibrary(sBase, sProject, "dvdlualib")
local wikilib = require("wikilib")

print(common.randomGetString(20))

SERVER = true

local sI = (SERVER and "SERVER" or (CLIENT and "CLIENT" or "NOINST"))

print(sI, os.date("%y-%m-%d").." "..os.date("%H:%M:%S"))