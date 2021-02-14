local API = {
  NAME = "FTrace",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols links []
    qref = true,  -- (TRUE) Quote the string in the link reference
    -- wdsc = true,  -- (TRUE) Outputs the direct wire-based description in the markdown overhead
    mosp = true,  -- (TRUE) Enables monospace font for the function names
    ufbr = true,  -- (TRUE) Enables reference links generation  when processing tokens
    prep = false  -- (TRUE) Replace key in the link pattern in the replace table. Call formatting
  },
  POOL = {
    {name="MAKE" ,cols={"Instance creator" , "Out", "Description"},size={32,5,13},algn={"<","|","<"}},
    {name="APPLY",cols={"Class methods"    , "Out", "Description"},size={35,5,13},algn={"<","|","<"}},
    {name="SETUP",cols={"General functions", "Out", "Description"},size={25,5,13},algn={"<","|","<"}}
  },
  FILE = {
    exts = "ftrace",
    base = "F:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons/ControlSystemsE2", -- ControlSystemsE2, wire-extras
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
    cvar = "wire_expression2_ftrace",
    repo = "github.com/dvdvideo1234/ControlSystemsE2",
    blob = "blob/master",
    desc = {
      ["lang"] = "Languages and translations",
      ["advdupe2"] = "Extension testing duplications",
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
    ["position"]        = "https://en.wikipedia.org/wiki/Position_(geometry)",
    ["positions"]       = "https://en.wikipedia.org/wiki/Position_(geometry)",
    ["distance"]        = "https://en.wikipedia.org/wiki/Euclidean_distance",
    ["distances"]       = "https://en.wikipedia.org/wiki/Euclidean_distance",
    ["length"]          = "https://en.wikipedia.org/wiki/Euclidean_distance",
    ["lengths"]         = "https://en.wikipedia.org/wiki/Euclidean_distance",
    ["magnitude"]       = "https://en.wikipedia.org/wiki/Euclidean_distance",
    ["magnitudes"]      = "https://en.wikipedia.org/wiki/Euclidean_distance",
    ["number"]          = "https://en.wikipedia.org/wiki/Euclidean_distance",
    ["numbers"]         = "https://en.wikipedia.org/wiki/Euclidean_distance",
    ["angle"]           = "https://en.wikipedia.org/wiki/Euler_angles",
    ["angles"]          = "https://en.wikipedia.org/wiki/Euler_angles",
    ["vector"]          = "https://en.wikipedia.org/wiki/Euclidean_vector",
    ["vectors"]         = "https://en.wikipedia.org/wiki/Euclidean_vector",
    ["direction"]       = "https://en.wikipedia.org/wiki/Unit_vector",
    ["directions"]      = "https://en.wikipedia.org/wiki/Unit_vector",
    ["array"]           = "https://en.wikipedia.org/wiki/Array_data_type",
    ["arrays"]          = "https://en.wikipedia.org/wiki/Array_data_type",
    ["function"]        = "https://en.wikipedia.org/wiki/Subroutine",
    ["functions"]       = "https://en.wikipedia.org/wiki/Subroutine",
    ["string"]          = "https://en.wikipedia.org/wiki/String_(computer_science)",
    ["strings"]         = "https://en.wikipedia.org/wiki/String_(computer_science)",  
    ["entity"]          = "https://wiki.facepunch.com/gmod/Entity",
    ["entities"]        = "https://wiki.facepunch.com/gmod/Entity",
    ["MASK"]            = "https://wiki.facepunch.com/gmod/Enums/MASK",
    ["COLLISION_GROUP"] = "https://wiki.facepunch.com/gmod/Enums/COLLISION_GROUP",
    ["trace"]           = "https://wiki.facepunch.com/gmod/util.TraceLine",
    ["trace-line"]      = "https://wiki.facepunch.com/gmod/util.TraceLine",
    ["trace-strict"]    = "https://wiki.facepunch.com/gmod/Structures/Trace",
    ["trace-result"]    = "https://wiki.facepunch.com/gmod/Structures/TraceResult",
    ["SURF"]            = "https://wiki.facepunch.com/gmod/Enums/SURF",
    ["DISPSURF"]        = "https://wiki.facepunch.com/gmod/Enums/DISPSURF",
    ["CONTENTS"]        = "https://wiki.facepunch.com/gmod/Enums/CONTENTS",
    ["FTrace"]          = "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FTrace",
    ["StControl"]       = "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl",
    ["bitmask"]         = "https://en.wikipedia.org/wiki/Mask_(computing)",
    ["mask"]            = "https://en.wikipedia.org/wiki/Mask_(computing)",
    ["masks"]           = "https://en.wikipedia.org/wiki/Mask_(computing)",
    ["enum"]            = "https://en.wikipedia.org/wiki/Enumerated_type",
    ["enums"]           = "https://en.wikipedia.org/wiki/Enumerated_type", 
    ["surface"]         = "https://developer.valvesoftware.com/wiki/Material_surface_properties",
    ["surfaces"]        = "https://developer.valvesoftware.com/wiki/Material_surface_properties"
  },
  HDESC = {
    top = "local E2Helper = {Descriptions = {}}; local language = {Add = function() return nil end}",
    bot = "return E2Helper.Descriptions",
    dsc = "E2Helper.Descriptions"
  },
  REFLN = {
    {"ref_localcrd" , "https://en.wikipedia.org/wiki/Local_coordinates"},
    {"ref_position" , "https://en.wikipedia.org/wiki/Position_(geometry)"},
    {"ref_class_oop", "https://en.wikipedia.org/wiki/Class_(computer_programming)"},
    {"ref_class_con", "https://en.wikipedia.org/wiki/Constructor_(object-oriented_programming)"},
    {"ref_orient"   , "https://en.wikipedia.org/wiki/Orientation_(geometry)"},
    {"ref_vec_norm" , "https://en.wikipedia.org/wiki/Euclidean_vector#Length"},
    {"ref_lua"      , "https://en.wikipedia.org/wiki/Lua_(programming_language)"},
    {"ref_oopinst"  , "https://en.wikipedia.org/wiki/Instance_(computer_science)"},
    {"ref_ray"      , "https://en.wikipedia.org/wiki/Line_(geometry)#Ray"},
    {"ref-func"     , "https://en.wikipedia.org/wiki/Subroutine"},
    {"ref-gmod"     , "https://wiki.facepunch.com/gmod/"},
    {"ref_trace-dt" , "https://wiki.facepunch.com/gmod/Structures/Trace"},
    {"ref_trace-rz" , "https://wiki.facepunch.com/gmod/Structures/TraceResult"},
    {"ref_entity"   , "https://wiki.facepunch.com/gmod/Entity"},
    {"ref_example"  , "https://github.com/dvdvideo1234/ControlSystemsE2/blob/master/data/Expression2/e2_code_test_ftrace.txt"},
    {"ref_exp2"     , "https://github.com/wiremod/wire/wiki/Expression-2"},
    {"ref_wranger"  , "https://github.com/wiremod/wire/wiki/Expression-2#built-in-ranger"},
    {"ref_perfe2"   , "https://github.com/wiremod/wire/wiki/Expression-2#performance"},
    {"ref_timere2"  , "https://github.com/wiremod/wire/wiki/Expression-2#timer"},
    {"ref_awaree2"  , "https://github.com/wiremod/wire/wiki/Expression-2#self-aware"}
  }
}

local tConvar = {
  {"skip", "Contains trace generator blacklisted methods ( ex. GetSkin/GetModel/IsVehicle )"},
  {"only", "Contains trace generator whitelisted methods ( ex. GetSkin/GetModel/IsVehicle )"},
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
### What does this extension include?
Tracers with [hit][ref_trace-dt] and [ray][ref_ray] configuration. The difference with [wire rangers][ref_wranger]
is that this is a [dedicated class][ref_class_oop] being initialized once and used as many
times as it is needed, not creating an [instance][ref_oopinst] on every [E2][ref_exp2] [tick][ref_timere2] and later
wipe that [instance][ref_oopinst] out. It can extract every aspect of the [trace result structure][ref_trace-rz] returned and
it can be sampled [locally][ref_localcrd] ( [`origin`][ref_position] and [`direction`][ref_orient] relative to
[`entity`][ref_entity] or `pos`/`dir`/`ang` ) or globally ( [`entity`][ref_entity] is not available and `pos`/`dir`/`ang`
are treated world-space data ). Also, it has better [performance][ref_perfe2] than the [regular wire rangers][ref_wranger].

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
You can create a trace object by calling one of the dedicated creators `new%s` below
whenever you prefer to attach it to an entity or you prefer not to use the feature.
When sampled locally, it will use the [attachment entity][ref_entity] to [orient its direction][ref_orient]
and [length][ref_vec_norm] in [pure Lua][ref_lua]. You can also call the [class constructor][ref_class_con]
without an [entity][ref_entity] to make it world-space based. Remember that negating the trace length will
result in negating the trace direction. That is used because the trace length must always be positive so
the direction is reversed instead.

### How can I configure the trace filter?
There are currently three types of trace filters in [Garry's mod][ref-gmod] that you can put in the
[`trace data`][ref_trace-dt].`filter` value. Utilizing the method `getFilterMode` will return the
current tracer filter operation mode. The filter configuration is `NIL` by default  
 1. [Entity][ref_entity] reference directly written to the filter. This entity is skipped by the trace  
    This filter mode is activated by utilizing the `setFilterEnt` method by `Ent` as `entity`
 2. [Entity][ref_entity] sequential table ( array ) in the filter. Every item is skipped by the trace  
    This filter mode is activated by utilizing the `setFilterEar` method by `Ear` as `entity array`
 3. [Finction][ref_entity] callback routine. This is slower but the most uiversal method available   
    This filter mode is activated by utilizing the `setFilterFnc` method by `Fnc` as `function`
 4. User can also clear the filter entierly by utilizing the `remFilter` method

### Do you have an example by any chance?
The internal type of the class is `%s` and internal expression type `%s`, so to create 
a tracer instance you can take a [look at the example][ref_example].

### Can you show me the methods of the class?
The description of the API is provided in the table below.
]===]):format(API.NAME, API.NAME, API.TYPE.OBJ, API.FILE.exts)
end

return API
