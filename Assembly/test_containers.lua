package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/?.lua"

CLIENT = true

local common = require("common")
require("dvdlualib/gmodlib")
require("dvdlualib/asmlib")
local asmlib = trackasmlib

asmlib.InitBase("track", "assembly")

local a = asmlib.MakeContainer("lol")
a:Push(11)
a:Push(22)
a:Push(33)
a:Push(44)
a:Push(55)
a:Record("1",111)
a:Record("2",222)
a:Record("3",333)

print("ghh", a:KeyFind(333))

common.logTable(a:GetData(),"GetData")
common.logTable(a:GetHashID(),"GetHashID")

print("-----------------------------")
local v = a:Pull(3)
a:Delete("2")

common.logTable(a:GetData(),"GetData")
common.logTable(a:GetHashID(),"GetHashID")

