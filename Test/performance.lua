local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(1)

require("dvdlualib/gmodlib")
local testexec = require("testexec")

function GetEmpty1(tArg)
  return tArg[1]:len()
end

function GetEmpty2(tArg)
  return #tArg[1]
end

t = testexec.New()
t:setCase(GetEmpty1, "original")
t:setCase(GetEmpty2, "modify")
t:setProgress(1, 0.1)
t:setCount(100000, 100000)
t:setCard({""}, 0, "1 ")
t:setCard({"a"}, 1, "2 ")
t:setCard({"ab"}, 2, "3 ")
t:setCard({"abc"}, 3, "4 ")
t:runMeasure()
