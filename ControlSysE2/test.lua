local sIDE = "E:/Documents/Lua-Projs/ZeroBraineIDE/"
package.path = package.path..";"..sIDE.."myprograms/?.lua"

local api = "fsensor"

require("dvdlualib/e2_"..api)
local com = require("common")


local oSelf = {entity = makeEntity()}

local a = newItem(oSelf)
local b = newItem(oSelf)
local c = newItem(oSelf)
local d = newItem(oSelf)
local e = newItem(oSelf)

a:addHitSkip("GetModel", "test")
a:addHitSkip("GetModel", "666")

a:addHitSkip("IsNPC", 1)
print("---------------")
com.logTable(a)