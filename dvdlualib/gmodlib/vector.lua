
local mtVector = {__type = "Vector", __idx = {"x", "y", "z"}, __ID = 0, __fmt = "[%d]VEC{%f,%f,%f}"}
      mtVector.__tostring = function(self)
        return mtVector.__fmt:format(self.ID, self.x, self.y, self.z)
      end
      mtVector.__index = function(self, aK)
        local cK = mtVector.__idx[aK]
        return (cK and self[cK] or nil)
      end

function Vector(x,y,z)
  local self = {}; setmetatable(self, mtVector)
  self.x, self.y, self.z = 0, 0, 0
  self.ID = mtVector.__ID; mtVector.__ID = mtVector.__ID + 1
  if(getmetatable(x) == mtVector) then
    self.x, self.y, self.z = x.x, x.y, x.z
  else
    self.x, self.y, self.z = (tonumber(x) or 0), (tonumber(y) or 0), (tonumber(z) or 0)
  end
  function self:DistToSqr(v)
    local x = (self.x - v.x)
    local y = (self.y - v.y)
    local z = (self.z - v.z)
    return x^2 + y^2 + z^2
  end
  function self:Distance(v)
    return math.sqrt(self:DistToSqr(v))
  end
  function self:LengthSqr() return self.x^2 + self.y^2 + self.z^2 end
  function self:Mul(n) self.x, self.y, self.z = n*self.x, n*self.y, n*self.z end
  function self:Div(n) self:Mul(1/n) end
  function self:Length() return math.sqrt(self.x^2 + self.y^2 + self.z^2) end
  function self:Dot(v) return (self.x*v.x+self.y*v.y+self.z*v.z) end
  function self:Add(v) self.x, self.y, self.z = (self.x+v.x), (self.y+v.y), (self.z+v.z); return self end
  function self:Sub(v) self.x, self.y, self.z = (self.x-v.x), (self.y-v.y), (self.z-v.z); return self end
  function self:GetSub(...) local v = Vector(self); v:Sub(...); return v end
  function self:Unpack() return self.x, self.y, self.z end
  function self:SetUnpacked(x, y, z) self.x, self.y, self.z = x, y, z end
  function self:Set(v)
    if(getmetatable(v) == mtVector) then
      self.x, self.y, self.z = v.x, v.y, v.z
    else
      error("Cannot set copy from "..type(v).." to vector!")
    end; return self    
  end
  function self:Negate()
    self.x, self.y, self.z = -self.x, -self.y, -self.z
  end
  function self:Rotate()
  end
  function self:Cross(v)
    local x = self.y * v.z - self.z * v.y
    local y = self.z * v.x - self.x * v.z
    local z = self.x * v.y - self.y * v.x
    return Vector(x,y,z) -- self.x, self.y, self.z = x, y, z; return self
  end
  function self:Normalize() local m = self:Length()
    if(m ~= 0) then self.x, self.y, self.z = self.x/m, self.y/m, self.z/m end
  end
  function self:GetNormalized() local m = self:Length()
    if(m ~= 0) then return Vector(self.x/m, self.y/m, self.z/m) end; return Vector()
  end
  function self:IsZero()
    return (self.x == 0 and self.y == 0 and self.z == 0)
  end
  function self:Zero()
    self.x, self.y, self.z = 0, 0, 0
  end
  function self:Determinant(vec2, vec3)
    local a, b, c = self:Unpack()
    local d, e, f = vec2:Unpack()
    local g, h, i = vec3:Unpack()
    return ((a*e*i)+(b*f*g)+(d*h*c)-(g*e*c)-(h*f*a)-(d*b*i))
  end
  function self:Project(vec)
    local vs = Vector(self)
    self:Set(vec)
    self:Normalize()
    self:Mul(vs:Dot(self))
  end
  function self:GetProject(...)
    local v = Vector(self)
    v:Project(...)
    return v
  end
  function self:AngleBetween(vec, nrm)
    if(nrm == nil) then
      return math.acos(self:Dot(vec) / math.sqrt(self:LengthSqr() * vec:LengthSqr()))
    end
    return math.atan2(self:Determinant(vec, nrm:GetNormalized()), self:Dot(vec))
  end
  
  function self:AngleEx(up)
    -- 1. Ensure our Forward vector is a clean unit vector
    local f = self:GetNormalized()

    -- 2. Find the Right vector via Left-Handed Cross Product: Right = F x Up
    -- In Source Engine: Right = Forward:Cross(Up)
    local r = f:Cross(up):GetNormalized()

    -- 3. Re-calculate clean orthogonal Up vector to guarantee perfectly perpendicular axes
    local u = r:Cross(f):GetNormalized()

    -- 4. Calculate Yaw (Left-Handed system: Yaw acts around Z axis)
    local yaw = math.deg(math.atan2(f.y, f.x))

    -- 5. Calculate Pitch (Pitch down is positive, Pitch up is negative in Source)
    -- Hypotenuse of the horizontal plane
    local hL = math.sqrt(f.x * f.x + f.y * f.y)
    local pitch = math.deg(math.atan2(-f.z, hL))

    -- 6. Calculate Roll (Twist around the Forward vector)
    -- We look at how the Right vector maps against our calculated horizontal yaw plane
    local roll = math.deg(math.atan2(r.z, (u.z * math.cos(math.rad(pitch)))))

    -- Sanity check/fallback: If looking straight up or straight down (Gymbal Lock)
    if hL < 0.001 then
        yaw = math.deg(math.atan2(-r.x, r.y))
        roll = 0
    end

    -- Return the final GMod Angle object
    return Angle(pitch, yaw, roll)
  end
  
  --[[
   * This function traces both lines and if they are not parallel
   * calculates their point of intersection. Every ray is
   * determined by an origin /vO/ and direction /vD/
   * On success returns the length and point of the closest
   * intersect distance to the orthogonal connecting line.
   * The true center is calculated by using the last two return values
   * Takes:
   *   vO1 --> Position origin of the first ray ( self )
   *   vD1 --> Direction of the first ray
   *   vO2 --> Position origin of the second ray
   *   vD2 --> Direction of the second ray
   * Returns:
   *   f1 --> Intersection fraction of the first ray
   *   f2 --> Intersection fraction of the second ray
   *   x1 --> Intersection location of the first ray
   *   x2 --> Intersection location of the second ray
   *   xx --> Intersection location of both rays
  ]]--
  function self:IntersectRay(vD1, vO2, vD2)
    local d1 = vD1:GetNormalized()
    if(d1:Length() == 0) then return nil end
    local d2 = vD2:GetNormalized()
    if(d2:Length() == 0) then return nil end
    local dx, oo = d1:Cross(d2), vO2:GetSub(self)
    local dn = (dx:Length())^2
    if(dn <= 0) then return nil end
    local f1 = oo:Determinant(d2, dx) / dn
    local f2 = oo:Determinant(d1, dx) / dn
    return f1, f2
  end

  return self
end

mtVector.__add = function(o1,o2)
  local v1 = isvector(o1) and o1 or Vector(o1)
  local v2 = isvector(o2) and o2 or Vector(o2)
  local ov = Vector(); ov:Set(v1); ov:Add(v2); return ov
end

mtVector.__sub = function(o1,o2)
  local v1 = isvector(o1) and o1 or Vector(o1)
  local v2 = isvector(o2) and o2 or Vector(o2)
  local ov = Vector(); ov:Set(v1); ov:Sub(v2); return ov
end

mtVector.__mul = function(o1,o2)
  local v1 = isvector(o1) and o1
  local v2 = isvector(o2) and o2
  local ov = Vector()
  if(v1 and v2) then ov:Set(v1); ov:Mul(ov:Dot(v2)); return ov end
  if(v1 and tonumber(o2)) then ov:Set(v1); ov:Mul(tonumber(o2)); return ov end
  if(v2 and tonumber(o1)) then ov:Set(v2); ov:Mul(tonumber(o1)); return ov end
  Msg("Cannot preform multiplication between <"..type(o1).."/"..type(o2)..">")
  return ov
end

RegisterMetaTable(mtVector.__type, mtVector)
