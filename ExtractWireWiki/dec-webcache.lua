require("directories")
local wikilib = require("wikilib")
local common  = require("common")

wikilib.setDecoderURL("UTF-8")

local url = "https://github.com/wiremod/wire/blob/master/materials/expression%202"

print(wikilib.getDecodeURL(url))
print("-------------------------------------")
common.addLibrary(sIDE, tIDE)
