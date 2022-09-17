local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/LuaIDE")
      dir.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(1)

local com = require("common")
print(dir.supCMD(true)) 
dir.supCMD()
local tim = 2
local bas = dir.getBase().."/ZeroBraineProjects/Test"
local dsk = "C:/Users/DVD/Desktop"
print("----------------------------------FOLDER----------------------------------")
dir.newDir("New Folder", bas)
com.timeDelay(tim)
dir.renDir("New Folder", "x", bas)
com.timeDelay(tim)
dir.cpyDir("x", "y", bas, dsk)
com.timeDelay(tim)
dir.ersDir("x", bas)
dir.ersDir("y", dsk)
com.timeDelay(tim) -- Middle delay
print("----------------------------------FILE----------------------------------")
local f = assert(io.open((bas and bas.."/" or "").."file", "w")); f:write("\n"); f:flush(); f:close()
com.timeDelay(tim)
dir.renRec("file", "x", bas)
com.timeDelay(tim)
dir.cpyRec("x", "y", bas, dsk)
com.timeDelay(tim)
dir.ersRec("x", bas)
dir.ersRec("y", dsk)
