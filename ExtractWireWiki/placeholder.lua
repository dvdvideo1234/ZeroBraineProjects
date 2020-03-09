package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
local sProject = "ExtractWireWiki"
local sBase = common.normFolder("E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects")
common.addLibrary(sBase, sProject, "dvdlualib")
local wikilib = require("wikilib")

local f = "https://placehold.it/%dx%d/%x%x%x/%x%x%x?text=%s"


wikilib.setPlaceHolderColor({255,  0, 0}, {0 ,0, 0})
print(wikilib.getBanner("RED", 15))
wikilib.setPlaceHolderColor({0, 255, 0}, {0 ,0, 0})
print(wikilib.getBanner("GREEN", 15))
wikilib.setPlaceHolderColor({0,  0, 255}, {0 ,0, 0})
print(wikilib.getBanner("BLUE", 15))
wikilib.setPlaceHolderColor({255,  255, 0}, {0 ,0, 0})
print(wikilib.getBanner("YELLOW", 15))
wikilib.setPlaceHolderColor({0, 255, 255}, {0 ,0, 0})
print(wikilib.getBanner("CYAN", 15))
wikilib.setPlaceHolderColor({255,  0, 255}, {0 ,0, 0})
print(wikilib.getBanner("MAGEN", 15))
