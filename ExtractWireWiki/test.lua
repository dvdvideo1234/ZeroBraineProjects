package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
local sProject = "ExtractWireWiki"
local sBase = common.normFolder("E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects")
common.addLibrary(sBase, sProject, "dvdlualib")
local wikilib = require("wikilib")


local s1 = "Pattern	Tunes the state control using the Chien-Hrones-Reswick method (`IAE`) load rejection"
local s2 = "Pattern	Tunes the state control using the Chien-Hrones-Reswick method (`ISE`) load rejection"
local s3 = "Pattern	Tunes the state control using the Chien-Hrones-Reswick method (`ITAE`) load rejection"
local p = "%s+%(`*I[AS]E`*%)%s+"



print(s2:find(p))
