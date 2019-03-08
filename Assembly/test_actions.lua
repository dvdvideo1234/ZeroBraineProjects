require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
local common = require("../dvdlualib/common")
local asmlib = trackasmlib

asmlib.InitBase("track", "assembly")
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.SetOpVar("DATE_FORMAT","%d-%m-%y")
asmlib.SetOpVar("TIME_FORMAT","%H:%M:%S")
asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("S",4,5,6,7)
asmlib.SetOpVar("DIRPATH_BAS", "Assembly/")
asmlib.SetLogControl(1000,false)


netStart("asdf")

function CLEAR_RELATION(nLen) local oPly = netReadEntity()
  asmlib.LogInstance("{"..tostring(nLen)..","..tostring(oPly).."}")
  if(not asmlib.IntersectRayClear(oPly, "relate")) then
    asmlib.LogInstance("Failed clearing ray"); return nil end
  asmlib.LogInstance("Success"); return nil
end

asmlib.SetOpVar("TEST", CLEAR_RELATION)

asmlib.GetOpVar("TEST")(3)

