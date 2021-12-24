local API = {
  NAME = "Laser",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = true,  -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbolic links []
    qref = true,  -- (TRUE) Quote the string in the link reference
   -- wdsc = true,  -- (TRUE) Outputs the direct wire-based description in the markdown overhead
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
    exts = "laserbeam",
    base = "F:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons/LaserSTool",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
    --cvar = "wire_expression2_joystick",
    repo = "github.com/dvdvideo1234/LaserSTool",
    blob = "blob/main",
    desc = {
      ["advdupe2"] = "Extension testing duplications",
      ["e2_code_test_laserbeam.txt"] = "Laser dominant extraction test",
      ["pictures"] = "Contains addon pictures",
      ["workshop"] = "Workshop related crap",
      ["lua"] = "Contains all GLua woremod sub-addons",
      ["cl_laserbeam.lua"] = "FTrace class API description",
      ["laserbeam.lua"] = "StControl class API implementation",
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
    {"ref_addon", "https://en.wikipedia.org/wiki/Laser"},
    {"ref_wiremod", "https://wiremod.com/"}
  }
}

API.DSCHUNK = [===[
E2Helper.Descriptions["laserGetBeamDamage(e:)"]     = "Returns the laser source beam damage"
E2Helper.Descriptions["laserGetBeamForce(e:)"]      = "Returns the laser source beam force"
E2Helper.Descriptions["laserGetBeamLength(e:)"]     = "Returns the laser source beam length"
E2Helper.Descriptions["laserGetBeamMaterial(e:)"]   = "Returns the laser source beam material"
E2Helper.Descriptions["laserGetBeamPower(e:)"]      = "Returns the laser source beam power"
E2Helper.Descriptions["laserGetBeamWidth(e:)"]      = "Returns the laser source beam width"
E2Helper.Descriptions["laserGetDissolveType(e:)"]   = "Returns the laser source dissolve type name"
E2Helper.Descriptions["laserGetDissolveTypeID(e:)"] = "Returns the laser source dissolve type ID"
E2Helper.Descriptions["laserGetEndingEffect(e:)"]   = "Returns the laser source ending effect flag"
E2Helper.Descriptions["laserGetForceCenter(e:)"]    = "Returns the laser source force in center flag"
E2Helper.Descriptions["laserGetStartSound(e:)"]     = "Returns the laser source start sound"
E2Helper.Descriptions["laserGetStopSound(e:)"]      = "Returns the laser source stop sound"
E2Helper.Descriptions["laserGetKillSound(e:)"]      = "Returns the laser source kill sound"
E2Helper.Descriptions["laserGetNonOverMater(e:)"]   = "Returns the laser source base entity material flag"
E2Helper.Descriptions["laserGetPlayer(e:)"]         = "Returns the laser unit player getting the kill credit"
E2Helper.Descriptions["laserGetReflectRatio(e:)"]   = "Returns the laser source reflection ratio flag"
E2Helper.Descriptions["laserGetRefractRatio(e:)"]   = "Returns the laser source refraction ratio flag"
]===]


API.TEXT = function() return ([===[
### What does this extension do?

The [wiremod][ref_wiremod] [Lua][ref_lua] extension [`%s`][ref_addon] is designed to be used with [`Wire Expression2`][ref_exp2]
in mind and implements general functions for retrieving various values form a dominant source entity. 
Beware of the E2 [performance][ref_perfe2] though. You can create feebback loops for controling source beam parameters.

### What is the [wiremod][ref_wiremod] [`%s`][ref_addon] API then?
]===]):format(API.NAME, API.NAME)
end

return API
