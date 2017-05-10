require("turtle")
require("wx")
require("ZeroBraineProjects/dvdlualib/common")
local sta = require("ZeroBraineProjects/Sokoban/state")
local ply = require("ZeroBraineProjects/Sokoban/player")

local tItemList = {}

local function readLevel()
  
end

local b = sta:newState(5,0)
local a = ply:newPlayer(7,6)
local c = ply:newPlayer(4,4)

logTable(b,"sta")
logTable(getmetatable(b),"mt-sta")
logTable(a,"ply")
logTable(getmetatable(a),"mt-ply")


a:Dump()
a:setPosition(1,2)
a:Dump()

