require("turtle")
require("wx")
require("ZeroBraineProjects/dvdlualib/common")
local sta = require("ZeroBraineProjects/Sokoban/state")
local ply = require("ZeroBraineProjects/Sokoban/player")

logTable(sta,"lib-sta")
logTable(ply,"lib-ply")


local tItemList = {}

local function readLevel()
  
end

local b = sta:newState(5,0)
local a = ply:newPlayer(7,6)

logTable(b,"inst-sta")
logTable(getmetatable(b),"mt-sta")
logTable(a,"inst-ply")
logTable(getmetatable(a),"mt-ply")


a:Dump()
a:setPosition(1,2)
a:Dump()

