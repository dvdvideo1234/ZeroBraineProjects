local sInstDir = "D:/LuaIDE/"

package.path = package.path..";"..sInstDir.."myprograms/?.lua"
local common = require("common")
local sProject = "ExtractWireWiki"
local sBase = common.normFolder(sInstDir.."ZeroBraineProjects")
common.addLibrary(sBase, sProject, "dvdlualib")
local wikilib = require("wikilib")

print(common.randomGetString(40))