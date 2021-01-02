local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

local com = require("common")
local cpx = require("complex")
local tableRemove = table and table.remove

local function foo(iC, ...)
  local tA, tO = {...}, {Size = iC}
  for iD = 1, iC do
    tO[iD] = tA[iD]
  end
  return tO
end

local tB = foo(4, 1,nil,3)

for iD = 1, tB.Size do
  print(iD, tB[iD])
end

