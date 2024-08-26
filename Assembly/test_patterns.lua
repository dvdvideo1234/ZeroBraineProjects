local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki").addBase("D:/Programs/LuaIDE").setBase(1)
                
local p = "[fp][ur][no][%w]+%s+[%w_]+%s*%(.-%)"
local w = "function istargetcolumnname(vctable in varchar2, vcname in varchar2) return boolean;"
print(w:find(p))
