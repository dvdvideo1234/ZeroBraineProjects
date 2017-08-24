--[[ Terminology source
  http://www.realtimerendering.com/intersections.html#I304
]]--

require("ZeroBraineProjects/dvdlualib/gmodlib")

--[[
This function calculates 3x3 determinant of the args below
Takes three vectors as arguments:
  v1 = {a b c}
  v2 = {d e f}
  v3 = {g h i}
Returns a number: The value if the 3x3 determinant
]]--
local function detVector(v1, v2, v3)
  local a, b, c = v1.x, v1.y, v1.z
  local d, e, f = v2.x, v2.y, v2.z
  local g, h, i = v3.x, v3.y, v3.z
  return ((a*e*i)+(b*f*g)+(d*h*c)-(g*e*c)-(h*f*a)-(d*b*i))
end

--[[
This function traces both lines and if they are not paralel
calculates their point of intersection. Every ray is
determined by an origin /vO/ and direction /vD/
On success returns the legth and point of the closest
intersect distance to the orthogonal connecting line.
A tru center can be calculated by using the last two reurn values
Takes:
  vO1 --> Origin of the first ray
  vD1 --> Direction of the first ray
  vO2 --> Origin of the second ray
  vD2 --> Direction of the second ray
Returns:
  f1 --> Intersection fraction of the first ray
  f2 --> Intersection fraction of the second ray
  x1 --> Intersection closest position of the first ray
  x2 --> Intersection closest position of the second ray
]]--
local function rayIntersect(vO1, vD1, vO2, vD2)
  local d1 = vD1:GetNormalized()
  local d2 = vD2:GetNormalized()
  local dx = d1:Cross(d2)
  local dn = (dx:Length())^2
  if(dn == 0) then print("Rays are paralel"); return nil end
  local f1 = detVector((vO2-vO1),d2,dx) / dn
  local f2 = detVector((vO2-vO1),d1,dx) / dn
  local x1, x2 = (vO1 + d1*f1), (vO2 + d2*f2)
  return f1, f2, x1, x2
end

local ro1 = Vector(-1,-2,0)
local rd1 = Vector(1,0,0)
local ro2 = Vector(3,3,0)
local rd2 = Vector(0,-1,0)

print(rayIntersect(ro1,rd1,ro2,rd2))
























