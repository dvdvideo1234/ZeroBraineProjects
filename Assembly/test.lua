require("directories")
local common = require("common")

SERVER = true
CLIENT = true

require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
asmlib = trackasmlib
CreateConVar("gmod_language")
require("Assembly/autorun/config")
PIECES = asmlib.GetBuilderNick("PIECES")
require("Assembly/data/pieces")
---------------------------------------------------------------------------------------
local a = asmlib.CacheQueryPiece("models/sligwolf/rerailer/rerailer_1.mdl")

common.logTable(a)

local a = "Prop Cannon Projectile"

print(a:lower():gsub("prop%s*cannon", "propcannon"):gsub(" ", "_"))