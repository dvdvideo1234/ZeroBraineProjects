local __tobool = {["false"] = true, [""] = true, ["0"] = true, ["nil"] = true}
function tobool(any)
  local s = tostring(any); if(__tobool[s]) then return false end return true
end

local mtVector = {__type = "Vector"}
      mtVector.__tostring = function(self) return (self.x..","..self.y..","..self.z) end
function Vector(x,y,z)
  local self = {}; setmetatable(self, mtVector)
  self.x, self.y, self.z = tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0
  function self:Mul(n) self.x, self.y, self.z = n*self.x, n*self.y, n*self.z end
  function self:Length() return math.sqrt(self.x^2 + self.y^2 + self.z^2) end
  return self
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