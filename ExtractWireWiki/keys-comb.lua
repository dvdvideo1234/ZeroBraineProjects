local drpath = require("directories")
local common = require("common")
local wikilib = require("wikilib")

local sOut = drpath.getBase()..common.normFolder("/ZeroBraineProjects/ExtractWireWiki/out").."test.md"

local s = "When you press you turn blue: *{k-f1+m-r+m-m+m-l}*"
local t = {"*{","}*"}

local f = assert(io.open(sOut, "wb"))
print("Open: "..sOut)
f:write(wikilib.parseKeyCombination(s,t,30,17))
f:write("\n")
f:flush()
f:close()
