package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
local sProject = "ExtractWireWiki"
local sBase = common.normFolder("E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects")
common.addLibrary(sBase, sProject, "dvdlualib")
local wikilib = require("wikilib")

local f = "https://placehold.it/%dx%d/%x%x%x/%x%x%x?text=%s"

wikilib.setPlaceHolderColor({0,  0, 255}, {0 ,0, 0})
print(wikilib.getBanner("A", 15))

wikilib.setPlaceHolderColor({0, 255, 0}, {0 ,0, 0})
print(wikilib.getBanner("L", 15))

wikilib.setPlaceHolderColor({0, 0, 255}, {0 ,0, 0})
print(wikilib.getBanner("F", 15))

wikilib.setPlaceHolderColor({255, 255, 0}, {0 ,0, 0})
print(wikilib.getBanner("C", 15))