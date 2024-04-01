local drpath = require("directories")
      drpath.addPath("myprograms",
                     "CorporateProjects",
                     "ZeroBraineProjects",
                     -- When not located in general directory search in projects
                     "ZeroBraineProjects/dvdlualib",
                     "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local common = require("common")

SERVER = true
CLIENT = true

require("gmodlib")
require("trackasmlib")
asmlib = trackasmlib

CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetOpVar("DIRPATH_BAS", drpath.getBase(2).."/ZeroBraineProjects/Assembly/trackassembly/")
asmlib.SetLogControl(1000,false)

PIECES = asmlib.GetBuilderNick("PIECES")
--require("Assembly/data/pieces")

local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gsDataRoot  = asmlib.GetOpVar("DIRPATH_BAS")
local gsDataSet   = asmlib.GetOpVar("DIRPATH_SET")

---------------------------------------------------------------------------------------

if(not asmlib.ProcessDSV()) then -- Default tab delimiter
  local sDSV = gsDataRoot..gsDataSet..gsLibName.."_dsv.txt"
  asmlib.LogInstance("Processing DSV fail <"..sDSV..">")
end
