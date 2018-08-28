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
    {name="APPLY",cols={"Entity.wiremod.extensions", "Out", "Description"},size={20,5,13}},
  },
  FILE = {
    exts = "wire_e2_piston_timing",
    base = "E:/Documents/Lua-Projs/SVN/E2PistonTiming/",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom"
  },
  TYPE = {
    OBJ = "e",
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
