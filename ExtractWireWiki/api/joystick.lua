local API = {
  NAME = "joystick",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols links []
    qref = true,  -- (TRUE) Quote the string in the link reference
    wdsc = true,  -- (TRUE) Outputs the direct wire-based description in the markdown overhead
    mosp = true,  -- (TRUE) Enables monospace font for the function names
    prep = false, -- (TRUE) Replace key in the link pattern in the replace table. Call formatting
    nxtp = true   -- (TRUE) Uses the `number` datatype when one is not provided ( forced )
  },
  POOL = {
    {name="MAKE",cols={"Instance creator", "Out", "Description"},size={32,5,13},algn={"<","|","<"}},
    {name="APPLY",cols={"Class methods", "Out", "Description"},size={35,5,13},algn={"<","|","<"}},
    {name="SETUP",cols={"General functions", "Out", "Description"},size={25,5,13},algn={"<","|","<"}}
  },
  FILE = {
    exts = "joystick",
    base = "F:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons/Joystick", -- ControlSystemsE2, wire-extras
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
    cvar = "wire_expression2_joystick",
    repo = "github.com/MattJeanes/Joystick-Module",
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
      ["workshop_publish.bat"] = "Automatic workshop publisher for Windows"
    }
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
    ["trace-line"] = "https://wiki.garrysmod.com/page/util/TraceLine",
    ["trace-strict"] = "https://wiki.garrysmod.com/page/Structures/Trace",
    ["trace-result"] = "https://wiki.garrysmod.com/page/Structures/TraceResult",
    ["FTrace"] = "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FTrace",
    ["bitmask"] = "https://en.wikipedia.org/wiki/Mask_(computing)",
    ["SURF"] = "https://wiki.facepunch.com/gmod/Enums/SURF",
    ["DISPSURF"] = "https://wiki.facepunch.com/gmod/Enums/DISPSURF",
    ["CONTENTS"] = "https://wiki.facepunch.com/gmod/Enums/CONTENTS",
    ["StControl"] = "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl"
  },
  HDESC = {
    top = [===[
      local E2Helper = {Descriptions = {}}
      local language = {Add = function() return nil end}
      local file     = {Exists = function() return nil end}
      local net      = {Receive = function() return nil end}
    ]===],
    bot = "return E2Helper.Descriptions",
    dsc = "E2Helper.Descriptions"
  },
  REFLN = {
    {"ref_class_oop","https://en.wikipedia.org/wiki/Class_(computer_programming)"},
    {"ref_example", "https://github.com/dvdvideo1234/ControlSystemsE2/blob/master/data/Expression2/e2_code_test_ftrace.txt"},
    {"ref_trace" , "https://wiki.garrysmod.com/page/Structures/TraceResult"},
    {"ref_class_con", "https://en.wikipedia.org/wiki/Constructor_(object-oriented_programming)"},
    {"ref_entity", "https://wiki.garrysmod.com/page/Global/Entity"},
    {"ref_orient", "https://en.wikipedia.org/wiki/Orientation_(geometry)"},
    {"ref_vec_norm","https://en.wikipedia.org/wiki/Euclidean_vector#Length"},
    {"ref_lua", "https://en.wikipedia.org/wiki/Lua_(programming_language)"},
    {"ref_exp2", "https://github.com/wiremod/wire/wiki/Expression-2"},
    {"ref_ray", "https://en.wikipedia.org/wiki/Line_(geometry)#Ray"},
    {"ref_wranger","https://github.com/wiremod/wire/wiki/Expression-2#built-in-ranger"},
    {"ref_oopinst","https://en.wikipedia.org/wiki/Instance_(computer_science)"},
    {"ref_perfe2","https://github.com/wiremod/wire/wiki/Expression-2#performance"},
    {"ref_localcrd","https://en.wikipedia.org/wiki/Local_coordinates"},
    {"ref_position","https://en.wikipedia.org/wiki/Position_(geometry)"},
    {"ref_timere2", "https://github.com/wiremod/wire/wiki/Expression-2#timer"},
    {"ref_awaree2","https://github.com/wiremod/wire/wiki/Expression-2#self-aware"}
  }
}

API.DSCHUNK = [===[
E2Helper.Descriptions["joystickAxisCount(e:n)"] = "TEST"
]===]


API.TEXT = function() return ([===[
### What does this extension include?
Tracers with [hit][ref_trace] and [ray][ref_ray] configuration. The difference with [wire rangers][ref_wranger]
is that this is a [dedicated class][ref_class_oop] being initialized once and used as many
times as it is needed, not creating an [instance][ref_oopinst] on every [E2][ref_exp2] [tick][ref_timere2] and later
wipe that [instance][ref_oopinst] out. It can extract every aspect of the [trace result structure][ref_trace] returned and
it can be sampled [locally][ref_localcrd] ( [`origin`][ref_position] and [`direction`][ref_orient] relative to
[`entity`][ref_entity] or `pos`/`dir`/`ang` ) or globally ( [`entity`][ref_entity] is not available and `pos`/`dir`/`ang`
are treated world-space data ). Also, it has better [performance][ref_perfe2] than the [regular wire rangers][ref_wranger].

]===]):format(API.NAME, API.NAME, API.TYPE.OBJ, API.FILE.exts)
end

return API
