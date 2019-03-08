local API = {
  NAME = "MakePiece",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols links []
    qref = true   -- (TRUE) Quote the string in the link reference
  },
  POOL = {
    {name="MAKE",cols={"Instance.creator", "Out", "Description"},size={80,5,13}},
    {name="APPLY",cols={"Class.methods", "Out", "Description"},size={80,5,13}},
  },
  FILE = {
    exts = "trackasmlib_wire",
    base = "E:/Documents/Lua-Projs/SVN/TrackAssemblyTool_GIT_master/",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
    blob = "https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/",
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
  REPLACE = {
    ["MASK"] = "https://wiki.garrysmod.com/page/Enums/MASK",
    ["COLLISION_GROUP"] = "https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP",
    ["Material_surface_properties"] = "https://developer.valvesoftware.com/wiki/Material_surface_properties"
  }
}

return API
