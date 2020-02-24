package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
local sProject = "ExtractWireWiki"
local sBase = common.normFolder("E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects")
common.addLibrary(sBase, sProject, "dvdlualib")
local wikilib = require("wikilib")

local a = {1, 2, 3}

b = {}
b.set = function(b, ...)
  print(...)
end

b:set(unpack(a))