local mtAngle = {__type = "Angle", __idx = {"p", "y", "r"}, __ID = 0, __fmt = "[%d]ANG{%f,%f,%f}"}
      mtAngle.__tostring = function(self)
        return mtAngle.__fmt:format(self.ID, self.p, self.y, self.r)
      end
      mtAngle.__index = function(self, aK)
        local cK = mtAngle.__idx[aK]
        return (cK and self[cK] or nil)
      end

function Angle(p,y,r)
  local self = {}; setmetatable(self, mtAngle)
  self.ID = mtAngle.__ID; mtAngle.__ID = mtAngle.__ID + 1
  self.p, self.y, self.r = tonumber(p) or 0, tonumber(y) or 0, tonumber(r) or 0
  function self:Set(p,y,r)
    if(getmetatable(p) == mtAngle) then self.p, self.y, self.r = p.p, p.y, p.r;
    else self.p, self.y, self.r = tonumber(p) or 0, tonumber(y) or 0, tonumber(r) or 0; end
  end
  function self:Negate()
    self.p, self.y, self.r = -self.p, -self.y, -self.r
  end
  function self:IsZero()
    return (self.p == 0 and self.y == 0 and self.r == 0)
  end
  function self:Zero()
    self.p, self.y, self.r = 0, 0, 0
  end
  function self:Forward()
    -- GLua math functions expect radians
    local p = math.rad(self.p)
    local y = math.rad(self.y)

    -- Calculate the forward directional vector components
    local vx = math.cos(p) * math.cos(y)
    local vy = math.cos(p) * math.sin(y)
    local vz = -math.sin(p)

    return Vector(vx, vy, vz)
  end
  function self:Right()
    local p = math.rad(self.p)
    local y = math.rad(self.y)
    local r = math.rad(self.r)

    local vx = -1 * math.sin(r) * math.sin(p) * math.cos(y) + math.cos(r) * math.sin(y)
    local vy = -1 * math.sin(r) * math.sin(p) * math.sin(y) - math.cos(r) * math.cos(y)
    local vz = -1 * math.sin(r) * math.cos(p)

    return Vector(vx, vy, vz)
  end
  function self:Up()
    local p = math.rad(self.p)
    local y = math.rad(self.y)
    local r = math.rad(self.r)

    local vx = math.cos(r) * math.sin(p) * math.cos(y) + math.sin(r) * math.sin(y)
    local vy = math.cos(r) * math.sin(p) * math.sin(y) - math.sin(r) * math.cos(y)
    local vz = math.cos(r) * math.cos(p)

    return Vector(vx, vy, vz)
  end
  function self:RotateAroundAxis(axis, degrees)
    -- 1. Extract current local coordinate space axes from this angle
    local f = self:Forward()
    local r = self:Right()
    local u = self:Up()

    -- 2. Setup axis-angle rotation math variables
    local a = axis:GetNormalized()
    local rad = math.rad(degrees)
    local cosTheta = math.cos(rad)
    local sinTheta = math.sin(rad)
    local oneMinusCos = 1.0 - cosTheta

    -- Helper function to rotate a single 3D vector using Rodrigues' Rotation Formula matrix
    local function rotateVector(v)
      -- Matrix row multiplications
      local x = v.x * (cosTheta + a.x * a.x * oneMinusCos) 
              + v.y * (a.x * a.y * oneMinusCos - a.z * sinTheta) 
              + v.z * (a.x * a.z * oneMinusCos + a.y * sinTheta)

      local y = v.x * (a.y * a.x * oneMinusCos + a.z * sinTheta) 
              + v.y * (cosTheta + a.y * a.y * oneMinusCos) 
              + v.z * (a.y * a.z * oneMinusCos - a.x * sinTheta)

      local z = v.x * (a.z * a.x * oneMinusCos - a.y * sinTheta) 
              + v.y * (a.z * a.y * oneMinusCos + a.x * sinTheta) 
              + v.z * (cosTheta + a.z * a.z * oneMinusCos)

      return Vector(x, y, z)
    end

    -- 3. Rotate our direction vectors into their new orientations
    local rotatedForward = rotateVector(f)
    local rotatedUp      = rotateVector(u)

    -- 4. Feed the new perpendicular vectors into AngleEx to resolve the final Angle
    local newAngle = rotatedForward:AngleEx(rotatedUp)

    -- 5. Mutate the current angle object matching GMod's behavior (or return it)
    self.p = newAngle.p
    self.y = newAngle.y
    self.r = newAngle.r

    return self
  end
  function self:Unpack() return self.p, self.y, self.r end
  function self:SetUnpacked(p, y, r) self.p, self.y, self.r = p, y, r end
  return self
end

RegisterMetaTable(mtAngle.__type, mtAngle)
