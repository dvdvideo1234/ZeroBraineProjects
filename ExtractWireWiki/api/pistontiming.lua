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
    {name="APPLY",cols={"Crankshaft extensions", "Out", "Description"},size={46,5,13},algn={"<","|","<"}},
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
      ["lua"] = "Contains all GLua wiremod sub-addons",
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
    ["cross product"] = "https://en.wikipedia.org/wiki/Cross_product",
    ["trochoid"] = "https://en.wikipedia.org/wiki/Trochoid",
    ["ramp"] = "https://en.wikipedia.org/wiki/Ramp_function",
    ["exponential"] = "https://en.wikipedia.org/wiki/Exponentiation",
    ["square root"] = "https://en.wikipedia.org/wiki/Square_root",
    ["local axis"] = "https://en.wikipedia.org/wiki/Cartesian_coordinate_system",
    ["coefficient"] = "https://en.wikipedia.org/wiki/Coefficient",
    ["logarithmic"] = "https://en.wikipedia.org/wiki/Logarithm",
    ["logarithmic"] = "https://en.wikipedia.org/wiki/Trapezoid"
  },
  HDESC = {
    top = "local E2Helper = {Descriptions = {}};",
    bot = "return E2Helper.Descriptions",
    dsc = "E2Helper.Descriptions"
  }
}

API.DSCHUNK = [===[

local DSC = E2Helper.Descriptions
local sMode = "Returns flag if the piston is in %s mode by %s key"
local sNorm = "Creates %s timed piston by %s key and highest point angle in degrees"
local sCros = "Creates %s timed piston with %s output by %s key and highest point local vector"
local sCroa = "Creates %s timed piston with %s output by %s key, highest point local vector and axis vector"
local sRemv = "Removes the piston by %s key"
local sTopv = "Returns the piston %s %s point parameter by %s key"
local sRetk = "Returns the %s by %s key"
local sCont = "Returns the count of %s piston keys"
local sBasp = "%s the expression chip general %s using %s"
local sMark = "%s the crankshaft marker vector local to the base entity with %s"
local tKey = {"an integer", "a string"}
DSC["setPistonAxis(n)"]       = sBasp:format("Stores" , "axis local vector", "number X")
DSC["setPistonAxis(nn)"]      = sBasp:format("Stores" , "axis local vector", "numbers X and Y")
DSC["setPistonAxis(nnn)"]     = sBasp:format("Stores" , "axis local vector", "numbers X, Y and Z")
DSC["setPistonAxis(r)"]       = sBasp:format("Stores" , "axis local vector", "an array")
DSC["setPistonAxis(v)"]       = sBasp:format("Stores" , "axis local vector", "a 3D vector")
DSC["setPistonAxis(xv2)"]     = sBasp:format("Stores" , "axis local vector", "a 2D vector")
DSC["getPistonAxis()"]        = sBasp:format("Returns", "axis local vector", "no arguments")
DSC["resPistonAxis()"]        = sBasp:format("Clears" , "axis local vector", "no arguments")
DSC["setPistonBase(e)"]       = sBasp:format("Stores" , "base entity", "an entity")
DSC["getPistonBase()"]        = sBasp:format("Returns", "base entity", "no arguments")
DSC["resPistonBase()"]        = sBasp:format("Clears" , "base entity", "no arguments")
DSC["clrPiston(e:)"]          = "Clears the pistons from the crankshaft entity"
DSC["allPiston(e:)"]          = sCont:format("all")
DSC["cntPiston(e:)"]          = sCont:format("integer")
DSC["getPiston(e:nn)"]        = sRetk:format("piston bearing timing", tKey[1])
DSC["getPiston(e:sn)"]        = sRetk:format("piston bearing timing", tKey[2])
DSC["getPiston(e:nv)"]        = sRetk:format("piston vector timing" , tKey[1])
DSC["getPiston(e:sv)"]        = sRetk:format("piston vector timing" , tKey[2])
DSC["getPistonBase(e:n)"]     = sRetk:format("shaft base entity"    , tKey[1])
DSC["getPistonBase(e:s)"]     = sRetk:format("shaft base entity"    , tKey[2])
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
DSC["setPistonSignX(e:nv)"]   = sCros:format("cross product", "sign", tKey[1])
DSC["setPistonSignX(e:sv)"]   = sCros:format("cross product", "sign", tKey[2])
DSC["setPistonSignX(e:nvv)"]  = sCroa:format("cross product", "sign", tKey[1])
DSC["setPistonSignX(e:svv)"]  = sCroa:format("cross product", "sign", tKey[2])
DSC["setPistonWaveX(e:nv)"]   = sCros:format("cross product", "wave", tKey[1])
DSC["setPistonWaveX(e:sv)"]   = sCros:format("cross product", "wave", tKey[2])
DSC["setPistonWaveX(e:nvv)"]  = sCroa:format("cross product", "wave", tKey[1])
DSC["setPistonWaveX(e:svv)"]  = sCroa:format("cross product", "wave", tKey[2])
DSC["isPistonSign(e:n)"]      = sMode:format("sign", tKey[1])
DSC["isPistonSign(e:s)"]      = sMode:format("sign", tKey[2])
DSC["isPistonWave(e:n)"]      = sMode:format("wave", tKey[1])
DSC["isPistonWave(e:s)"]      = sMode:format("wave", tKey[2])
DSC["isPistonSignX(e:n)"]     = sMode:format("cross product sign", tKey[1])
DSC["isPistonSignX(e:s)"]     = sMode:format("cross product sign", tKey[2])
DSC["isPistonWaveX(e:n)"]     = sMode:format("cross product wave", tKey[1])
DSC["isPistonWaveX(e:s)"]     = sMode:format("cross product wave", tKey[2])
DSC["isPistonRamp(e:n)"]      = sMode:format("triangular", tKey[1])
DSC["isPistonRamp(e:s)"]      = sMode:format("triangular", tKey[2])
DSC["getPistonMark()"]        = sBasp:format("Returns", "rotation marker local vector", "no arguments")
DSC["resPistonMark()"]        = sBasp:format("Clears" , "rotation marker local vector", "no arguments")
DSC["setPistonMark(n)"]       = sBasp:format("Stores" , "rotation marker local vector", "number X")
DSC["setPistonMark(nn)"]      = sBasp:format("Stores" , "rotation marker local vector", "numbers X and Y")
DSC["setPistonMark(nnn)"]     = sBasp:format("Stores" , "rotation marker local vector", "numbers X, Y and Z")
DSC["setPistonMark(r)"]       = sBasp:format("Stores" , "rotation marker local vector", "array")
DSC["setPistonMark(v)"]       = sBasp:format("Stores" , "rotation marker local vector", "3D vector")
DSC["setPistonMark(xv2)"]     = sBasp:format("Stores" , "rotation marker local vector", "2D vector")
DSC["cnvPistonMark(e:)"]      = sMark:format("Converts", "general marker and base")
DSC["cnvPistonMark(e:e)"]     = sMark:format("Converts", "general marker and local base")
DSC["cnvPistonMark(e:v)"]     = sMark:format("Converts", "local marker and general base")
DSC["cnvPistonMark(e:nnn)"]   = sMark:format("Converts", "local X, Y, Z marker and general base")
DSC["cnvPistonMark(e:ve)"]    = sMark:format("Converts", "local marker and local base")
DSC["isPistonTroc(e:n)"]      = sMode:format("trochoid", tKey[1])
DSC["isPistonTroc(e:s)"]      = sMode:format("trochoid", tKey[2])
DSC["setPistonTroc(e:nn)"]    = sNorm:format("trochoid", tKey[1])
DSC["setPistonTroc(e:sn)"]    = sNorm:format("trochoid", tKey[2])
DSC["resPistonTune()"]        = sBasp:format("Clears", "tuning coefficient [10]", "no arguments")
DSC["setPistonTune(n)"]       = sBasp:format("Stores", "tuning coefficient [0..500]", "number")
DSC["getPistonTune(e:n)"]     = sRetk:format("piston tuning coefficient", tKey[1])
DSC["getPistonTune(e:s)"]     = sRetk:format("piston tuning coefficient", tKey[2])

-------- Exponetial handlers
DSC["isPistonExpo(e:n)"]      = sMode:format("exponential", tKey[1])
DSC["isPistonExpo(e:s)"]      = sMode:format("exponential", tKey[2])
DSC["setPistonExpo(e:nn)"]    = sNorm:format("exponential default coefficient [10]", tKey[1])
DSC["setPistonExpo(e:sn)"]    = sNorm:format("exponential default coefficient [10]", tKey[2])
DSC["setPistonExpo(e:nnn)"]   = sNorm:format("exponential tuning coefficient [0..500]", tKey[1])
DSC["setPistonExpo(e:snn)"]   = sNorm:format("exponential tuning coefficient [0..500]", tKey[2])

-------- Logarithmic handlers
DSC["isPistonLogn(e:n)"]      = sMode:format("logarithmic", tKey[1])
DSC["isPistonLogn(e:s)"]      = sMode:format("logarithmic", tKey[2])
DSC["setPistonLogn(e:nn)"]    = sNorm:format("logarithmic default coefficient [10]", tKey[1])
DSC["setPistonLogn(e:sn)"]    = sNorm:format("logarithmic default coefficient [10]", tKey[2])
DSC["setPistonLogn(e:nnn)"]   = sNorm:format("logarithmic tuning coefficient [0..500]", tKey[1])
DSC["setPistonLogn(e:snn)"]   = sNorm:format("logarithmic tuning coefficient [0..500]", tKey[2])

-------- Power handlers
DSC["isPistonPowr(e:n)"]      = sMode:format("power", tKey[1])
DSC["isPistonPowr(e:s)"]      = sMode:format("power", tKey[2])
DSC["setPistonPowr(e:nn)"]    = sNorm:format("power default coefficient [10]", tKey[1])
DSC["setPistonPowr(e:sn)"]    = sNorm:format("power default coefficient [10]", tKey[2])
DSC["setPistonPowr(e:nnn)"]   = sNorm:format("power tuning coefficient [0..500]", tKey[1])
DSC["setPistonPowr(e:snn)"]   = sNorm:format("power tuning coefficient [0..500]", tKey[2])

-------- Trapezoidal handlers
DSC["isPistonTrpz(e:n)"]      = sMode:format("trapezoidal", tKey[1])
DSC["isPistonTrpz(e:s)"]      = sMode:format("trapezoidal", tKey[2])
DSC["setPistonTrpz(e:nn)"]    = sNorm:format("trapezoidal default coefficient [10]", tKey[1])
DSC["setPistonTrpz(e:sn)"]    = sNorm:format("trapezoidal default coefficient [10]", tKey[2])
DSC["setPistonTrpz(e:nnn)"]   = sNorm:format("trapezoidal tuning coefficient [0..500]", tKey[1])
DSC["setPistonTrpz(e:snn)"]   = sNorm:format("trapezoidal tuning coefficient [0..500]", tKey[2])


]===]

return API
