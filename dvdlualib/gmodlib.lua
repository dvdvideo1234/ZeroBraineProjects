local common = require("dvdlualib/common")

local language = {__data = {}}
local logStatus = print
local __tools = {}
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
  if(typ == "table") then
    local mt = getmetatable(any)
    if(mt) then
      return (mt.__type and tostring(mt.__type) or typ) end
    return __type(any) end
  return __type(any)
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
      mtVector.__tostring = function(self) return ("["..self.x..","..self.y..","..self.z.."]") end
      mtVector.__index = function(self, aK)
        local cK = mtVector.__idx[aK]
        return (cK and self[cK] or nil)
      end  
local function isVector(a) return (getmetatable(a) == mtVector) end
function Vector(x,y,z)
  local self = {}; setmetatable(self, mtVector)
  self.x, self.y, self.z = (tonumber(x) or 0), (tonumber(y) or 0), (tonumber(z) or 0)
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
  function self:Normalize() local m = self:Length()
    if(m ~= 0) then self.x, self.y, self.z = self.x/m, self.y/m, self.z/m end
  end
  function self:GetNormalized() local m = self:Length()
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
  if(v1 and v2) then ov:Set(v1); ov:Mul(ov:Dot(v2)); return ov end
  if(v1 and tonumber(o2)) then ov:Set(v1); ov:Mul(tonumber(o2)); return ov end
  if(v2 and tonumber(o1)) then ov:Set(v2); ov:Mul(tonumber(o1)); return ov end
  print("Cannot preform multiplication between <"..type(o1).."/"..type(o2)..">")
  return ov 
end

local mtAngle = {__type = "Angle", __idx = {"p", "y", "r"}}
      mtAngle.__tostring = function(self) return ("["..self.p..","..self.y..","..self.r.."]") end
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
  return self
end

function GetConVar(a)
  return __convar[a]
end

function SysTime() return os.clock() end

function fileOpen(n, m)
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

function fileExists(n)
  local a,b,c,d = pcall(os.execute, "cd "..n)
  if(a and b and c == "exit" and d == 0) then return true end
  local s, f = pcall(fileOpen, n, "rb")
  if(s and f) then f:close(); return true; end
  return false
end

function fileDelete(n)
  local p = common.stringGetFilePath(n)
  local n = common.stringGetFileName(n)
  local a,b,c = os.execute("cd "..p.." && del /f "..n)
end

function fileAppend(n, c)
  local F = fileOpen(n, "ab")
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
  return os.execute("mkdir "..sPath)
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

function languageAdd(key,val)
  language.__data[key] = val
end

function languageGetPhrase(key)
  local a = language.__data[key]; print(key); return a
end

function CurTime() return os.clock() end

function makePlater()
  local self = {}
  function self:IsValid() return true end
  function self:IsPlayer() return true end
  function self:Nick() return "YOLO" end
  return self
end

function LocalPlayer() return makePlater() end

function makeEntity()
  local self = {}
  local __cla = "prop_physics"
  function self:GetClass() return __cla end
  function self:SetClass(vC) __cla = vC end
  local __pos = Vector(0,0,0)
  local __ang = Angle(0,0,0)
  function self:GetPos() return __pos end
  function self:SetPos(vP) __pos = vP end
  function self:GetAngles() return __ang end
  function self:SetAngles(vA) __ang = vA end
  function self:IsValid() return true end
  function self:IsPlayer() return false end
  function self:IsVehicle() return false end
  function self:IsNPC() return false end
  function self:IsRagdoll() return false end
  function self:IsWeapon() return false end
  function self:IsWidget() return false end 
  local __bdygrp = {{id=1},{id=2},data={1,2,3,4,5}}
  function self:GetBodyGroups() return __bdygrp end
  function self:GetBodygroup(id) return __bdygrp.data[id] end
  function self:SetCollisionGroup() return nil end
  function self:SetSolid() return nil end
  function self:SetMoveType() return nil end
  function self:SetNotSolid() return nil end
  function self:SetNoDraw() return nil end
  local __model = ""
  local __atach = {ID = {[1]={["test"]={Pos=Vector(6,6,6), Ang=Angle(7,7,7)}}}, Nam = {["test"] = 1}}
  function self:SetModel(sM) __model = sM end
  function self:GetModel() return __model end
  function self:LookupAttachment(sK) return __atach.Nam[sK] end
  function self:GetAttachment(iD) return __atach.ID[iD] end
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

function utilGetPlayerTrace(pl)
  return {}
end

function utilTraceLine(dt)
  return {}
end

function entsCreate() return makeEntity() end

function RunConsoleCommand(a, b)
  local tB = ("_"):Explode(a)
  if(__convar[a]) then __convar[a] = tostring(b); return end
  __tools[tB[1]]:SetClient(tB[2], b)
end

function netStart(sK)
  if(__nermsg[sK]) then tableEmpty(__nermsg[sK])
  else __nermsg[sK] = {} end
  __nermsg.__now__key__ = sK
end

function netWrte(v)
  local k = __nermsg.__now__key__
  table.insert(__nermsg[k], v)
end

function netRead()
  local k = __nermsg.__now__key__
  common.logTable(__nermsg, "NET")
  return table.remove(__nermsg[k])
end

function netReadEntity()
  return netRead()
end

function CompileFile(nS)
  return loadfile(nS)
end

function languageAdd(key, val)
  __lang[key] = val
end

function languageGetPhrase(key, val)
  __lang[key] = val
end

cleanup = {}
cleanup.Register = function() end