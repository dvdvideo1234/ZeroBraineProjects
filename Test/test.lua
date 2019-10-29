local com = require("dvdlualib/common")
local gmd = require("dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
local asmlib = trackasmlib

local tableConcat = table.concat

asmlib.InitBase("track", "assembly")
asmlib.SetOpVar("LOG_MAXLOGS", 10000)
asmlib.SetOpVar("LOG_LOGFILE", false)

asmlib.SetOpVar("FORM_DRWSPKY", "%+6s")

local o1 = Vector()
local d1 = Vector(3,3)
local o2 = Vector(8,7)
local d2 = Vector(1,0)

local f1, f2 = o1:IntersectRay(d1,o2,d2)
print(o1 + f1 * d1:GetNormalized(), o2 + f2 * d2:GetNormalized())


