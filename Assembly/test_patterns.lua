local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki").addBase("D:/LuaIDE").setBase(1)
                
local p = "%s*asmlib%.WorkshopID%s*"
local w = "asmlib.WorkshopID(myAddon , \"287012681\")"
print(w:find(p))
