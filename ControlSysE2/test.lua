local sIDE = "E:/Documents/Lua-Projs/ZeroBraineIDE/"
package.path = package.path..";"..sIDE.."myprograms/?.lua"

local api = "fsensor"

require("dvdlualib/gmodlib")
require("dvdlualib/e2_"..api)

local ATTACH = ents.Create() -- ENT{1}{prop_physics}

local com = require("common")
local set = {
  [getmetatable(Vector())] = tostring,
  [getmetatable(ATTACH)] = tostring
}; local function dump(o) com.logTable(o, api, nil, set) end

local oSelf = {entity = ents.Create()} -- ENT{2}{prop_physics}


local a = newItem(oSelf, ATTACH)

--a:addHitSkip("GetModel", "test")
--a:addHitSkip("GetModel", "666")
--a:addHitOnly("GetModel", "123")

--a:addHitSkip("IsNPC", 1)

--a:addEntityHitSkip(ents.Create())
--a:addEntityHitSkip(ents.Create())
--a:addEntityHitSkip(ents.Create())

print("---------------")

print("---------------")

dump(a:dumpItem("test"))

