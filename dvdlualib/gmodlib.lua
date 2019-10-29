local common = require("dvdlualib/common")

local language = {__data = {}}
local logStatus = print
local __tools  = {}
local __entity = {}
local __convar = {}
local __nermsg = {}
local __lang   = {}
local Msg      = print
local __type   = type
local __tobool = {["false"] = true, [""] = true, ["0"] = true, ["nil"] = true}

function tobool(any)
  if(__tobool[tostring(any)]) then return false end return true
end

local type = function(any)
  local typ = __type(any)
  if(typ == "table") then local mt = getmetatable(any)
    return (mt.__type and tostring(mt.__type) or typ)
  end; return typ
end

local mtMatrix = {__type = "Matrix"}
      mtMatrix.__tostring = function(self)
        local sM = ""
        for iR = 1, 4 do
          sM = sM.."["..table.concat(self[iR], ",").."]"
          if(self[iR+1]) then sM = sM.."\n" end
        end; return sM
      end
      mtMatrix.__index = mtMatrix
local function isMatrix(a) return (getmetatable(a) == mtMatrix) end
function Matrix()
  local self = {{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}; setmetatable(self, mtMatrix)
  function self:ToTable() local tM = {}
    for iR = 1, 4 do tM[iR] = {}
      for iC = 1, 4 do tM[iR][iC] = self[iR][iC] end
    end; return tM
  end
  
  return self
end

local mtVector = {__type = "Vector", __idx = {"x", "y", "z"}}
      mtVector.__tostring = function(self) return ("VEC{"..self.x..","..self.y..","..self.z.."}") end
      mtVector.__index = function(self, aK)
        local cK = mtVector.__idx[aK]
        return (cK and self[cK] or nil)
      end  
local function isVector(a) return (getmetatable(a) == mtVector) end
function Vector(x,y,z)
  local self = {}; setmetatable(self, mtVector)
  self.x, self.y, self.z = 0, 0, 0
  if(getmetatable(x) == mtVector) then
    self.x, self.y, self.z = x.x, x.y, x.z
  else
    self.x, self.y, self.z = (tonumber(x) or 0), (tonumber(y) or 0), (tonumber(z) or 0)
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
  function self:Normalize() local m = self:Length()
    if(m ~= 0) then self.x, self.y, self.z = self.x/m, self.y/m, self.z/m end
  end
  function self:GetNormalized() local m = self:Length()
    if(m ~= 0) then return Vector(self.x/m, self.y/m, self.z/m) end; return Vector()
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
  if(v1 and v2) then ov:Set(v1); ov:Mul(ov:Dot(v2)); return ov end
  if(v1 and tonumber(o2)) then ov:Set(v1); ov:Mul(tonumber(o2)); return ov end
  if(v2 and tonumber(o1)) then ov:Set(v2); ov:Mul(tonumber(o1)); return ov end
  print("Cannot preform multiplication between <"..type(o1).."/"..type(o2)..">")
  return ov 
end

local mtAngle = {__type = "Angle", __idx = {"p", "y", "r"}}
      mtAngle.__tostring = function(self) return ("ANG{"..self.p..","..self.y..","..self.r.."}") end
      mtAngle.__index = function(self, aK)
        local cK = mtAngle.__idx[aK]
        return (cK and self[cK] or nil)
      end  
local function isAngle(a) return (getmetatable(a) == mtAngle) end
function Angle(p,y,r)
  local self = {}; setmetatable(self, mtAngle)
  self.p, self.y, self.r = tonumber(p) or 0, tonumber(y) or 0, tonumber(r) or 0
  function self:Set(p,y,r)
    if(getmetatable(p) == mtAngle) then self.p, self.y, self.r = p.p, p.y, p.r;
    else self.p, self.y, self.r = tonumber(p) or 0, tonumber(y) or 0, tonumber(r) or 0; end
  end
  return self
end

function CompileFile(nS)
  return loadfile(nS)
end

function string.Explode(separator, str, withpattern)
	if ( separator == "" ) then return totable( str ) end
	if ( withpattern == nil ) then withpattern = false end
	local ret, current_pos = {}, 1
	for i = 1, str:len() do
		local start_pos, end_pos = str:find(separator, current_pos, not withpattern )
		if (not start_pos) then break end
		ret[ i ] = str:sub(current_pos, start_pos - 1 )
		current_pos = end_pos + 1
	end; ret[ #ret + 1 ] = str:sub(current_pos ); return ret
end

function string.GetFileFromFilename( path )
	if (not path:find( "\\" ) and not path:find( "/" ) ) then return path end 
	return path:match( "[\\/]([^/\\]+)$" ) or ""
end

function string.Implode( seperator, Table ) return
	table.concat( Table, seperator )
end

function string.Split( str, delimiter )
	return string.Explode( delimiter, str )
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
  local self = {}; __convar[a] = b
  local nam, val, flg, dsc = a, b, c, d
  function self:GetString() return tostring(val) end
  function self:SetString(s) val = tostring(s):rep(1) end
  function self:GetNumber() return tonumber(val) end
  function self:GetBool()   return tobool(val) end
  function self:GetInt()   return math.floor(tonumber(val) or 0) end
  function self:GetName() return tostring(nam) end
  return self
end

function GetConVar(a)
  return __convar[a]
end

function SysTime() return os.clock() end

function CompileString(s)
  return load(s)
end

function string.Trim( s, char )
  local char = char or "%s"
  return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

function IsValid(anyV) return anyV ~= nil end

function math.Clamp(v,a,b)
  if(v <= a) then return a end
  if(v >= b) then return b end 
  return v
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

function table.Empty(tT)
  for k,v in pairs(tT) do tT[k] = nil end
end

function CurTime() return os.clock() end

function LocalPlayer()
  local self = {}
  function self:IsValid() return true end
  function self:IsPlayer() return true end
  function self:Nick() return "[Sk&Bh]YOLO" end
  function self:PrintMessage(n, m)
    print("[player]["..tostring(n).."] "..tostring(m))
  end
  return self
end

function makeTool(sM)
  local self = {}
  self.Mode = tostring(sM or "")
  self.ClientConVar = {}
  function self:GetClientNumber(sK) return (tonumber(self.ClientConVar[sK]) or 0) end
  function self:GetClientInfo(sK) return tostring(self.ClientConVar[sK] or "") end
  function self:SetClient(sK, vV) self.ClientConVar[sK] = tostring(vV) end
  __tools[self.Mode] = self
  return self
end
  
function RunConsoleCommand(a, b)
  local tB = ("_"):Explode(a)
  if(__convar[a]) then __convar[a] = tostring(b); return end
  __tools[tB[1]]:SetClient(tB[2], b)
end

--------------------------------------------------------------------------------------------------------------------------------
language = {}

function language.Add(key, val)
  __lang[key] = val
end

function language.GetPhrase(key, val)
  __lang[key] = val
end

function language.List() return __lang end

--------------------------------------------------------------------------------------------------------------------------------
cleanup = {}

function cleanup.Register() end

--------------------------------------------------------------------------------------------------------------------------------
util = {}

function util.TraceLine() end
function util.IsValidModel(sMdl)
  if(string.sub(tostring(sMdl),-4,-1) == ".mdl") then return true end
  return false
end
function util.GetPlayerTrace(pl)
  return {}
end

function util.TraceLine(dt)
  return {}
end

--------------------------------------------------------------------------------------------------------------------------------
bit  = {}

function bit.bor() end

--------------------------------------------------------------------------------------------------------------------------------
cvars = {}

function cvars.RemoveChangeCallback() end
function cvars.AddChangeCallback() end

--------------------------------------------------------------------------------------------------------------------------------
file = {}

function file.Open(n, m)
  local s, f, e = pcall(io.open, n, m)
  if(not (s and f)) then
    return logStatus("fileOpen: "..tostring(e), nil)
  end
  local mt = getmetatable(f)
  mt.Read  = mt.read
  mt.Write = mt.write
  mt.Close = mt.close
  mt.Flush = mt.flush
  return f
end

function file.Exists(n)
  local a,b,c,d = pcall(os.execute, "cd "..n)
  if(a and b and c == "exit" and d == 0) then return true end
  local s, f = pcall(fileOpen, n, "rb")
  if(s and f) then f:close(); return true; end
  return false
end

function file.Delete(n)
  local p = common.stringGetFilePath(n)
  local n = common.stringGetFileName(n)
  local a,b,c = os.execute("cd "..p.." && del /f "..n)
end

function file.Append(n, c)
  local F = fileOpen(n, "ab")
  if(not F) then
    return logStatus("fileAppend: Nofile: "..tostring(n), nil)
  end
  F:seek("end")
  F:write(tostring(c))
  F:flush()
  F:close()
end

function file.CreateDir(sPath)
  return os.execute("mkdir "..sPath)
end

--------------------------------------------------------------------------------------------------------------------------------
ents = {}
local mtEntity = {__type = "Entity"}
      mtEntity.__tostring = function(oE) return ("ENT{"..oE:EntIndex().."}{"..oE:GetClass().."}") end
      mtEntity.__index = mtEntity
local function isVector(a) return (getmetatable(a) == mtVector) end
function ents.Create()
  local self = {}; setmetatable(self, mtEntity)
  local mcla = "prop_physics"
  local mid = (#__entity + 1)
  local mpos = Vector(0,0,0)
  local mang = Angle(0,0,0)
  local mmodel = ""
  local matach = {ID = {[1]={["test"]={Pos=Vector(6,6,6), Ang=Angle(7,7,7)}}}, Nam = {["test"] = 1}}
  local mbdygrp = {{id=1},{id=2},data={1,2,3,4,5}}
  function self:GetClass() return mcla end
  function self:SetClass(vC) mcla = vC end
  function self:EntIndex() return mid end
  function self:GetPos() return mpos end
  function self:SetPos(vP) mpos = vP end
  function self:GetAngles() return mang end
  function self:SetAngles(vA) mang = vA end
  function self:IsValid() return true end
  function self:IsPlayer() return false end
  function self:IsVehicle() return false end
  function self:IsNPC() return false end
  function self:IsRagdoll() return false end
  function self:IsWeapon() return false end
  function self:IsWidget() return false end 
  function self:GetBodyGroups() return mbdygrp end
  function self:GetBodygroup(id) return mbdygrp.data[id] end
  function self:SetCollisionGroup() return nil end
  function self:SetSolid() return nil end
  function self:SetMoveType() return nil end
  function self:SetNotSolid() return nil end
  function self:SetNoDraw() return nil end
  function self:SetModel(sM) mmodel = sM end
  function self:GetModel() return mmodel end
  function self:LookupAttachment(sK) return matach.Nam[sK] end
  function self:GetAttachment(iD) return matach.ID[iD] end
  function self:CallOnRemove() return nil end
  table.insert(__entity, mid, self)
  return self
end  

function ents.GetAll()
  return __entity
end

--------------------------------------------------------------------------------------------------------------------------------
net = {}

function net.Start(sK)
  if(__nermsg[sK]) then tableEmpty(__nermsg[sK])
  else __nermsg[sK] = {} end
  __nermsg.__now__key__ = sK
end

function net.Wrte(v)
  local k = __nermsg.__now__key__
  table.insert(__nermsg[k], v)
end

function net.Read()
  local k = __nermsg.__now__key__
  common.logTable(__nermsg, "NET")
  return table.remove(__nermsg[k])
end

function net.ReadEntity()
  return netRead()
end

--------------------------------------------------------------------------------------------------------------------------------
sql = {}

function sql.TableExists(anyTable) return true end
function sql.Query(sQ) return {} end