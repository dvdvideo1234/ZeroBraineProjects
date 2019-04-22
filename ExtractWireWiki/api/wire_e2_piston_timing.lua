local API = {
  NAME = "MakePiece",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols or all-upper
    qref = true,  -- (TRUE) Quote the string in the link reference
    prep = true  -- (TRUE) Replace key in the link pattern in the replace table. Call formatting   
  },
  POOL = {
    {name="MAKE",cols={"Instance creator", "Out", "Description"},size={80,5,13}},
    {name="APPLY",cols={"Entity wiremod extensions", "Out", "Description"},size={35,5,13}}
  },
  FILE = {
    exts = "wire_e2_piston_timing",
    base = "E:/Documents/Lua-Projs/SVN/E2PistonTiming",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom"
  },
  TYPE = {
    OBJ = "e",
    FRM = "type-%s.png",
    LNK = "https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/%s"
  },
  REPLACE = {
    ["MASK"] = "https://wiki.garrysmod.com/page/Enums/MASK",
    ["COLLISION_GROUP"] = "https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP",
    ["Material_surface_properties"] = "https://developer.valvesoftware.com/wiki/Material_surface_properties",
    ["sign"] = "https://en.wikipedia.org/wiki/Sign_function",
    ["wave"] = "https://en.wikipedia.org/wiki/Sine",
    ["triangular"] = "https://en.wikipedia.org/wiki/Triangle_wave",
    ["cross-product"] = "https://en.wikipedia.org/wiki/Cross_product",
    ["ramp"] = "https://en.wikipedia.org/wiki/Ramp_function",
    ["local-axis"] = "https://en.wikipedia.org/wiki/Cartesian_coordinate_system"
  }
}

return API
