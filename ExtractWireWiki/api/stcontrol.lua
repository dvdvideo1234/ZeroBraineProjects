local API = {
  NAME = "StControl",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols links []
    qref = true,  -- (TRUE) Quote the string in the link reference
    wdsc = false, -- (TRUE) Outputs the direct wire-based description in the markdown overhead
    mosp = true   -- (TRUE) Enables monospace font for the function names
  },
  POOL = {
    {name="MAKE",cols={"Instance creator", "Out", "Description"},size={20,5,13}},
    {name="APPLY",cols={"Class methods", "Out", "Description"},size={35,5,13}},
    {name="SETUP",cols={"General functions", "Out", "Description"},size={20,5,13}}
  },
  FILE = {
    exts = "stcontrol",
    base = "E:/Documents/Lua-Projs/SVN/wire-extras",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
    cvar = "wire_expression2_stcontrol"
  },
  TYPE = {
    OBJ = "xsc",
    FRM = "type-%s.png",
    LNK = "https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/%s"
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
  }
}

local ref_example = "https://github.com/dvdvideo1234/ControlSystemsE2/blob/master/data/Expression2/e2_code_test_stcontrol.txt"

local tConvar = {
  {"enst", "Contains flag that enables status output messages"},
  {"dprn", "Stores the default status output messages streaming destination"}
}

local function getConvar()
  local sC, iC = "", 1
  while(tConvar[iC]) do
    local tC = tConvar[iC]
    sC = sC..API.FILE.cvar.."_"
           ..("%-4s"):format(tostring(tC[1] or "x"))
           .." > "..tostring(tC[2] or "").."\n"
    iC = iC + 1
  end; return sC
end

API.TEXT = function() return([===[
### What is this thing designed for?
The `%s` class consists of fast performing controller object-oriented
instance that is designed to be `@persist`and initialized in expression
`first() || dupefinished()`. That way you create the controller instance once
and you can use it as many times as you need, without creating a new one.

### What console variables can be used to setup it
```
]===]..getConvar()..[===[
```

### How to create an instance then?
You can create a controller object by calling one of the dedicated creators `new%s` below 
either with an argument of sampling time to make the sampling time static or without
a parameter to make it take the value dynamically as some other thing may slow down the E2.
Then you must activate the instance `setIsActive(1)` to enable it to calculate the control signal,
apply the current state values `setState` and retrieve the control signal afterwards by calling
`getControl(...)`.

### Do you have an example by any chance?
The internal type of the class is `%s` and internal expression type `%s`, so to create 
an instance you can take a [look at the example](%s).

### Can you show me the methods of the class?
The description of the API is provided in the table below.
]===]):format(API.NAME,API.NAME,API.TYPE.OBJ,API.FILE.exts,ref_example)
end

return API
