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
local wikilib = require("wikilib")

local sSubs = ""
local sDirs = "F:/Games/Steam/steamapps/common/GarrysMod/garrysmod/settings/presets"
local sName = "gstp"
local sUser = "mbqwertyaaa"
local sRepo = "github.com/"..sUser.."/"..sName
local sBlob = "blob/master"..sSubs; sDirs = sDirs..sSubs

-- Files description
local tSettings = 
{
  Desc =
  {
    ["Prefabs"] = "Getting a MASK to work MASK",
    ["lang"] = "Languages and translations",
    ["advdupe2"] = "Extension testing duplications",
    ["pictures"] = "Contains addon pictures",
    ["workshop"] = "Workshop related stuff",
    ["lua"] = "Contains all GLua sub-addons files",
    ["bin"] = "Keeps all binary modules as `*.dll` or `*.s` files",
    ["workshop_publish.bat"] = "Automatic workshop publisher for windows",
    ["addons"] = "Merge this internal folder with your game addons folder",
    ["gmod_wire_expression2"] = "Contains all the wire expression 2 extensions",
    ["weapons"] = "Contains all the dedicated MASK tool objects information MASK"
  },
  Swap =
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
  },
  Skip = {
   -- "%..*$"
  },
  Only = {
    --"%.mdl$"
  }
}

local sPRJ = "/ZeroBraineProjects/ExtractWireWiki"
local sB = drpath.getBase()..common.normFolder(sPRJ)
local fO, oE = io.open(sB.."out/tree.md", "wb")
if(fO) then io.output(fO)
  -- Setup flags  
  wikilib.isFlag("unqr", true)
  -- wikilib.isFlag("prnt", true)
  wikilib.isFlag("size", true)
  wikilib.isFlag("urls", true)
  wikilib.isFlag("namr", true)
  wikilib.isFlag("ufbr", true)
  wikilib.isFlag("erro", true)
  wikilib.isFlag("qref", true)
  wikilib.isFlag("hide", false)
  -- Tell the api to use file URL
  wikilib.folderReplaceURL(sDirs, sRepo, sBlob)
  -- Tell the read application we are using UTF-8 by writing a BOM
  wikilib.writeBOM("UTF8")
  -- Read structure
  local tS = wikilib.folderReadStructure(sDirs)
  common.logString("Directory: ["..sDirs.."]\n\n")
  -- common.logTable(tS, "IN")
  -- Write the tree
  if(tS and common.isTable(tS)) then
    -- common.logTable(tS, "OUT")
    wikilib.folderDrawTree(tS, 2, sRepo, tSettings)
    wikilib.printTokenReferences()
  else
    error("Table error: "..sDirs)    
  end
  io.close(fO)
else
  error("Output error: "..oE)
end
