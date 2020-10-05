local dir = require("directories").setBase(1)
local com = require("common")
local cpx = require("complex")
local tableRemove = table and table.remove

TOOL = {Mode = "wire_joystick"}

local gsToolModeOP = TOOL.Mode
local gsToolTabTOP = gsToolModeOP:match("%w+$"):gsub("^%l", string.upper)
local gsToolPrefix = gsToolModeOP.."_"
local gsToolLimits = gsToolModeOP:gsub("_multi", "").."s"
local gsSentClasMK = "gmod_"..gsToolModeOP


print(gsToolTabTOP)
print(gsToolModeOP)
print(gsToolPrefix)
print(gsToolLimits)
print(gsSentClasMK)