local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki").addBase("D:/LuaIDE").setBase(1)

local common = require("common")

SERVER = true
CLIENT = true

require("gmodlib")
require("trackasmlib")
asmlib = trackasmlib

CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetOpVar("DIRPATH_BAS", dir.getBase(1).."/ZeroBraineProjects/Assembly/")
asmlib.SetLogControl(1000,false)

PIECES = asmlib.GetBuilderNick("PIECES")
require("Assembly/data/pieces")

local mod = "models/sprops/trans/train/track_s01.mdl"
local rec = asmlib.GetCache("TRACKASSEMBLY_PIECES")[mod]
asmlib.LogInstance(asmlib.GetOpVar("DIRPATH_BAS"))
asmlib.GetTransformOA("models/sprops/trans/train/track_s01.mdl", "test")
asmlib.GetTransformOA("models/sprops/trans/train/track_s02.mdl", "test")
