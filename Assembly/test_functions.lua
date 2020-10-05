local dir = require("directories").setBase(1)
local com = require("common")
local cpx = require("complex")
require("dvdlualib/asmlib")
local asmlib = trackasmlib
asmlib.InitBase("track","assembly")
--[[
function common.stringToNyan(sR)
  return sR:gsub("([Nn])(a)", "%1y%2")
end
]]

local TOOL = {Mode = "wire_joystick_multi"}

local gsToolModeOP = TOOL.Mode
local gsToolPrefix = TOOL.Mode.."_"
local gsToolLimits = TOOL.Mode:gsub("_multi", "")

TOOL.Name = gsToolModeOP:gsub("wire",""):gsub("%W+", " "):gsub("%s+%w", string.upper):sub(2, -1)

print("gsToolModeOP", "<"..gsToolModeOP..">")
print("gsToolPrefix", "<"..gsToolPrefix..">")
print("gsToolLimits", "<"..gsToolLimits..">")
print("TOOL.Name"   , "<"..TOOL.Name..">"   )











