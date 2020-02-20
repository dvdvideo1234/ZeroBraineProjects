package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
local sProject = "ExtractWireWiki"
local sBase = common.normFolder("E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects")
common.addLibrary(sBase, sProject, "dvdlualib")

local wikilib = require("wikilib")

local AAA = {
    ["COLLISION_GROUP"] = "11111111111",
    ["Material_surface_properties"] = "2222222222",
    ["MASK"] = "33333333",
    ["%s+%(`*TEST`*%)%s+"] = {["Test"] = "4444"}
}

local BBB = "Test COLLISION_GROUP Material_surface_properties (TEST) MASK  "

print(wikilib.replaceToken(BBB, AAA))
  
