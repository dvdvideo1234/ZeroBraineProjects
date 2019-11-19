local API = {
  NAME = "FTrace",
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
    {name="MAKE",cols={"Instance creator", "Out", "Description"},size={32,5,13}},
    {name="APPLY",cols={"Class methods", "Out", "Description"},size={35,5,13}},
    {name="SETUP",cols={"General functions", "Out", "Description"},size={20,5,13}}
  },
  FILE = {
    exts = "ftrace",
    base = "E:/Documents/Lua-Projs/SVN/wire-extras",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
    cvar = "wire_expression2_ftrace",
    repo = "github.com/dvdvideo1234/ControlSystemsE2",
    blob = "blob/master",
    desc = {
      ["lang"]   = "Languages and translations",
      ["e2_code_test_ftrace.txt"] = "Tracer class example",
      ["e2_code_test_stcontrol.txt"] = "Controller class example",
      ["stcontrol_dump.txt"] = "Controller class dump string",
      ["pictures"] = "Contains addon pictures",
      ["workshop"] = "Workshop related crap",
      ["lua"] = "Contains all GLua woremod sub-addons",
      ["cl_ftrace.lua"] = "FTrace class API description",
      ["cl_stcontrol.lua"] = "FTrace class API description",
      ["ftrace.lua"] = "StControl class API implementation",
      ["stcontrol.lua"] = "StControl class API implementation",
      ["workshop_publish.bat"] = "Automatic workshop publisher for windows"
    }
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
    ["trace-strict"] = "https://wiki.garrysmod.com/page/Structures/Trace",
    ["trace-result"] = "https://wiki.garrysmod.com/page/Structures/TraceResult",
    ["FTrace"] = "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FTrace",
    ["StControl"] = "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl"
  },
  HDESC = {
    top = "local E2Helper = {Descriptions = {}}; local language = {Add = function() return nil end}",
    bot = "return E2Helper.Descriptions",
    dsc = "E2Helper.Descriptions"
  },
  REFLN = {
    {"ref_example", "https://github.com/dvdvideo1234/ControlSystemsE2/blob/master/data/Expression2/e2_code_test_ftrace.txt"},
  }
}

local tConvar = {
  {"skip", "Contains trace generator blacklisted methods ( ex. `GetSkin`/`GetModel`/`IsVehicle` )"},
  {"only", "Contains trace generator whitelisted methods ( ex. `GetSkin`/`GetModel`/`IsVehicle` )"},
  {"dprn", "Stores the default status output messages streaming destination"},
  {"enst", "Contains flag that enables status output messages"}
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

API.TEXT = function() return ([===[
### What is this thing designed for?
The `%s` class consists of fast performing traces object-oriented
instance that is designed to be `@persist`and initialized in expression
`first() || dupefinished()`. That way you create the tracer instance once
and you can use it as many times as you need, without creating a new one.

### What console variables can be used to setup it?
```
]===]..getConvar()..[===[
```

### How to create an instance then?
You can create a local trace object by attaching it to a base entity. When sampled
locally, it will use this attachment entity to orient its direction and length in pure Lua.
You can also call the class constructor without an entity to make it world-space based.
Remember that negating the trace length will result in negating the trace direction.
That is used because the trace length must always be positive so the direction is reversed instead.

### Do you have an example by any chance?
The internal type of the class is `%s` and internal expression type `%s`, so to create 
a tracer instance you can take a [look at the example][ref_example].

### Can you show me the methods of the class?
The description of the API is provided in the table below.
]===]):format(API.NAME, API.TYPE.OBJ, API.FILE.exts)
end

return API
