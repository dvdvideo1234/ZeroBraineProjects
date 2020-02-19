local API = {
  NAME = "setPiston",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols or all-upper
    qref = true,  -- (TRUE) Quote the string in the link reference
    prep = true,  -- (TRUE) Replace key in the link pattern in the replace table. Call formatting
    mosp = true,  -- (TRUE) Enables monospace font for the function names
    wdsc = true   -- (TRUE) Outputs the direct wire-based description in the markdown overhead
  },
  POOL = {
    {name="MAKE",cols={"Instance creator", "Out", "Description"},size={34,5,13},algn={"<","|","<"}},
    {name="APPLY",cols={"Entity extensions", "Out", "Description"},size={46,5,13},algn={"<","|","<"}},
    {name="SETUP",cols={"General functions", "Out", "Description"},size={34,5,13},algn={"<","|","<"}}
  },
  FILE = {
    exts = "pistontiming",
    base = "E:/Documents/Lua-Projs/SVN/E2PistonTiming",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
    repo = "github.com/dvdvideo1234/E2PistonTiming",
    blob = "blob/master",
    desc = {
      ["Expression2"] = "Expression 2 examples",
      ["backup"] = "Excel for compating output",
      ["pictures"] = "Contains addon pictures",
      ["workshop"] = "Workshop related control crap",
      ["lua"] = "Contains all GLua woremod sub-addons",
      ["cl_wire_e2_piston_timing.lua"] = "Piston API description",
      ["wire_e2_piston_timing.lua"] = "Piston API implementation",
      ["workshop_publish.bat"] = "Automatic workshop publisher for windows"
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
    ["sign"] = "https://en.wikipedia.org/wiki/Sign_function",
    ["wave"] = "https://en.wikipedia.org/wiki/Sine",
    ["triangular"] = "https://en.wikipedia.org/wiki/Triangle_wave",
    ["cross-product"] = "https://en.wikipedia.org/wiki/Cross_product",
    ["ramp"] = "https://en.wikipedia.org/wiki/Ramp_function",
    ["local-axis"] = "https://en.wikipedia.org/wiki/Cartesian_coordinate_system"
  },
  HDESC = {
    top = "local E2Helper = {Descriptions = {}};",
    bot = "return E2Helper.Descriptions",
    dsc = "E2Helper.Descriptions"
  }
}

API.DSCHUNK = [===[

local DSC = E2Helper.Descriptions
local sMode = "Returns a flag if the piston is in %s mode by %s key"
local sNorm = "Creates a %s timed piston by %s key and highest point angle in degrees"
local sCros = "Creates a %s timed piston with %s output by %s key and highest point local vector"
local sRemv = "Removes the piston by %s key"
local sTopv = "Returns the piston %s %s point parameter by %s key"
local sRetk = "Returns the %s by %s key"
local sCont = "Returns the count of %s piston keys"
local sBasp = "%s the base prop %s using %s"
local sMark = "%s the crankshaft mark vector local to the base entity with %s"
local tKey = {"an integer", "a string"}
DSC["setPistonAxis(e:n)"]     = sBasp:format("Stores", "axis local vector", "x as number")
DSC["setPistonAxis(e:nn)"]    = sBasp:format("Stores", "axis local vector", "x and y as numbers")
DSC["setPistonAxis(e:nnn)"]   = sBasp:format("Stores", "axis local vector", "x, y and z numbers")
DSC["setPistonAxis(e:r)"]     = sBasp:format("Stores", "axis local vector", "an array")
DSC["setPistonAxis(e:v)"]     = sBasp:format("Stores", "axis local vector", "a vector")
DSC["setPistonAxis(e:xv2)"]   = sBasp:format("Stores", "axis local vector", "a 2D vector")
DSC["getPistonAxis(e:)"]      = sBasp:format("Returns", "axis local vector", "x as number")
DSC["resPistonAxis(e:)"]      = sBasp:format("Clears", "axis local vector", "no arguments")
DSC["setPistonBase(e:e)"]     = sBasp:format("Stores", "entity", "an entity")
DSC["setPistonBase(e:)"]      = sBasp:format("Stores", "entity", "no arguments")
DSC["getPistonBase(e:)"]      = sBasp:format("Returns", "entity", "no arguments")
DSC["resPistonBase(e:)"]      = sBasp:format("Clears", "entity", "no arguments")
DSC["clrPiston(e:)"]          = "Clears the pistons from the E2 chip"
DSC["allPiston(e:)"]          = sCont:format("all")
DSC["cntPiston(e:)"]          = sCont:format("integer")
DSC["getPiston(e:nn)"]        = sRetk:format("piston bearing timing", tKey[1])
DSC["getPiston(e:sn)"]        = sRetk:format("piston bearing timing", tKey[2])
DSC["getPiston(e:nv)"]        = sRetk:format("piston vector timing" , tKey[1])
DSC["getPiston(e:sv)"]        = sRetk:format("piston vector timing" , tKey[2])
DSC["getPistonBase(e:n)"]     = sRetk:format("engine base entity"   , tKey[1])
DSC["getPistonBase(e:s)"]     = sRetk:format("engine base entity"   , tKey[2])
DSC["getPistonAxis(e:n)"]     = sRetk:format("shaft rotation axis"  , tKey[1])
DSC["getPistonAxis(e:s)"]     = sRetk:format("shaft rotation axis"  , tKey[2])
DSC["getPistonMax(e:n)"]      = sTopv:format("number", "highest", tKey[1])
DSC["getPistonMax(e:s)"]      = sTopv:format("number", "highest", tKey[2])
DSC["getPistonMin(e:n)"]      = sTopv:format("number", "lowest" , tKey[1])
DSC["getPistonMin(e:s)"]      = sTopv:format("number", "lowest" , tKey[2])
DSC["getPistonMaxX(e:n)"]     = sTopv:format("vector", "highest", tKey[1])
DSC["getPistonMaxX(e:s)"]     = sTopv:format("vector", "highest", tKey[2])
DSC["getPistonMinX(e:n)"]     = sTopv:format("vector", "lowest" , tKey[1])
DSC["getPistonMinX(e:s)"]     = sTopv:format("vector", "lowest" , tKey[2])
DSC["remPiston(e:n)"]         = sRemv:format(tKey[1])
DSC["remPiston(e:s)"]         = sRemv:format(tKey[2])
DSC["setPistonSign(e:nn)"]    = sNorm:format("sign", tKey[1])
DSC["setPistonSign(e:sn)"]    = sNorm:format("sign", tKey[2])
DSC["setPistonWave(e:nn)"]    = sNorm:format("wave", tKey[1])
DSC["setPistonWave(e:sn)"]    = sNorm:format("wave", tKey[2])
DSC["setPistonRamp(e:nn)"]    = sNorm:format("triangular", tKey[1])
DSC["setPistonRamp(e:sn)"]    = sNorm:format("triangular", tKey[2])
DSC["setPistonSignX(e:nv)"]   = sCros:format("cross-product", "sign", tKey[1])
DSC["setPistonSignX(e:sv)"]   = sCros:format("cross-product", "sign", tKey[2])
DSC["setPistonSignX(e:nvv)"] = sCros:format("cross-product", "sign", tKey[1])
DSC["setPistonSignX(e:svv)"] = sCros:format("cross-product", "sign", tKey[2])
DSC["setPistonWaveX(e:nv)"]   = sCros:format("cross-product", "wave", tKey[1])
DSC["setPistonWaveX(e:sv)"]   = sCros:format("cross-product", "wave", tKey[2])
DSC["setPistonWaveX(e:nvv)"] = sCros:format("cross-product", "wave", tKey[1])
DSC["setPistonWaveX(e:svv)"] = sCros:format("cross-product", "wave", tKey[2])
DSC["isPistonSign(e:n)"]      = sMode:format("sign", tKey[1])
DSC["isPistonSign(e:s)"]      = sMode:format("sign", tKey[2])
DSC["isPistonWave(e:n)"]      = sMode:format("wave", tKey[1])
DSC["isPistonWave(e:s)"]      = sMode:format("wave", tKey[2])
DSC["isPistonSignX(e:n)"]     = sMode:format("cross-product sign", tKey[1])
DSC["isPistonSignX(e:s)"]     = sMode:format("cross-product sign", tKey[2])
DSC["isPistonWaveX(e:n)"]     = sMode:format("cross-product wave", tKey[1])
DSC["isPistonWaveX(e:s)"]     = sMode:format("cross-product wave", tKey[2])
DSC["isPistonRamp(e:n)"]      = sMode:format("triangular", tKey[1])
DSC["isPistonRamp(e:s)"]      = sMode:format("triangular", tKey[2])
DSC["getPistonMark(e:)"]      = sBasp:format("Returns", "general rotation mark local vector", "no arguments")
DSC["resPistonMark(e:)"]      = sBasp:format("Clears", "general rotation mark local vector", "no arguments")
DSC["setPistonMark(e:n)"]     = sBasp:format("Stores", "general rotation mark local vector", "x as number")
DSC["setPistonMark(e:nn)"]    = sBasp:format("Stores", "general rotation mark local vector", "x and y as numbers")
DSC["setPistonMark(e:nnn)"]   = sBasp:format("Stores", "general rotation mark local vector", "x, y and z numbers")
DSC["setPistonMark(e:r)"]     = sBasp:format("Stores", "general rotation mark local vector", "array")
DSC["setPistonMark(e:v)"]     = sBasp:format("Stores", "general rotation mark local vector", "vector")
DSC["setPistonMark(e:xv2)"]   = sBasp:format("Stores", "general rotation mark local vector", "2D vector")
DSC["cnvPistonMark(e:)"]      = sMark:format("Converts", "general mark and base")
DSC["cnvPistonMark(e:e)"]     = sMark:format("Converts", "general mark and local base")
DSC["cnvPistonMark(e:v)"]     = sMark:format("Converts", "local mark and general base")
DSC["cnvPistonMark(e:nnn)"]   = sMark:format("Converts", "local x, y, z mark and general base")
DSC["cnvPistonMark(e:ve)"]    = sMark:format("Converts", "local mark and local base")

]===]

return API
