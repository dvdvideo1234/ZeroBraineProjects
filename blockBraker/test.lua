--[[
local complex      = require("complex")
local common       = require("blockBraker/common")
local export       = require("export")

local a = common.stringExplode("1,2",";")
export.Table(a)

1,2
2,3
3,4
4,1
]]