local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
                
local com = require("common")
local rev = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT/lua/"

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)
require("gmodlib")

local function CongigureLIB(sRev)
  print("----------------LIBS----------------")
  -- single source of truth
  dofile(sRev.."trackassembly/trackasmlib.lua")
  local asmlib = trackasmlib 
  if not asmlib then error("No library") end
  print("SetOpVar 0 identity:", asmlib.SetOpVar)
  print("SetOpVar 1 identity:", trackasmlib.SetOpVar)
  local oservr = asmlib.SetOpVar
  asmlib.SetOpVar = function(n, v)
    if n ~= "DIRPATH_BAS" then
      return oservr(n, v)
    else
      return oservr(n, "Assembly/trackassembly/")
    end
  end
  print("SetOpVar 2 identity:", asmlib.SetOpVar)
  print("SetOpVar 3 identity:", trackasmlib.SetOpVar)
  print("----------------INIT----------------")
  -- init must operate on the SAME instance
  dofile(sRev.."autorun/trackassembly_init.lua")
  return asmlib
end

local asmlib = CongigureLIB(rev)
asmlib.SetLogControl(20000, false)

asmlib.IsFlag("file_read_once", false)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end

local s = asmlib.GetBeautify()

local tD = {
  "models/props_phx/trains/tracks/track_crossing.mdl",
  "models/props_phx/trains/tracks/track_turn90.mdl",
  123456789,
  "",
  {},
  function() end
}

s:SetRule({1,6},{"turn","turn_"})

for i = 1, #tD do
  local a = tD[i]
  local b = asmlib.GetBeautify():Convert(a):Get()
  local c = asmlib.GetBeautify():Beautify(a):Get()
  print(common.stringPadR(tostring(a), 100, " "), common.stringPadR("|"..b.."|", 30, " "), common.stringPadR("|"..c.."|", 20, " "))
end


