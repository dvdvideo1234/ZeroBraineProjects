package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

local com = require("common")
local gmd = require("dvdlualib/gmodlib")

local gsClass = "gmod_wire_dupeport"
local gsLimit = gsClass:gsub("gmod_","").."s"

print(gsLimit)