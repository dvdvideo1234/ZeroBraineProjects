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

SERVER = true
CLIENT = true

require("gmodlib")
require("trackasmlib")
asmlib = trackasmlib

CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetLogControl(20000, false)

local function IsValid(a) return a~=nil end 

local P = asmlib.GetBuilderNick("PIECES")
