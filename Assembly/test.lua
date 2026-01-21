local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
                
local common = require("common")

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)

require("gmodlib")
require("trackasmlib")
asmlib = trackasmlib
require("Assembly/autorun/folder")

CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetLogControl(20000, false)

local oPieces = asmlib.GetBuilderNick("PIECES")

asmlib.Categorize("TEST-O")
oPieces:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl", "#", "x1", 1, "", "!test", "", "aaa"})
oPieces:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl", "#", "x1", 2, "", "1,2,4", "", "aaa"})
oPieces:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl", "#", "#", 1, "", "0,0,0", "", "aaa"})
oPieces:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl", "#", "x1", 2, "", "#1,2,3", "", "aaa"})
oPieces:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl", "#", "x1", 3, "", "#aaaa", "", "aaa"})
oPieces:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl", "#", "#", 4, "", "", "", "aaa"})

local stBase = oPieces:GetNavigate("TRACKASSEMBLY_PIECES")
local stData = oPieces:GetNavigate("TRACKASSEMBLY_PIECES", "models/props_phx/huge/road_short.mdl","Size")

common.logTable(stData, "stData")

