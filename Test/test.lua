local com = require("dvdlualib/common")
local gmd = require("dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
local asm = trackasmlib

asm.InitBase("track", "assembly")
asm.SetOpVar("LOG_MAXLOGS", 10000)
asm.SetOpVar("LOG_LOGFILE", false)

local a = asm.MakeContainer("a")
local b = asm.MakeContainer("a")

print(a,b)

a:Insert("1", "test1"):Insert("2", "test2"):Insert("7", "test7")
a:Insert(1, "int1"):Insert(2, "int2"):Insert(7, "int7")

print("---------------------------------------")
com.logTable(a:GetData(), "Data")
com.logTable(a:GetHashID(), "HashID")
print("TOP", a:GetSize())
print("CNT", a:GetCount())
print("SHA", a:GetKept())

a:Delete("2"):Delete(7)

print("---------------------------------------")
com.logTable(a:GetData(), "Data")
com.logTable(a:GetHashID(), "HashID")
print("TOP", a:GetSize())
print("CNT", a:GetCount())
print("SHA", a:GetKept())









