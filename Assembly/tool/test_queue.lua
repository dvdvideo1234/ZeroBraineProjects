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
      
poThQueue = asmlib.GetQueue("THINK")
function poThQueue:Draw()
  local mP, iP = self:GetStart(), 0
  print(mP)
  while(mP) do
    iP = iP + 1
    print(iP, mP.D)
    mP = mP.N
  end
end

poThQueue:Attach(LocalPlayer(), function() end, "A")
poThQueue:Attach(LocalPlayer(), function() end, "B")
poThQueue:Attach(LocalPlayer(), function() end, "C")
poThQueue:Attach(LocalPlayer(), function() end, "D")

poThQueue:Draw()

print(poThQueue)