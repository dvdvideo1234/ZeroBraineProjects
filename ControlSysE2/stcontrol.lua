local sIDE = "E:/Documents/Lua-Projs/ZeroBraineIDE/"
package.path = package.path..";"..sIDE.."myprograms/?.lua"

local api = "stcontrol"

function registerType() end
E2Lib = {RegisterExtension = function(...) print(...) end}

HUD_PRINTTALK = 50

require("dvdlualib/gmodlib")
local common = require("dvdlualib/common")
require("dvdlualib/e2_"..api)

local ATTACH = ents.Create() -- ENT{1}{prop_physics}

local com = require("common")
local set = {
  [getmetatable(Vector())] = tostring,
  [getmetatable(ATTACH)] = tostring
}; local function dump(o) com.logTable(o, api, nil, set) end

local oSelf = {entity = ents.Create("gmod_wire_e2"), player = LocalPlayer()} -- ENT{2}{prop_physics}
oSelf.entity:SetPos(Vector(100,100,100))
ATTACH:SetPos(Vector(500,500,500))

local a = newItem(oSelf)
      
GetConVar("wire_expression2_"..api.."_enst"):SetData(1)

a:dumpItem("TALK", "test")


