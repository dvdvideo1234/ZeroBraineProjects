local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("dvdlualib/gmodlib")
local testexec = require("testexec")

function GetEmpty1(sBas, fEmp, iCnt, ...)
  local tV = {...}
  local iC = math.floor(tonumber(iCnt) or 0)
  return iC
end

function GetEmpty2(sBas, fEmp, iCnt, ...)
  local tV = {...}
  local iC = select("#", ...)
  return iC
end
t = testexec.New()
t:setCase(GetEmpty1, "original")
t:setCase(GetEmpty2, "modified")
t:setProgress(1, 0.1)
t:setCount(12000, 12000)
t:setCard({nil, nil, 3, 1, 2, 3}, 3, "0")
t:setCard({nil, nil, 3, nil, 2, 3}, 3, "1")
t:setCard({nil, nil, 3, 1, nil, 3}, 3, "2")
t:setCard({nil, nil, 3, 1, 2, nil}, 3, "3")
t:setCard({nil, nil, 3, nil, nil, 3}, 3, "1")
t:setCard({nil, nil, 3, 1, nil, nil}, 3, "2")
t:setCard({nil, nil, 3, nil, 2, nil}, 3, "3")
t:setCard({nil, nil, 3, nil, nil, nil}, 3, "3")
t:runMeasure()
