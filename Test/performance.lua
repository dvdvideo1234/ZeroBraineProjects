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

local mtc = "*" -- Fast check

local function mat1(tab)
  local mat = tab[1]
  if(mat:sub(1,1) == mtc and mat:sub(-1,-1) == mtc) then
    return true
  end; return false
end

local function mat2(tab)
  local mat = tab[1]
  if(mat:find("%*.*%*")) then
    return true
  end; return false
end

t = testexec.New()
t:setCase(mat1, "original")
t:setCase(mat2, "modified")
t:setProgress(1, 0.1)
t:setCount(12000, 12000)
t:setCard({""}, false, "1")
t:setCard({"asdf"}, false, "2")
t:setCard({"*asdf"}, false , "3" )
t:setCard({"asdf*"}, false , "4" )
t:setCard({"*asdf*"}, true , "5" )
t:setCard({"**asdf*"}, true , "6" )
t:setCard({"*asdf**"}, true , "7" )
t:setCard({"**asdf**"}, true , "8" )

t:runMeasure()
