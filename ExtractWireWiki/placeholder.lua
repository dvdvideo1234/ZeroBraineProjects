local directories = require("directories")
local common = require("common")
local wikilib = require("wikilib")

local f = "https://placehold.it/%dx%d/%x%x%x/%x%x%x?text=%s"

wikilib.setPlaceHolderColor(0, 255, 0, 0, 0, 0)
print(wikilib.getBanner(" ", 18))
