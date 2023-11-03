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
    ufbr = true,  -- (TRUE) Uses file bottom references insted of long links ( forced )
    mchp = true   -- (TRUE) Customize API pools that have the /mach/ key present (with priority)
  },
  POOL = {
    {name="DATA" ,mach="laserGetData" ,cols={"Beam data parameters"  , "Out", "Description"},size={32,5,13},algn={"<","|","<"}},
    {name="TRACE",mach="laserGetTrace",cols={"Beam trace parameters" , "Out", "Description"},size={35,5,13},algn={"<","|","<"}},
    {name="CLASS",mach="e:"           ,cols={"Class configurations"  , "Out", "Description"},size={25,5,13},algn={"<","|","<"}},
    {name="OTHER",cols={"Other helper functions", "Out", "Description"},size={50,5,13},algn={"<","|","<"}},
  },
  FILE = {
    exts = "laserbeam",
    sors = {"F:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons/LaserSTool", "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/LaserSTool"},
    base = "F:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons/LaserSTool",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
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
    ["StControl"] = "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl",
    ["last trace"] = "https://wiki.facepunch.com/gmod/Structures/TraceResult",
    ["hit group enums"] = "https://wiki.facepunch.com/gmod/Enums/HITGROUP",
    ["material type enums"] = "https://wiki.facepunch.com/gmod/Enums/MAT",
    ["surface flags enums"] = "https://wiki.facepunch.com/gmod/Enums/SURF",
    ["surface displacement flag enums"] = "https://wiki.facepunch.com/gmod/Enums/DISPSURF",
    ["surface contents enums"] = "https://wiki.facepunch.com/gmod/Enums/CONTENTS",   
    ["hit group enum"] = "https://wiki.facepunch.com/gmod/Enums/HITGROUP",
    ["material type enum"] = "https://wiki.facepunch.com/gmod/Enums/MAT",
    ["surface flags enum"] = "https://wiki.facepunch.com/gmod/Enums/SURF",
    ["surface displacement flag enum"] = "https://wiki.facepunch.com/gmod/Enums/DISPSURF",
    ["surface content enum"] = "https://wiki.facepunch.com/gmod/Enums/CONTENTS", 
    ["entity"] = "https://wiki.facepunch.com/gmod/Entity",
    ["vector"] = "https://wiki.facepunch.com/gmod/Vector",
    ["surface properties name"] = "https://wiki.facepunch.com/gmod/util.GetSurfacePropName",
    ["incident"] = "https://en.wikipedia.org/wiki/Ray_(optics)",
    ["normal"] = "https://en.wikipedia.org/wiki/Normal_(geometry)",
    ["reflection"] = "https://en.wikipedia.org/wiki/Reflection_(physics)",
    ["reflect"] = "https://en.wikipedia.org/wiki/Reflection_(physics)",
    ["refraction"] = "https://en.wikipedia.org/wiki/Refraction",
    ["refract"] = "https://en.wikipedia.org/wiki/Refraction",
    ["medium"] = "https://en.wikipedia.org/wiki/Optical_medium",
    ["laser"] = "https://en.wikipedia.org/wiki/Laser",
    ["beam"] = "https://en.wikipedia.org/wiki/Laser",
    ["dissolve"] = "https://developer.valvesoftware.com/wiki/Env_entity_dissolver"
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
    {"ref_wiremod", "https://wiremod.com/"},
    {"ref_autogen_page", "https://github.com/dvdvideo1234/ZeroBraineProjects/blob/master/ExtractWireWiki/api/laserbeam.lua"}
  }
}

API.DSCHUNK = [===[
-- Wiremode dedicated entity method to retrieve data from laser sources
E2Helper.Descriptions["laserGetBeamDamage(e:)"]             = "Returns the laser source beam damage"
E2Helper.Descriptions["laserGetBeamForce(e:)"]              = "Returns the laser source beam force"
E2Helper.Descriptions["laserGetBeamLength(e:)"]             = "Returns the laser source beam length"
E2Helper.Descriptions["laserGetBeamMaterial(e:)"]           = "Returns the laser source beam material"
E2Helper.Descriptions["laserGetBeamPower(e:)"]              = "Returns the laser source beam power"
E2Helper.Descriptions["laserGetBeamWidth(e:)"]              = "Returns the laser source beam width"
E2Helper.Descriptions["laserGetDissolveType(e:)"]           = "Returns the laser source dissolve type name"
E2Helper.Descriptions["laserGetDissolveTypeID(e:)"]         = "Returns the laser source dissolve type ID"
E2Helper.Descriptions["laserGetEndingEffect(e:)"]           = "Returns the laser source ending effect flag"
E2Helper.Descriptions["laserGetForceCenter(e:)"]            = "Returns the laser source force in center flag"
E2Helper.Descriptions["laserGetKillSound(e:)"]              = "Returns the laser source kill sound"
E2Helper.Descriptions["laserGetNonOverMater(e:)"]           = "Returns the laser source base entity material flag"
E2Helper.Descriptions["laserGetPlayer(e:)"]                 = "Returns the laser unit player getting the kill credit"
E2Helper.Descriptions["laserGetReflectRatio(e:)"]           = "Returns the laser source reflection ratio flag"
E2Helper.Descriptions["laserGetRefractRatio(e:)"]           = "Returns the laser source refraction ratio flag"
E2Helper.Descriptions["laserGetStartSound(e:)"]             = "Returns the laser source start sound"
E2Helper.Descriptions["laserGetStopSound(e:)"]              = "Returns the laser source stop sound"
-- Wiremode dedicated entity method to retrieve beam data and trace from hit reports
E2Helper.Descriptions["laserGetDataBounceMax(e:n)"]         = "Returns the maximum allowed laser beam bounces"
E2Helper.Descriptions["laserGetDataBounceRest(e:n)"]        = "Returns the remaining laser beam bounces"
E2Helper.Descriptions["laserGetDataDamage(e:n)"]            = "Returns the remaining laser beam damage"
E2Helper.Descriptions["laserGetDataDirect(e:n)"]            = "Returns the last laser beam direction vector"
E2Helper.Descriptions["laserGetDataForce(e:n)"]             = "Returns the remaining laser beam force"
E2Helper.Descriptions["laserGetDataIsReflect(e:n)"]         = "Returns the laser source reflect flag"
E2Helper.Descriptions["laserGetDataIsRefract(e:n)"]         = "Returns the laser source refract flag"
E2Helper.Descriptions["laserGetDataLength(e:n)"]            = "Returns the laser source beam length"
E2Helper.Descriptions["laserGetDataLengthRest(e:n)"]        = "Returns the remaining laser beam length"
E2Helper.Descriptions["laserGetDataOrigin(e:n)"]            = "Returns the last laser beam origin vector"
E2Helper.Descriptions["laserGetDataPointDamage(e:nn)"]      = "Returns the laser beam node damage"
E2Helper.Descriptions["laserGetDataPointForce(e:nn)"]       = "Returns the laser beam node force"
E2Helper.Descriptions["laserGetDataPointIsDraw(e:nn)"]      = "Returns the laser beam node draw flag"
E2Helper.Descriptions["laserGetDataPointNode(e:nn)"]        = "Returns the laser beam node location vector"
E2Helper.Descriptions["laserGetDataPointSize(e:n)"]         = "Returns the laser beam nodes count"
E2Helper.Descriptions["laserGetDataPointWidth(e:nn)"]       = "Returns the laser beam node width"
E2Helper.Descriptions["laserGetDataRange(e:n)"]             = "Returns the laser beam traverse range"
E2Helper.Descriptions["laserGetDataSource(e:n)"]            = "Returns the laser beam source entity"
E2Helper.Descriptions["laserGetDataWidth(e:n)"]             = "Returns the remaining laser beam width"
E2Helper.Descriptions["laserGetTraceAllSolid(e:n)"]         = "Returns the last trace all solid flag"
E2Helper.Descriptions["laserGetTraceContents(e:n)"]         = "Returns the last trace hit surface contents"
E2Helper.Descriptions["laserGetTraceDispFlags(e:n)"]        = "Returns the last trace hit surface displacement flags"
E2Helper.Descriptions["laserGetTraceEntity(e:n)"]           = "Returns the last trace entity"
E2Helper.Descriptions["laserGetTraceFraction(e:n)"]         = "Returns the last trace used hit fraction `[0-1]`"
E2Helper.Descriptions["laserGetTraceFractionLS(e:n)"]       = "Returns the last trace fraction left solid [0-1]"
E2Helper.Descriptions["laserGetTraceHit(e:n)"]              = "Returns the last trace hit flag"
E2Helper.Descriptions["laserGetTraceHitBox(e:n)"]           = "Returns the last trace hit box ID"
E2Helper.Descriptions["laserGetTraceHitGroup(e:n)"]         = "Returns the last trace hit group"
E2Helper.Descriptions["laserGetTraceHitNoDraw(e:n)"]        = "Returns the last trace hit no-draw brush"
E2Helper.Descriptions["laserGetTraceHitNonWorld(e:n)"]      = "Returns the last trace hit non-world flag"
E2Helper.Descriptions["laserGetTraceHitNormal(e:n)"]        = "Returns the last trace hit normal vector"
E2Helper.Descriptions["laserGetTraceHitPhysicsBone(e:n)"]   = "Returns the last trace hit physics bone ID"
E2Helper.Descriptions["laserGetTraceHitPos(e:n)"]           = "Returns the last trace hit position vector"
E2Helper.Descriptions["laserGetTraceHitSky(e:n)"]           = "Returns the last trace hit sky flag"
E2Helper.Descriptions["laserGetTraceHitTexture(e:n)"]       = "Returns the last trace hit texture"
E2Helper.Descriptions["laserGetTraceHitWorld(e:n)"]         = "Returns the last trace hit world flag"
E2Helper.Descriptions["laserGetTraceNormal(e:n)"]           = "Returns the last trace normal vector"
E2Helper.Descriptions["laserGetTraceStartPos(e:n)"]         = "Returns the last trace start position"
E2Helper.Descriptions["laserGetTraceStartSolid(e:n)"]       = "Returns the last trace start solid flag"
E2Helper.Descriptions["laserGetTraceSurfaceFlags(e:n)"]     = "Returns the last trace hit surface flags"
E2Helper.Descriptions["laserGetTraceSurfacePropsID(e:n)"]   = "Returns the last trace hit surface properties ID"
E2Helper.Descriptions["laserGetTraceSurfacePropsName(e:n)"] = "Returns the last trace hit surface properties name"
]===]

API.DSCHUNK = nil -- Read description from the client file

API.TEXT = function() return ([===[
### Documentation updates

[Do **NOT** edit this documentation manually. This page is automatically generated!][ref_autogen_page]

### What does this extension do?

The [wiremod][ref_wiremod] [Lua][ref_lua] extension [`%s`][ref_addon] is designed to be used with [`Wire Expression2`][ref_exp2]
in mind and implements general functions for retrieving various values form a dominant source entity or database entries. 
Beware of the E2 [performance][ref_perfe2] though. You can create feedback loops for controlling source beam parameters.

### What is the [wiremod][ref_wiremod] [`%s`][ref_addon] API then?
]===]):format(API.NAME, API.NAME)
end

return API
