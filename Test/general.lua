local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

local common  = require('common')

ErrorNoHalt = print
gsToolName = "TEST"
gtLang = {["S"] = 55}

local function getPhrase(sK)
  local sK = tostring(sK) if(not gtLang[sK]) then
    ErrorNoHalt(gsToolName..": getPhrase("..sK.."): Missing")
    return "Oops, missing ?" -- Return some default translation
  end; return gtLang[sK]
end

print(table.concat({1,2,3,4,[10]=5}))
