package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
local sProject = "ExtractWireWiki"
local sBase = common.normFolder("E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects")
common.addLibrary(sBase, sProject, "dvdlualib")
local wikilib = require("wikilib")

local sOut = sBase..common.normFolder("ExtractWireWiki/out").."test.md"

local s = "When you press you turn blue: *{k-f1+m-r+m-m+m-l}*"
local t = {"*{","}*"}

local f = assert(io.open(sOut, "wb"))
print("Open: "..sOut)
f:write(wikilib.parseKeyCombination(s,t,30,17))
f:write("\n")
f:flush()
f:close()
