local API = {
  NAME = "MakePiece",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols links []
    qref = true,  -- (TRUE) Quote the string in the link reference
    wdsc = true   -- (TRUE) Outputs the direct wire-based description in the markdown overhead
  },
  POOL = {
    {name="MAKE",cols={"Instance creator", "Out", "Description"},size={0,5,13}},
    {name="APPLY",cols={"Class methods", "Out", "Description"},size={70,5,13}},
    {name="SETUP",cols={"General functions", "Out", "Description"},size={70,5,13}},
  },
  FILE = {
    exts = "trackasmlib_wire",
    base = "F:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons/TrackAssemblyTool_GIT",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
    repo = "github.com/dvdvideo1234/TrackAssemblyTool",
    blob = "blob/master",
    desc = {
      ["lang"]   = "Languages and translations",
      ["trackassembly.lua"] = "Tool script",
      ["trackasmlib.lua"] = "Segment assembly library control",
      ["trackassembly_init.lua"] = "Initialization parameters and database",
      ["exp"] = "Database exports backup (Lua table)",
      ["dsv"] = "Database exports backup (DSV)",
      ["pictures"] = "Repository picture hosting and icons",
      ["workshop"] = "Workshop publish related files",
      ["expression2"] = "Neat and helpful dedicated E2s",
      ["owner-maintained"] = "List containing models supported by the addon owners",
      ["owner-discontinued"] = "List containing models discontinued by addon owners",
      ["autosave"] = "Some helpful scripts and backups",
      ["hooks"] = "Hooks for updating the version sequential number",
      ["peaces_manager"] = "Database sync manager source (C++)",
      ["todo.txt"] = "Some ideas that crossed my mind",
      ["trackasmlib_dsv.txt"] = "Example DSV load list",
      ["trackasmlib_log.txt"] = "Example logs output",
      ["trackasmlib_slskip.txt"] = "Example log settings skip list",
      ["cl_trackasmlib_wire.lua"] = "Wire E2 extension API description",
      ["trackasmlib_wire.lua"] = "Wire E2 extension API",
    }
  },
  TYPE = {
    OBJ = "e",
    FRM = "type-%s.png",
    LNK = "https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/%s"
  },
  HDESC = {
    top = "local E2Helper = {Descriptions = {}}; local language = {Add = function() return nil end}",
    bot = "return E2Helper.Descriptions",
    dsc = "E2Helper.Descriptions"
  },
  REPLACE = {
    ["MASK"] = "https://wiki.garrysmod.com/page/Enums/MASK",
    ["COLLISION_GROUP"] = "https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP",
    ["Material_surface_properties"] = "https://developer.valvesoftware.com/wiki/Material_surface_properties"
  },
  REFLN = {
    {"ref-e2-data" , "https://github.com/wiremod/wire/wiki/Expression-2#Datatypes"},
    {"ref-ta-tool" , "https://github.com/dvdvideo1234/TrackAssemblyTool"},
    {"ref-gmod", "https://en.wikipedia.org/wiki/Garry%27s_Mod"},
    {"ref-exp2", "https://github.com/wiremod/wire/wiki/Expression-2"},
    {"ref-convar", "https://developer.valvesoftware.com/wiki/ConVar"},
    {"ref-weld", "https://gmod.fandom.com/wiki/Weld_Tool"},
    {"ref-no-collide","https://gmod.fandom.com/wiki/No_Collide"}
  }
}

API.TEXT = function() return ([===[
### Description
The [`Track assembly tool`][ref-ta-tool] [`Expression 2`][ref-exp2] API is used for a wrapper of the library functions, which handle the track piece
snapping, so you can call them inside an [`E2`][ref-exp2] and thus create your own automatically generated layouts. This also can be
used when you need to implement track switchers, where you just `snap` desired track piece to the track end you wish to use.
You can then apply your desired properties, like `disable physgun` [`no-collide`][ref-no-collide] and [`weld`][ref-weld] to make
sure the piece is not going anywhere and it is not generating server collisions.
 
### Data types
This list is derived from the Wiremod types wiki [located here][ref-e2-data].
Here are all the icons for the data types of this addon summarized in the table below:

### API functions list
For every table, there is a wrapper function that reads the desired data you want:
]===]) end

return API
