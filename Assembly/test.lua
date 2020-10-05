require("directories").setBase(1)
local common = require("common")

SERVER = true
CLIENT = true

require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
asmlib = trackasmlib
asmlib.InitBase("track","assembly")

local function IsValid(a) return a~=nil end 

local ENT = {Inputs={test={Src=true}}}
WireLib = {}

local tP, sP = ENT["Inputs"], tostring("test")

tP = (tP and tP[sP] or nil)

print(tP, sP)