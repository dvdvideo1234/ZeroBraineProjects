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

CLIENT = true
SERVER = true

require("gmodlib")
require("trackasmlib")
local common = require("common")
local asmlib = trackasmlib

CreateConVar("gmod_language")
require("Assembly/autorun/config")
asmlib.SetLogControl(10000, true)

require("Assembly/autorun/shinji")

local sT = "shinji85_s_rails"

asmlib.ImportDSV("PIECES", true, sT)
asmlib.ImportDSV("ADDITIONS", true, sT)
asmlib.ExportTypeDSV(sT)
