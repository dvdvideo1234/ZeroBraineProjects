local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE")
      dir.setBase(2)

local common = require("common")

SERVER = true
CLIENT = true

require("gmodlib")
function game.SinglePlayer() return false end

require("trackasmlib")
asmlib = trackasmlib
asmlib.IsModel = function(m) return true end

CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetLogControl(1000,false)

local e = ents.Create("TEST")

local oR = asmlib.CacheQueryPiece("models/props_phx/trains/monorail1.mdl")
if(oR) then
  print(oR.Slot)
end

asmlib.GetAttachmentByID(e:EntIndex(), "Pos")
