local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("dvdlualib/gmodlib")
local testexec = require("testexec")

local ent = ents.Create("seamless_portal")
function ent:GetSize() return Vector(1,1,1) end
function ent:GetUp() return Vector(1,1,1) end

local eyeAngle = Angle(0,0,0)
function eyeAngle:Forward() return Vector(1,0,0) end

SeamlessPortals = {}

SeamlessPortals.ShouldRender = function(arg)
  local portal, eyePos, distance = arg[1], arg[2], arg[4]
	local portalPos, portalUp, exitSize = portal:GetPos(), portal:GetUp(), portal:GetSize()
	local max = math.max(exitSize[1], exitSize[2])
	return ((eyePos - portalPos):Dot(portalUp) > -max and 
	eyePos:DistToSqr(portalPos) < distance^2 * max and 
	(eyePos - portalPos):Dot(eyeAngle:Forward()) < max)
end

SeamlessPortals.ShouldRenderNew = function(arg)
  local portal, eyePos, distance = arg[1], arg[2], arg[4]
	local portalPos, portalUp, exitSize = portal:GetPos(), portal:GetUp(), portal:GetSize()
  local vec, max = (eyePos - portalPos), math.max(exitSize[1], exitSize[2])
  if((vec):Dot(portalUp) <= -max) then return false end
  if(vec:LengthSqr() >= distance^2 * max) then return false end
  if(vec:Dot(eyeAngle:Forward()) >= max) then return false end
  return true
end

local stEstim = {
  testexec.Case(SeamlessPortals.ShouldRender, "original"),
  testexec.Case(SeamlessPortals.ShouldRenderNew, "modified")
}

local stCard = {
  AcTime = 1, -- Draw a dot after X seconds
  FnCount = 100, -- Amount of loops to be done for the test card
  FnCycle = 100, -- Amount of loops to be done for the function tested
  ExPercn = .1, -- Draw percent completed every X margin ( 0 to 1 )
  {"basic", {ent , Vector(1,1,1), Angle(0,0,0), 10}, false}
}

testexec.Run(stCard,stEstim)
