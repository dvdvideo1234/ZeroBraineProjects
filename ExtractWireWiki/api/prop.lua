local API = {
  NAME = "Spawn", -- Class creator factory name ( if available )
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = true,  -- (TRUE) Use the external wiremod types
    remv = true,  -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols and links []
    qref = true,  -- (TRUE) Quote the string in the link reference
    wdsc = false, -- (TRUE) Outputs the direct wire-based description in the markdown overhead
    mosp = true,  -- (TRUE) Enables monospace font for the function names
    prep = false  -- (TRUE) Replace key in the link pattern in the replace table. Call formatting   
  },
  POOL = {
    {name="MAKE",cols={"Instance creator", "Out", "Description"},size={34,5,13}},
    {name="APPLY",cols={"Prop core method", "Out", "Description"},size={46,5,13}},
    {name="SETUP",cols={"General functions", "Out", "Description"},size={34,5,13}}
  },
  FILE = {
    exts = "prop",                             -- Extension source file
    base = "E:/Documents/Lua-Projs/SVN/Wire/", -- Repository base folder
    path = "data/wiki",                        -- Direct function return refinition
    slua = "lua/entities/gmod_wire_expression2/core/custom/", -- Repository source file subfolder
    repo = "github.com/wiremod/wire",
    blob = "blob/master"
  },
  TYPE = {
    OBJ = "e", -- Here stays the internal type of the class for the generated API documentation
    FRM = "Type-%s.png", -- Format of the dedicated type from the project
    -- API type images format for the arguments if replacement by images is enabled
    LNK = "https://raw.githubusercontent.com/wiki/wiremod/wire/%s",
    -- The prefixes list for the name to identify the function as OOP creator
    DSG = {"prop", "seat"}
  },
  REPLACE = {
    ["MASK"] = "https://wiki.garrysmod.com/page/Enums/MASK",
    ["COLLISION_GROUP"] = "https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP",
    ["Material_surface_properties"] = "https://developer.valvesoftware.com/wiki/Material_surface_properties"
  },
  HDESC = {
    top = "local E2Helper = {Descriptions = {}}; local language = {Add = function() return nil end}",
    bot = "return E2Helper.Descriptions",
    dsc = "E2Helper.Descriptions"
  },
  REFLN = {
    {"ref-prp-typ", "https://developer.valvesoftware.com/wiki/Prop_Types_Overview"},
    {"ref-e2-data", "https://github.com/wiremod/wire/wiki/Expression-2#Datatypes"},
    {"ref-gmod", "https://en.wikipedia.org/wiki/Garry%27s_Mod"},
    {"ref-exp2", "https://github.com/wiremod/wire/wiki/Expression-2"},
    {"ref-convar", "https://developer.valvesoftware.com/wiki/ConVar"}
  }
}

local tConvar = {
  {"sbox_E2_maxProps         ", "Controls the maximum amount of props spawned via E2 set this to `-1` to disable the limit."},
  {"sbox_E2_maxPropsPerSecond", "Controls the maximum amount of props spawned for one second. Don't set this too high!  "},
  {"sbox_E2_PropCore         ",
    {
      descr = "Controls enable/disable of the extension. Setup values are written below.",
      {0, "The extension is disabled."},
      {1, "Only admins can use the extension."},
      {2, "Players can affect their own props."}
    }
  },
}

local function getConvar()
  local sC, iC = "", 1
  while(tConvar[iC]) do
    local tvC = tConvar[iC]
    local tyC = type(tvC[2])
    if(tyC == "table") then local tV = tvC[2]
      sC = sC..tostring(tvC[1]).." : "..tostring(tV.descr).."\n"
      for k, v in ipairs(tV) do
        sC = sC.."  "..tostring(v[1]).." : "..tostring(v[2]).."\n"
      end
    else
      sC = sC..tostring(tvC[1]).." : "..tostring(tvC[2]).."\n"
    end
    iC = iC + 1
  end; return sC
end

API.TEXT = function() return ([===[
### Description
The prop core functionality is used generally for manipulating [props][ref-prp-typ] using an E2 script within [Garry's mod][ref-gmod]
environment. Manipulation type can be anything like creating, deleting, teleporting, angling, gravity, inertia, buoyancy
and much more. The data types are general for the [E2][ref-exp2] chip and you can [find them here][ref-e2-data]!
 
### What [console variables][ref-convar] can be used to setup it
```
]===]..getConvar()..[===[
```

### Expression 2 API
All the function descriptions are available in the table below:
]===]):format() end

return API
