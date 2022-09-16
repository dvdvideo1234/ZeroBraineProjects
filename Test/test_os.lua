local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(2)

local com = require("common")
print(drpath.supCMD(true)) 
drpath.supCMD()
local tim = 2
local bas = "C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/Test"
local dsk = "C:/Users/ddobromirov/Desktop"
print("----------------------------------FOLDER----------------------------------")
drpath.newDir("New Folder", bas)
com.timeDelay(tim)
drpath.renDir("New Folder", "x", bas)
com.timeDelay(tim)
drpath.cpyDir("x", "y", bas, dsk)
com.timeDelay(tim)
drpath.ersDir("x", bas)
drpath.ersDir("y", dsk)
com.timeDelay(tim) -- Middle delay
print("----------------------------------FILE----------------------------------")
local f = assert(io.open((bas and bas.."/" or "").."file", "w")); f:write("\n"); f:flush(); f:close()
com.timeDelay(tim)
drpath.renRec("file", "x", bas)
com.timeDelay(tim)
drpath.cpyRec("x", "y", bas, dsk)
com.timeDelay(tim)
drpath.ersRec("x", bas)
drpath.ersRec("y", dsk)
