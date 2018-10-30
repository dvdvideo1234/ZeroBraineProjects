require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
local common = require("../dvdlualib/common")

asmlib.InitBase("track","assembly")


local sA = "2,4,7"

common.logTable(asmlib.SSSDecodePOA(sA))