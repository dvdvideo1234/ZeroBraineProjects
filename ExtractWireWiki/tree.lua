local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)
      
local common = require("common")
local wikilib = require("wikilib")

local sDirs = "K:/gstp"
local sName = "gstp"
local sUser = "mbqwertyaaa"
local sRepo = "github.com/"..sUser.."/"..sName
local sBlob = "blob/master"

-- Files description
local tDesc =
{
  ["lang"] = "Languages and translations",
  ["advdupe2"] = "Extension testing duplications",
  ["pictures"] = "Contains addon pictures",
  ["workshop"] = "Workshop related stuff",
  ["lua"] = "Contains all GLua sub-addons files",
  ["bin"] = "Keeps all binary modules as `*.dll` or `*.s` files",
  ["workshop_publish.bat"] = "Automatic workshop publisher for windows",
  ["addons"] = "Merge this internal folder with your game addons folder",
  ["gmod_wire_expression2"] = "Contains all the wire expression 2 extensions",
  ["weapons"] = "Contains all the dedicated tool objects information"
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
if(fO) then io.output(fO)
  -- Setup flags
  -- wikilib.folderFlag("prnt", true)
  wikilib.folderFlag("size", true)
  wikilib.folderFlag("urls", true)
  wikilib.folderFlag("namr", true)
  wikilib.folderFlag("ufbr", true)
  -- Tell the api to use file URL
  wikilib.folderReplaceURL(sDirs, sRepo, sBlob)
  -- Tell the read application we are using UTF-8 by writing a BOM
  wikilib.writeBOM("UTF8")
  -- Read structure
  local tS = wikilib.folderReadStructure(sDirs)
  -- common.logString("Directory: ["..sDirs.."]\n")
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
