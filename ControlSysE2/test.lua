local sIDE = "E:/Documents/Lua-Projs/ZeroBraineIDE/"
package.path = package.path..";"..sIDE.."myprograms/?.lua"

local api = "stcontrol"

require("dvdlualib/gmodlib")
require("dvdlualib/e2_"..api)

local ATTACH = ents.Create() -- ENT{1}{prop_physics}

local com = require("common")
local set = {
  [getmetatable(Vector())] = tostring,
  [getmetatable(ATTACH)] = tostring
}; local function dump(o) com.logTable(o, api, nil, set) end

local oSelf = {entity = ents.Create(), player = LocalPlayer()} -- ENT{2}{prop_physics}


local a = newItem(oSelf, ATTACH)
--[[
a:addHitSkip("GetModel", "1666")
a:addHitSkip("GetModel", 666)
a:addHitSkip("GetModel", "test")

a:addHitSkip("IsNPC", 1)

a:addEntityHitSkip(ents.Create())
a:addEntityHitSkip(ents.Create())
a:addEntityHitSkip(ents.Create())

a:addHitOnly("GetModel", "123")
]]
print("---------------")
--[[
--a:remHit("GetModel")
-- a:remHit("IsNPC")
  a:remHit("IsNPC1")
 a:remHit("IsNPC2")
]]
dump(a)

print("---------------")

a:dumpItem("NOTIFY")

