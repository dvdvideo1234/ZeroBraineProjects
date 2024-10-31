local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
require("gmodlib")

local p = "[fp][ur][no][%w]+%s+[%w_]+%s*%(.-%)"
local w = "function istargetcolumnname(vctable in varchar2, vcname in varchar2) return boolean;"
print(w:find(p))

local a = "# ExportCategory:(3@cl_) 24-10-30 22:25:29 [ LUA ]"
local p = a:match("^#.*ExportCategory.*%(.+%)")
      p = p:match("%(.+@.+%)"):Trim():sub(2, -2):Trim()

print(p)