require("directories")
local common = require("common")
local wikilib = require("wikilib")


local s = "function setPistonMark(number nX, number nY, number nZ)"
local p = "%s*%(.+%)$"



print(s:sub(s:find(p)))
