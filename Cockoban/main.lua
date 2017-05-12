require("turtle")
require("wx")
require("ZeroBraineProjects/dvdlualib/common")
local barn = require("ZeroBraineProjects/Cockoban/barn")
local wall = require("ZeroBraineProjects/Cockoban/wall")
local farmer = require("ZeroBraineProjects/Cockoban/farmer")
local nest = require("ZeroBraineProjects/Cockoban/nest")
-- barn:getParts("ZeroBraineProjects/Cockoban/1.txt")

local a = wall:makeNew{x=1,y=1} a:setDefault():dumpMe()
local b = wall:makeNew{x=2,y=2} b:setDefault():dumpMe()
local c = farmer:makeNew{x=2,y=2} c:setDefault():dumpMe()
local d = nest:makeNew{x=2,y=2} d:setDefault():dumpMe("test")

logTable(a,"wall")
logTable(getmetatable(a))

logTable(c)
logTable(getmetatable(c))

logTable(d,"nest")
logTable(getmetatable(d))