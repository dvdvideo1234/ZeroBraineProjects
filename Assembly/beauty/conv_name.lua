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

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)

require("gmodlib")
require("trackasmlib")
asmlib = trackasmlib
if(not asmlib) then error("No library") end
asmlib.IsModel = function(m) return isstring(m) end
asmlib.InitBase("track","assembly")
require("Assembly/autorun/config")

asmlib.SetLogControl(20000, false)

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


