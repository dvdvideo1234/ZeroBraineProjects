local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)
      
require("gmodlib")
require("laserlib")
local asmlib = require("trackasmlib")
      
asmlib.InitBase("track", "assembly")
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.SetOpVar("DATE_FORMAT","%d-%m-%y")
asmlib.SetOpVar("TIME_FORMAT","%H:%M:%S")
asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("S",4,5,6,7)
asmlib.SetOpVar("DIRPATH_BAS", "Assembly/")
asmlib.SetLogControl(1000,false)
      
poThQueue = asmlib.GetQueue("THINK")
function poThQueue:Draw()
  local mS = self:GetStart()
  local mE = self:GetEnd()
  local mP, iP = mS, 0
  print("["..mS.D.."]>["..mE.D.."]")
  while(mP) do
    iP = iP + 1
    print(iP, mP.D)
    mP = mP.N
  end
end

poThQueue:Attach(LocalPlayer(), {}, function() end, "A")
poThQueue:Attach(LocalPlayer(), {}, function() end, "B")
poThQueue:Attach(LocalPlayer(), {}, function() end, "C")
poThQueue:Attach(LocalPlayer(), {}, function() end, "D")

poThQueue:Draw()
poThQueue:Retain()
poThQueue:Draw()