local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local com = require("common")
dir.supCMD()
local tim = 2
local sbs, ibs = dir.getBase()
local bas = sbs.."/ZeroBraineProjects/Test"

local dsk = {  
  "C:/Users/DVD/Desktop",
  "C:/Users/ddobromirov/Desktop/Test"
}
print("----------------------------------FOLDER----------------------------------")
dir.newDir("New Folder", bas)
com.timeDelay(tim)
dir.renDir("New Folder", "x", bas)
com.timeDelay(tim)
dir.cpyDir("x", "y", bas, dsk[ibs])
com.timeDelay(tim)
dir.ersDir("x", bas)
dir.ersDir("y", dsk[ibs])
com.timeDelay(tim) -- Middle delay
print("----------------------------------FILE----------------------------------")
local f = assert(io.open((bas and bas.."/" or "").."file", "w")); f:write("\n"); f:flush(); f:close()
com.timeDelay(tim)
dir.renRec("file", "x", bas)
com.timeDelay(tim)
dir.cpyRec("x", "y", bas, dsk[ibs])
com.timeDelay(tim)
dir.ersRec("x", bas)
dir.ersRec("y", dsk[ibs])
