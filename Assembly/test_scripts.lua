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

asmlib.SetLogControl(20000, 0)

asmlib.IsFlag("file_read_once", true)

require("Assembly/scripts/sligwolf_s_suspension_train")

local P = asmlib.GetBuilderNick("PIECES")

asmlib.ImportCategory(0, "sligwolf_s_suspension_train")




