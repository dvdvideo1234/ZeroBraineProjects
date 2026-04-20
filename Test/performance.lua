local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("dvdlualib/gmodlib")
require("dvdlualib/trackasmlib")
local testexec = require("testexec")

local cat = {}

function dotdot(a,b,c,d)
  return a.."|"..b.."|"..c.."|"..d
end

function formats(a,b,c,d)
  return ("%s|%s|%s|%s"):format(a,b,c,d)
end

function formati(a,b,c,d)
  return ("%d|%d|%d|%d"):format(a,b,c,d)
end

function concat(a,b,c,d)
  cat[1], cat[2] = a, "|"
  cat[3], cat[4] = b, "|"
  cat[5], cat[6] = c, "|"
  cat[7] = d
  return table.concat(cat)
end

t = testexec.New()
t:setCase(dotdot, "dotdot")
t:setCase(formats, "formats")
t:setCase(formati, "formati")
t:setCase(concat, "concat")
t:setProgress(1, 0.1)
t:setCount(1000, 10000)
t:setCard("cat", {1,2,3,4}, "1|2|3|4")
t:runMeasure()
