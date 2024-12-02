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
asmlib = trackasmlib
if(not asmlib) then error("No library") end
require("Assembly/autorun/config")

asmlib.IsModel = function(m) return isstring(m) end
asmlib.SetLogControl(20000, false)

local tC = asmlib.GetOpVar("TABLE_CATEGORIES")

--asmlib.ImportDSV("PIECES", true, "poa_", nil, false)

asmlib.ImportDSV("Assembly/trackassembly/dsv/poa_TRACKASSEMBLY_PIECES.txt", true)

local r = asmlib.CacheQueryPiece("models/props_lab/blastdoor001b.mdl")
print("Record:", r and r.Slot or "N/A")

asmlib.ExportDSV("PIECES", "new_", nil, true)


  