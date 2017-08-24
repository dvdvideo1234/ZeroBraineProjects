local __tobool = {["false"] = true, [""] = true, ["0"] = true, ["nil"] = true}
function tobool(any)
  local s = tostring(any); if(__tobool[s]) then return false end return true
end

local mtVector = {__type = "Vector"}
      mtVector.__tostring = function(self) return ("["..self.x..","..self.y..","..self.z.."]") end
local function isVector(a) return (getmetatable(a) == mtVector) end
function Vector(x,y,z)
  local self = {}; setmetatable(self, mtVector)
  self.x, self.y, self.z = tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0
  function self:Mul(n) self.x, self.y, self.z = n*self.x, n*self.y, n*self.z end
  function self:Length() return math.sqrt(self.x^2 + self.y^2 + self.z^2) end
  function self:Dot(v) return (self.x*v.x+self.y*v.y+self.z*v.z) end
  function self:Add(v) self.x, self.y, self.z = (self.x+v.x), (self.y+v.y), (self.z+v.z); return self end
  function self:Sub(v) self.x, self.y, self.z = (self.x-v.x), (self.y-v.y), (self.z-v.z); return self end
  function self:Set(x,y,z)
    if(getmetatable(x) == mtVector) then self.x, self.y, self.z = x.x, x.y, x.z;
    else self.x, self.y, self.z = tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0; end
  end
  function self:Cross(v)
    local x = self.y * v.z - self.z * v.y
    local y = self.z * v.x - self.x * v.z
    local z = self.x * v.y - self.y * v.x
    return Vector(x,y,z) -- self.x, self.y, self.z = x, y, z; return self
  end
  function self:Normalize()
    local m = self:Length()
    if(m ~= 0) then self.x, self.y, self.z = self.x/m, self.y/m, self.z/m end
  end
  function self:GetNormalized()
    local m = self:Length()
    if(m ~= 0) then return Vector(self.x/m, self.y/m, self.z/m) end; return Vector()
  end
  return self
end

mtVector.__add = function(o1,o2)
  local v1 = isVector(o1) and o1 or Vector(o1)
  local v2 = isVector(o2) and o2 or Vector(o2)
  local ov = Vector(); ov:Set(v1); ov:Add(v2); return ov 
end

mtVector.__sub = function(o1,o2)
  local v1 = isVector(o1) and o1 or Vector(o1)
  local v2 = isVector(o2) and o2 or Vector(o2)
  local ov = Vector(); ov:Set(v1); ov:Sub(v2); return ov 
end

mtVector.__mul = function(o1,o2)
  local v1 = isVector(o1) and o1
  local v2 = isVector(o2) and o2
  local ov = Vector()
  if(v1 and v2) then ov:Set(v1); ov:Dot(v2); return ov end
  if(v1 and tonumber(o2)) then ov:Set(v1); ov:Mul(tonumber(o2)); return ov end
  if(v2 and tonumber(o1)) then ov:Set(v2); ov:Mul(tonumber(o1)); return ov end
  print("Cannot preform multiplication between <"..type(o1).."/"..type(o2)..">")
  return ov 
end




function string.Explode(d, s)
  return strExplode(s, d)
end

function string.Trim(s, char)
  local char = char or "%s"
  return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

function math.Round( num, idp )
  local mult = 10 ^ ( idp or 0 )
  return math.floor( num * mult + 0.5 ) / mult
end

function CreateConVar(a, b, c, d)
  local self = {}
  local nam, val, flg, dsc = a, b, c, d
  function self:GetString() return tostring(val) end
  function self:SetString(s) val = tostring(s):rep(1) end
  function self:GetNumber() return tonumber(val) end
  function self:GetBool()   return tobool(val) end
  return self
end

function SysTime() return os.clock() end

function fileOpen(n, m)
  local f = io.open(n, m)
  if(not f) then
    return logStatus("fileOpen: Nofile: "..tostring(n), nil)
  end
  local mt = getmetatable(f)
  mt.Read  = mt.read
  mt.Write = mt.write
  mt.Close = mt.close
  mt.Flush = mt.flush
  return f
end

function fileExists(n)
  local f = fileOpen(n, "r")
  if(f) then
    f:close(); return true; end
  return false
end

function fileAppend(n, c)
  local F = fileOpen(n, "a")
  if(not F) then
    return logStatus("fileAppend: Nofile: "..tostring(n), nil)
  end
  F:seek("end")
  F:write(tostring(c))
  F:flush()
  F:close()
end

function CompileString(s)
  return load(s)
end

function stringTrim( s, char )
  local char = char or "%s"
  return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

function IsValid(anyV) return anyV ~= nil end

function sqlTableExists(anyTable) return true end
function sqlQuery(sQ) return {} end

function utilIsValidModel(sMdl)
  if(string.sub(tostring(sMdl),-4,-1) == ".mdl") then return true end
  return false
end

function math.Clamp(v,a,b)
  if(v <= a) then return a end
  if(v >= b) then return b end 
  return v
end

function fileCreateDir(sPath)
  os.execute("md "..sPath)
  return true
end

function table.GetKeys( tab )
	local keys = {}
	local id = 1
	for k, v in pairs( tab ) do
		keys[ id ] = k
		id = id + 1
	end
	return keys
end

function table.getn( tab )
	local m = 0
	for k, v in pairs( tab ) do
    local n = tonumber(k) if(n and k >= n) then m = n end end
	return m
end