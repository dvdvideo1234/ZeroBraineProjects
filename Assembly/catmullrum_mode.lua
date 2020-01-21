package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
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


local v1 = Vector(1,2,3)
local v2 = Vector(3,2,1)
local v3 = Vector(2,1,7.1)
local v4 = Vector(10,-5,2)
local v5 = Vector(11,-3,7)

common.logTable(asmlib.GetCatmullRomCurve({v1,v2,v3,v4,v5},5),"CRV",{},{["Vector"]=tostring})

