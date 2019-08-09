local API = {
  NAME = "FTracer",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols links []
    qref = true,  -- (TRUE) Quote the string in the link reference
    wdsc = false,  -- (TRUE) Outouts the direct wire-based description in the markdown overhead
    mosp = true   -- (TRUE) Enables `monospace` font for the function names
  },
  POOL = {
    {name="MAKE",cols={"Instance.creator", "Out", "Description"},size={30,5,13}},
    {name="APPLY",cols={"Class.methods", "Out", "Description"},size={35,5,13}},
    {name="SETUP",cols={"General.functions", "Out", "Description"},size={20,5,13}},
  },
  FILE = {
    exts = "ftracer",
    base = "E:/Documents/Lua-Projs/SVN/ControlSystemsE2/",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom"
  },
  TYPE = {
    OBJ = "xft",
    FRM = "type-%s.png",
    LNK = "https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/%s"
  },
  REPLACE = {
    ["MASK"] = "https://wiki.garrysmod.com/page/Enums/MASK",
    ["COLLISION_GROUP"] = "https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP",
    ["Material_surface_properties"] = "https://developer.valvesoftware.com/wiki/Material_surface_properties",
    ["trace-line"] = "https://wiki.garrysmod.com/page/util/TraceLine",
    ["trace"] = "https://wiki.garrysmod.com/page/Structures/Trace",
    ["trace-result"] = "https://wiki.garrysmod.com/page/Structures/TraceResult"
  }
}

return API
