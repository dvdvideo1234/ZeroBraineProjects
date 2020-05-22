local drpath = require("directories")
local common = require("common")
local wikilib = require("wikilib")

local sRepo = "github.com/dvdvideo1234/PhysPropertiesAdv"
local sBlob = "blob/master"

-- Files description
local tDesc =
{
  ["lang"] = "Languages and translations",
  ["advdupe2"] = "Extension testing duplications",
  ["pictures"] = "Contains addon pictures",
  ["workshop"] = "Workshop related crap",
  ["lua"] = "Contains all GLua woremod sub-addons",
  ["workshop_publish.bat"] = "Automatic workshop publisher for windows"
}

-- Direct word replacement inside the tree
local tSwap =
{
  ["MASK"] = "https://wiki.garrysmod.com/page/Enums/MASK",
  ["COLLISION_GROUP"] = "https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP",
  ["Material_surface_properties"] = "https://developer.valvesoftware.com/wiki/Material_surface_properties",
  ["trace-line"] = "https://wiki.garrysmod.com/page/util/TraceLine",
  ["trace-strict"] = "https://wiki.garrysmod.com/page/Structures/Trace",
  ["trace-result"] = "https://wiki.garrysmod.com/page/Structures/TraceResult",
  ["FTrace"] = "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FTrace",
  ["bitmask"] = "https://en.wikipedia.org/wiki/Mask_(computing)",
  ["SURF"] = "https://wiki.facepunch.com/gmod/Enums/SURF",
  ["DISPSURF"] = "https://wiki.facepunch.com/gmod/Enums/DISPSURF",
  ["CONTENTS"] = "https://wiki.facepunch.com/gmod/Enums/CONTENTS",
  ["StControl"] = "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl"
}

local sPRJ = "/ZeroBraineProjects/ExtractWireWiki"
local sB = drpath.getBase()..common.normFolder(sPRJ)
local fO, oE = io.open(sB.."out/tree.md", "wb")
local sD = "F:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons/PhysPropertiesAdv"
if(fO) then io.output(fO)
  -- Setup flags
  -- wikilib.folderFlag("prnt", true)
  wikilib.folderFlag("size", true)
  wikilib.folderFlag("urls", true)
  wikilib.folderFlag("namr", true)
  wikilib.folderFlag("ufbr", true)
  -- Tell the api to use file URL
  wikilib.folderReplaceURL(sD, sRepo, sBlob)
  -- Tell the read application we are using UTF-8 by writing a BOM
  wikilib.writeBOM("UTF8")
  -- Read structure
  local tS = wikilib.folderReadStructure(sD)
  -- common.logString("Directory: ["..sD.."]\n")
  -- common.logTable(tS, "DIR")
  -- Write the tree
  if(tS and common.isTable(tS)) then
    wikilib.folderDrawTree(tS, 2, sRepo, tDesc, tSwap)
    wikilib.folderDrawTreeRef()
  else
    
  end
else
  print("API:", API)
  error("Output error: "..oE)
end
