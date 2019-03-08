local gmodlib = require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib"); local asmlib = trackasmlib
local common = require("../dvdlualib/common")

asmlib.InitBase("track","assembly")

local v1 = Vector(1,2,3)
local v2 = Vector(3,2,1)
local v3 = Vector(2,1,7.1)
local v4 = Vector(10,-5,2)
local v5 = Vector(11,-3,7)

common.logTable(asmlib.GetCatmullCurve({v1,v2,v3,v4,v5},5),"CRV",{},{["Vector"]=tostring})

