local API = {
  NAME = "joystick",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = true,  -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbolic links []
    qref = true,  -- (TRUE) Quote the string in the link reference
    wdsc = true,  -- (TRUE) Outputs the direct wire-based description in the markdown overhead
    mosp = true,  -- (TRUE) Enables monospace font for the function names
    prep = false, -- (TRUE) Replace key in the link pattern in the replace table. Call formatting
    nxtp = true,  -- (TRUE) Uses the `number` datatype when one is not provided ( forced )
    ufbr = true   -- (TRUE) Uses file bottom references insted of long links ( forced )
  },
  POOL = {
    {name="MAKE",cols={"Instance creator", "Out", "Description"},size={32,5,13},algn={"<","|","<"}},
    {name="APPLY",cols={"Class methods", "Out", "Description"},size={35,5,13},algn={"<","|","<"}},
    {name="SETUP",cols={"General functions", "Out", "Description"},size={25,5,13},algn={"<","|","<"}}
  },
  FILE = {
    exts = "joystick",
    base = "F:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons/Joystick",
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
    {"ref_entity", "https://wiki.garrysmod.com/page/Global/Entity"},
    {"ref_lua", "https://en.wikipedia.org/wiki/Lua_(programming_language)"},
    {"ref_exp2", "https://github.com/wiremod/wire/wiki/Expression-2"},
    {"ref_perfe2","https://github.com/wiremod/wire/wiki/Expression-2#performance"},
    {"ref_joy", "https://en.wikipedia.org/wiki/Joystick"},
    {"ref_wiremod", "https://wiremod.com/"}
  }
}

API.DSCHUNK = [===[
E2Helper.Descriptions["joystickAxisCount(e:n)"] = "Returns the player enumerator axes count"
E2Helper.Descriptions["joystickAxisData(e:)"] = "Returns the player axes data array"
E2Helper.Descriptions["joystickButtonCount(e:n)"] = "Returns the player enumerator buttons count"
E2Helper.Descriptions["joystickButtonData(e:)"] = "Returns the player buttons data array"
E2Helper.Descriptions["joystickCount(e:)"] = "Returns the player enumenators count"
E2Helper.Descriptions["joystickName(e:n)"] = "Returns the player enumerator name"
E2Helper.Descriptions["joystickPOVCount(e:n)"] = "Returns the player enumerator POV count"
E2Helper.Descriptions["joystickPOVData(e:)"] = "Returns the player POV data array"
E2Helper.Descriptions["joystickRefresh()"] = "Refreshes the player internal joystick state"
E2Helper.Descriptions["joystickSetActive(e:nn)"] = "Toggles the player enumerator active stream state"
E2Helper.Descriptions["joystickSetActive(nn)"] = "Toggles the E2 chip entity enumerator active stream state"
]===]


API.TEXT = function() return ([===[
### What does this extension do?

The [wiremod][ref_wiremod] [Lua][ref_lua] extension [`%s`][ref_joy] is designed to be used with [`Wire Expression2`][ref_exp2]
in mind and implements general functions for manipulating given [player][ref_entity] [class][ref_class_oop] joystick
state as well as retrieve control data and other information. Beware of the E2 [performance][ref_perfe2] though.

### What is the [wiremod][ref_wiremod] [`Joystick`][ref_joy] API then?
]===]):format(API.NAME)
end

return API
