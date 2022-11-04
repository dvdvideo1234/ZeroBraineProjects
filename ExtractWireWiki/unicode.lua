local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(1)

local common = require("common")

local iEnd = 65535

local fID = "%"..tostring(iEnd):len().."d"
local fHE = "%06x"
local sPRJ = "/ZeroBraineProjects/ExtractWireWiki"
local sB = drpath.getBase()..common.normFolder(sPRJ)
local fO, oE = io.open(sB.."out/uc.md", "wb")
if(fO) then io.output(fO)
  for iD = 0, iEnd do
    io.write(fID:format(iD))
    io.write(":")
    io.write(fHE:format(iD))
    io.write("<")
    
    io.write(">")
    io.write("\n")
  end
  print(bit.band(63903,2448))
  io.close(fO)
else
  error("Output error: "..oE)
end