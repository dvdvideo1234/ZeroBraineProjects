package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
local sRoot  = common.normFolder("E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects")
common.addLibrary(sRoot, "ExtractWireWiki", "dvdlualib")
local sProject = "/GmodSpawnlist"
local spawnlib = require("spawnlib")

local tSetup =
{
  {"parentid", 0},
  {"icon"    , "page"}, -- http://www.famfamfam.com/lab/icons/silk/preview.php
  {"id"      , 1},
  {"needsapp", ""},
  {"contents", {}},
  {"name"    , "Construction Props"},
  {"version" , 3}
}

local sSVN = "wire-extras"
local sB = common.normFolder(sRoot..sProject)
local sD = common.normFolder("E:/Documents/Lua-Projs/SVN/"..sSVN)
local fO, oE = io.open(sB.."out/"..sSVN:lower()..".txt", "wb")
if(fO) then io.output(fO)
  local tC, iD = tSetup[5][2], 1
  local tL = spawnlib.getModels(sD, tC)
  table.sort(tL)
  for iD = 1, tL.Size do local m = tL[iD]
    tL[iD] = spawnlib.getModel(m)
  end
  ------------------------------------------
  table.insert(tC, 5, spawnlib.getHeader("Test_header"))
  ------------------------------------------
  spawnlib.writeTable(tSetup)
  fO:flush(); fO:close()
else
  error("Output error: "..oE)
end
