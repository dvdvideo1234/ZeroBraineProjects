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
require("Assembly/scripts/sligwolf_s_suspension_train")

print("-----------")
print(asmlib.GetReport())
print(asmlib.GetReport(1234))
print(asmlib.GetReport("asdf"))
print(asmlib.GetReport(1,2,"c", nil, "ASDF"))








