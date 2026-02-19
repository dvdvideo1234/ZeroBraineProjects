local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
                
local com = require("common")

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)

require("gmodlib")
require("trackasmlib")
local asmlib = trackasmlib
if(not asmlib) then error("No library") end
require("Assembly/autorun/folder")
require("Assembly/autorun/config")

asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end
asmlib.SetLogControl(20000, false)

local tC = asmlib.GetOpVar("TABLE_CATEGORIES")
--asmlib.ImportDSV("PIECES", true, "Plarail", nil, false)
asmlib.ImportDSV("PIECES", true, "poa_", nil, false)

--[[

--mak:Erase("models/ron/plarail/tracks/curve/r03_left.mdl")
--mak:Erase()

local r = asmlib.CacheQueryPiece("models/props_lab/blastdoor001b.mdl")
if(r) then
  print("Record:", r and r.Slot or "N/A")
  local mak = asmlib.GetBuilderNick("PIECES")
  local def = mak:GetDefinition()
  local mod = mak:GetNavigate(def.Name, r.Slot)
  print("Navigate:", mod[r.Slot] == r)
  local sym, fmc = "", "%"..tostring(r.Size):len().."d"
  local function f(s)
    local p = common.stringPadL(s:gsub("%s+", ""), 12, sym)
    return p
  end
  for i = 1, r.Size do
    local o = asmlib.LocatePOA(r, i)
    local n = fmc:format(i)
    sym = ">"; print("Raw", n, f(o.P:Raw()), f(o.O:Raw()), f(o.A:Raw()))
    sym = "."; print("Dec", n, f(o.P:String()), f(o.O:String()), f(o.A:String()))
  end
else
  print("Record:","N/A")
end
]]
local stType = asmlib.CacheQueryProperty()
if(stType) then
  common.logTable(stType, "stType")
  local stName = asmlib.CacheQueryProperty(stType[1])
  common.logTable(stName, "stName")
end
