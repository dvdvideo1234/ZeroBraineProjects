local API = {
  NAME = "StControl",
  SETS = {
    icon = false, -- Use icons for arguments
    erro = true,  -- Generate an error on dupe of no docs
    extr = true,  -- Use the external wire types
    remv = false  -- Replace void type with empty string
  },
  POOL = {
    {name="MAKE",cols={"Instance.creator", "Out", "Description"},size={50,5,13}},
    {name="APPLY",cols={"Class.methods", "Out", "Description"},size={50,5,13}},
  },
  FILE = {
    base = "E:/Documents/Lua-Projs/SVN/ControlSystemsE2/",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom"
  },
  TYPE = {
    E2 = "stcontrol",
    OBJ = "xsc",
    LNK = "https://raw.githubusercontent.com/dvdvideo1234/ControlSystemsE2/master/data/pictures/types/%s"
  },

  REPLACE = {
    __key = "###", -- The key tells what patternis to be raplaced
    ["MASK"] = "[###](https://wiki.garrysmod.com/page/Enums/###)",
    ["COLLISION_GROUP"] = "[COLLISION_GROUP](https://wiki.garrysmod.com/page/Enums/###)"
  }
}

return API
