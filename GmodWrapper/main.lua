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
local rev = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/"
local bas = dir.getBase().."/ZeroBraineProjects/"

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)
require("gmodlib")

WireLib = WireLib or {}
WireLib.HasPorts = function() return true end
WireLib.E2Table = {New = {}}
WireLib.Net = {}
WireLib.Net.Trivial = {}
WireLib.Net.Trivial.Start = {}
WireLib._SetOutputs = function() end

dofile(rev.."wire/lua/wire/server/wirelib.lua")

ENT = ents.Create("TEST")

dofile(rev.."Wrappers-Gmod/wire.lua")

ENT:WireCreateOutputs(
  {"Name"}
)

ENT:WireWrite("Name", 12, true)
