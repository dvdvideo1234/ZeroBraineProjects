local com = require("dvdlualib/common")
local gmd = require("dvdlualib/gmodlib")

local DSC = {}

local sMode = "Returns a flag if the piston is in %s mode by %s key"
local sNorm = "Creates a %s timed piston by %s key and highest point angle in degrees"
local sCros = "Creates a %s timed piston with %s output by %s key and highest point local vector"
local sRemv = "Removes the piston by %s key"
local sTopv = "Returns the piston %s %s point parameter by %s key"
local sRetk = "Returns the %s by %s key"
local sCont = "Returns the count of %s piston keys"
local sBasp = "%s the base prop %s using %s"
local tKey = {"an integer", "a string"}
DSC["setPistonAxis(e:n)"]     = sBasp:format("Stores", "axis local vector", "x as number")
DSC["setPistonAxis(e:nn)"]    = sBasp:format("Stores", "axis local vector", "x and y as numbers")
DSC["setPistonAxis(e:nnn)"]   = sBasp:format("Stores", "axis local vector", "x, y and z numbers")
DSC["setPistonAxis(e:r)"]     = sBasp:format("Stores", "axis local vector", "an array")
DSC["setPistonAxis(e:v)"]     = sBasp:format("Stores", "axis local vector", "a vector")
DSC["setPistonAxis(e:xv2)"]   = sBasp:format("Stores", "axis local vector", "a 2D vector")
DSC["getPistonAxis(e:)"]      = sBasp:format("Returns", "axis local vector", "x as number")
DSC["resPistonAxis(e:)"]      = sBasp:format("Clears", "axis local vector", "the crankshaft entity")
DSC["setPistonBase(e:e)"]     = sBasp:format("Stores", "entity", "an entity")
DSC["resPistonBase(e:)"]      = sBasp:format("Clears", "entity", "the crankshaft entity")
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