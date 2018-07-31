local API = {
  NAME = "propSpawn", -- Class creator factory name ( if available )
  SETS = {
    icon = false, -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = true,  -- (TRUE) Use the external wiremod types
    remv = true,  -- (TRUE) Replace void type with empty string
    quot = true   -- (TRUE) Place backticks on words containing control symbols links []
  },
  POOL = {
    {name="MAKE",cols={"Instance.creator", "Out", "Description"},size={34,5,13}},
    {name="APPLY",cols={"Prop.core.function", "Out", "Description"},size={46,5,13}},
  },
  FILE = {
    exts = "prop",                             -- Extension source file
    base = "E:/Documents/Lua-Projs/SVN/Wire/", -- Repository base folder
    path = "data/wiki",                        -- Direct function return refinition
    slua = "lua/entities/gmod_wire_expression2/core/custom/" -- Repository source file subfolder
  },
  TYPE = {
    OBJ = "", -- Here stays the internal type of the class for the generated API documentation
    -- API type images format for the arguments if replacement by images is enabled
    LNK = "https://raw.githubusercontent.com/wiki/wiremod/wire/%s" 
  },
  REPLACE = {
    __key = "_###_", -- The key tells what patternis to be raplaced
    __ref = "_@@@_",
    ["MASK"] = "[_@@@_](https://wiki.garrysmod.com/page/Enums/_###_)",
    ["COLLISION_GROUP"] = "[_@@@_](https://wiki.garrysmod.com/page/Enums/_###_)",
    ["Material_surface_properties"] = "[_@@@_](https://developer.valvesoftware.com/wiki/_###_)"
  }
}

return API
