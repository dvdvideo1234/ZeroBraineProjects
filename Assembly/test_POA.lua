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

local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gsDataRoot  = asmlib.GetOpVar("DIRPATH_BAS")
local gsDataSet   = asmlib.GetOpVar("DIRPATH_SET")

---------------------------------------------------------------------------------------

if(not asmlib.ProcessDSV()) then -- Default tab delimiter
  local sDSV = gsDataRoot..gsDataSet..gsLibName.."_dsv.txt"
  asmlib.LogInstance("Processing DSV fail <"..sDSV..">")
end

local oRec = asmlib.CacheQueryPiece("models/props_lab/blastdoor001b.mdl")
if (not oRec) then asmlib.LogInstance("Unable to load model"); return end

common.logTable(oRec, 'oRec')

asmlib.LocatePOA(oRec, 1)

for i = 1, oRec.Size do
  local tPOA = oRec.Offs[i]
  local sP = asmlib.StringPOA(tPOA.P, "V")
  local sO = asmlib.StringPOA(tPOA.O, "V")
  local sA = asmlib.StringPOA(tPOA.A, "A")
  print(sP, sO, sA)
end


