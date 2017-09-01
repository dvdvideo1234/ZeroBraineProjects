--[[ Terminology source
  http://www.realtimerendering.com/intersections.html#I304
]]--

require("ZeroBraineProjects/dvdlualib/gmodlib")

local function DetVector(vR1, vR2, vR3)
  local a, b, c = vR1.x, vR1.y, vR1.z
  local d, e, f = vR2.x, vR2.y, vR2.z
  local g, h, i = vR3.x, vR3.y, vR3.z
  return ((a*e*i)+(b*f*g)+(d*h*c)-(g*e*c)-(h*f*a)-(d*b*i))
end


local function GetRayCross(vO1, vD1, vO2, vD2)
  local d1 = vD1:GetNormalized()
  local d2 = vD2:GetNormalized()
  local dx = d1:Cross(d2)
  local dn = (dx:Length())^2
  if(dn == 0) then return 7 end
  local f1 = DetVector((vO2-vO1),d2,dx) / dn
  local f2 = DetVector((vO2-vO1),d1,dx) / dn
  local x1, x2 = (vO1 + d1*f1), (vO2 + d2*f2)
  local xx = (x2 - x1); xx:Mul(0.5); xx:Add(x1)
  return f1, f2, x1, x2, xx
end

local ro1 = Vector(-1,-2,1)
local rd1 = Vector(1,0,0)
local ro2 = Vector(3,3,-1)
local rd2 = Vector(0,-1,0)

local f1, f2 = GetRayCross(ro1,rd1,ro2,rd2)

print(f1, f2)


















