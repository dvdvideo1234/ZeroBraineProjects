package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
local sProject = "ExtractWireWiki"
local sBase = common.normFolder("E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects")
common.addLibrary(sBase, sProject, "dvdlualib")
local wikilib = require("wikilib")


local s = "When you press you turn blue: *{f1+f1+f1}*"
local t = {"*{","}*"}


print(wikilib.parseKeyCombination(s,t,20))
