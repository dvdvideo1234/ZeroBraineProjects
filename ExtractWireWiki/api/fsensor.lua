local API = {
  NAME = "FSensor",
  FLAG = {
    icon = false, -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true   -- (TRUE) Place backticks on words containing control symbols links []
  },
  POOL = {
    {name="MAKE",cols={"Instance.creator", "Out", "Description"},size={50,5,13}},
    {name="APPLY",cols={"Class.methods", "Out", "Description"},size={50,5,13}},
  },
  FILE = {
    exts = "fsensor",
    base = "E:/Documents/Lua-Projs/SVN/ControlSystemsE2/",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom"
  },
  TYPE = {
    OBJ = "xfs",
    FRM = "type-%s.png",
    LNK = "https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/%s"
  },
  REPLACE = {
    __key = "aaaaaaaaaa", -- The key tells what patternis to be raplaced
    __ref = "bbbbbbbbbb",
    ["MASK"] = "[bbbbbbbbbb](https://wiki.garrysmod.com/page/Enums/aaaaaaaaaa)",
    ["COLLISION_GROUP"] = "[bbbbbbbbbb](https://wiki.garrysmod.com/page/Enums/aaaaaaaaaa)",
    ["Material_surface_properties"] = "[bbbbbbbbbb](https://developer.valvesoftware.com/wiki/aaaaaaaaaa)"
  }
}

return API
