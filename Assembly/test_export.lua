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
SERVER = false

require("gmodlib")
require("trackasmlib")
local common = require("common")
local asmlib = trackasmlib

local stringExplode = string.Explode
local stringSub   =  string.sub
local stringFind  = string.find
local stringFormat = string.format
local vguiCreate  = vgui.Create
local languageGetPhrase = language.GetPhrase
local tableInsert = table.insert

CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.ImportDSV("PIECES", true, "shinji85_s_rails")
asmlib.ImportDSV("ADDITIONS", true, "shinji85_s_rails")

asmlib.ExportTypeDSV("Bobster's two feet rails")
asmlib.ExportTypeDSV("shinji85_s_rails")
