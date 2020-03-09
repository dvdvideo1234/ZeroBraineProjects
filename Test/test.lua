package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
local sProject = "ExtractWireWiki"
local sBase = common.normFolder("E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects")
common.addLibrary(sBase, sProject, "dvdlualib")
local wikilib = require("wikilib")

local gsTool = "physprop_adv"
local gsFLng = ("%s"..gsTool.."/lang/%s")
local sT = "test"

print(gsFLng:format("", sT..".lua"))
print("lua/"..gsFLng:format("", sT..".lua"))
print(gsFLng:format("lua/", sT..".lua"))