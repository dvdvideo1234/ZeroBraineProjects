function tobool(any)
  local s = tostring(any)
  if(s == "false") then return false end
  if(s == ""    ) then return false end
  if(s == "0"   ) then return false end; return true
end

function Vector(x,y,z)
  local self = {}
  self.x, self.y, self.z = x,y,z
  return self
end

function string.Explode(d, s)
  return stringExplode(s, d)
end

function CreateConVar(a, b, c, d)
  local self = {}
  local nam, val, flg, dsc = a, b, c, d
  function self:GetString() return tostring(val) end
  function self:GetNumber() return tonumber(val) end
  function self:GetBool()   return tobool(val) end
  return self
end

function fileOpen(n, m)
  local F = io.open(n, m)
  if(not F) then
    return logStatus(nil,"fileOpen: Nofile: "..tostring(n))
  end; return F
end

function fileExists(n)
  local F = fileOpen(n, "r")
  if(F) then
    F:close()
    return true
  end
  return false
end

function fileAppend(n, c)
  local F = fileOpen(n, "a")
  if(not F) then
    return logStatus(nil,"fileAppend: Nofile: "..tostring(n))
  end
  F:seek("end")
  F:write(tostring(c))
  F:flush()
  F:close()
end

function CompileString(s)
  return s
end

function stringTrim( s, char )
  if ( char ) then char = char:PatternSafe() else char = "%s" end
  return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

function IsValid(anyV) return anyV ~= nil end
  