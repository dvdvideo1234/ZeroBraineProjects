package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

local com = require("dvdlualib/common")
local gmd = require("dvdlualib/gmodlib")
local pth = "E:/Documents/////Lua-Projs\\\\ZeroBraineIDE/ZeroBraineProjects/dvdlualib/*.lua"
local a = file.Find(pth, "GAME", "datedesc")

com.logTable(a)
