FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY, FCVAR_REPLICATED = 0, 0, 0, 0

MAT_SNOW       = 0
MAT_GRATE      = 0
MAT_CLIP       = 0
MAT_METAL      = 0
MAT_VENT       = 0
MAT_GLASS      = 0
MAT_WARPSHIELD = 0

local common = require("common")
local luafs = require("lfs")
local logStatus = print
local __noval  = "N/A"
local __tools  = {}
local __convar = {}
local __nermsg = {}
local __lang   = {}
local __type   = type
local __tobool = {["false"] = true, [""] = true, ["0"] = true, ["nil"] = true}
local __metatb = {}

game = {__single = true}
language = {}
cleanup = {}
util = {}
bit  = {}
cvars = {__data={}}
file = {}
ents = {}
properties = {__data= {}}
sql = {}
net = {}
resource = {}
constraint = {}
concommand = {__data = {}}
hook = {__data = {}}

local function print_x(...)
  local args = {...}
  for i = 1, #args do
    args[i] = tostring(args[i])
  end
  io.write(table.concat(args, "\t"))
  io.flush() -- Forces the output to display immediately
end

Msg      = print_x
MsgN     = print
MsgC     = print_x

function RegisterMetaTable(n, m)
  if(not (n and m)) then return end
  __metatb[n] = m
end

function FindMetaTable(n)
  if(not n) then return end
  return __metatb[n]
end

function ErrorNoHalt(m)
  print("ERROR: "..tostring(m))
end

function Error(m)
  error(tostring(m))
end

function tobool(any)
  if(__tobool[tostring(any)]) then return false end return true
end

function Color(r,g,b,a)
  return {r=r,g=g,b=b,a=a}
end

function RealTime()
  return os.clock()
end

local UselessModels = {
	"_gesture", "_anim", "_gst", "_pst", "_shd", "_ss", "_posture", "_anm",
	"ghostanim","_paths", "_shared", "anim_", "gestures_", "shared_ragdoll_"
}

function IsUselessModel( modelname )
	modelname = modelname:lower()
	if (not modelname:find( ".mdl", 1, true ) ) then return true end
	for k, v in ipairs( UselessModels ) do
		if ( modelname:find( v, 1, true ) ) then
			return true
		end
	end
	return false
end

function AddCSLuaFile(...)
  common.logStatus("AddCSLuaFile: {"..table.concat({...}, "|").."}")
end

function DamageInfo(...)
end

function Sound(...)
end


function include(...)
  common.logStatus("include: {"..table.concat({...}, "|").."}")
end

type = function(any)
  local mt = getmetatable(any)
  if(mt and mt.__type) then
    return tostring(mt.__type)
  else return __type(any) end
end

function CompileFile(nS)
  return loadfile(nS)
end

function math.Round( num, idp )
  local mult = 10 ^ ( idp or 0 )
  return math.floor( num * mult + 0.5 ) / mult
end

function CreateConVar(a, b, c, d)
  local self = {}; __convar[a] = self
  local nam, val, flg, dsc = a, b, c, d
  function self:SetData(dat)
    local new = tostring(dat or ""):rep(1)
    local tab = (cvars.__data[nam] or {})
    for k, v in pairs(tab) do
      v(nam, val, new)
    end; val = new; return self
  end
  function self:GetString() return tostring(val) end
  function self:GetNumber() return (tonumber(val) or 0) end
  function self:GetBool() return tobool(tonumber(val) or 0) end
  function self:GetInt() return math.floor(tonumber(val) or 0) end
  function self:GetName() return tostring(nam) end
  function self:GetFloat() return (tonumber(val) or 0) end
  return self
end

function GetConVar(a)
  return __convar[a]
end

function SysTime() return os.clock() end

function CompileString(sSrc, sID, bEr)
    sID = sID or "CompileString"
    if bEr == nil then bEr = true end

    -- ZBS / Lua 5.1 requires loadstring to compile code chunks from strings
    local coFn, err
    if _VERSION == "Lua 5.1" and not jit then
        -- Native Lua 5.1 fallback
        coFn, err = loadstring(sSrc, "@" .. sID)
    else
        -- LuaJIT / Lua 5.2+ (What ZBS mostly uses under the hood)
        coFn, err = load(sSrc, "@" .. sID)
    end

    -- Handle Syntax/Compilation Errors safely
    if not coFn then
        local fmrEr = string.format("[CompileString] %s", err or "Unknown syntax error")
        if bEr then
            -- Print directly to the ZBS Output/Console panel
            print(fmrEr) 
        end
        return fmrEr
    end

    -- Optional: If the ZBS debugger is running, inject it into the compiled function's environment
    if mobdebug and type(mobdebug.setup) == "function" then
        -- This allows ZBS to track line breakpoints inside the compiled string chunk
        mobdebug.on()
    end

    return coFn
end

function IsValid(anyV) return anyV ~= nil end

function math.Clamp(v,a,b)
  if(v <= a) then return a end
  if(v >= b) then return b end
  return v
end

function math.Remap( value, inMin, inMax, outMin, outMax )
	return outMin + ( ( ( value - inMin ) / ( inMax - inMin ) ) * ( outMax - outMin ) )
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

function table.Copy(tab, lookup)
	if(tab == nil) then return nil end

	local copy, lookup = {}, (lookup or {})
	setmetatable(copy, debug.getmetatable(tab))
	for i, v in pairs(tab) do
		if(not istable(v)) then
			copy[i] = v
		else
			lookup[tab] = copy
			if(lookup[v]) then
				copy[i] = lookup[v]
			else
				copy[i] = table.Copy(v, lookup)
			end
		end
	end
	return copy
end

function CurTime() return os.clock() end

function LocalPlayer()
  local self = ents.Create("gmod_player")
  function self:IsValid() return true end
  function self:IsPlayer() return true end
  function self:Nick() return "[Sk&Bh]YOLO" end
  function self:PrintMessage(n, m)
    Msg("[player]["..tostring(n).."] "..tostring(m))
  end
  function self:ConCommand(a)
    Msg("[player:"..self:Nick().."]ConCommand(\""..tostring(a:gsub("\n","|")).."\")")
  end
  function self:SendLua(sCode)
    Msg("[player:"..self:Nick().."]"..sCode)
  end
  return self
end

function makeTool(sM)
  local self = {}
  local convars = {}
  self.Mode = tostring(sM or "")
  self.ClientConVar = {}
  function self:GetClientNumber(sK) return (tonumber(self.ClientConVar[sK]) or 0) end
  function self:GetClientInfo(sK) return tostring(self.ClientConVar[sK] or "") end
  function self:SetClient(sK, vV) self.ClientConVar[sK] = tostring(vV) end
  function self:BuildConVarList(tV)
    for k, v in pairs(self.ClientConVar) do convars[self.Mode .. "_" .. k] = v end
    return convars
  end
  __tools[self.Mode] = self
  return self
end

function RunConsoleCommand(a, b)
  local tB = ("_"):Explode(a)
  if(__convar[a]) then __convar[a] = tostring(b); return end
  __tools[tB[1]]:SetClient(tB[2], b)
end

function language.Add(key, val)
  __lang[key] = val
end

function language.GetPhrase(key)
  return (__lang[key] or __noval)
end

function language.List() return __lang end

function cleanup.Register() end

function util.IsValidModel(sMdl)
  if(string.sub(tostring(sMdl),-4,-1) == ".mdl") then return true end
  return false
end

function util.GetPlayerTrace(pl)
  return {}
end

function util.TraceLine(dt)
  return {
    Entity = 0,
    Fraction = 1,
    FractionLeftSolid = 0,
    Hit = false,
    HitBox = 0,
    HitGroup = 0,
    HitNoDraw = false,
    HitNonWorld = false,
    HitNormal = Vector(0,0,1),
    HitPos = Vector(10,10,10),
    HitSky = false,
    HitTexture = "**studio**",
    HitWorld = false,
    MatType = 0,
    Normal = 0.5,
    PhysicsBone = 0,
    StartPos = Vector(0,0,0),
    SurfaceProps = 0,
    StartSolid = false,
    AllSolid = false,
    SurfaceFlags = 0,
    DispFlags = 0,
    Contents = 0    
  }
end

function util.AddNetworkString()
end

function bit.bor() end

function cvars.RemoveChangeCallback(sVar, sKey)
  cvars.__data[sVar] = nil
end

function cvars.AddChangeCallback(sVar, fFoo, sKey)
  local tVar = cvars.__data[sVar]
  if(not tVar) then
    cvars.__data[sVar] = {}
    tVar = cvars.__data[sVar]
  end
  tVar[sKey] = fFoo -- sVar, vOld, vNew
end

function file.Open(n, m)
  local s, f, e = pcall(io.open, n, m)
  if(not (s and f)) then
    return logStatus("file.Open("..m.."): "..tostring(e))
  end
  local mt = getmetatable(f)
  mt.Write = mt.write
  mt.Close = mt.close
  mt.Flush = mt.flush
  mt.ReadLine = function(f) return f:read("*line") end
  mt.EndOfFile = function(f)
    local p = f:seek() -- Store position
    local t = f:read(); f:seek("set", p)
    return common.getPick(t, false, true)
  end
  mt.Read = function(f)
    return f:read("*all")
  end
  mt.Tell = function(f)
    return f:seek()
  end
  mt.Seek = function(f, n)
    return f:seek("set", n)
  end
  mt.Size = function(f)
    local c = f:seek()
    local s = f:seek("end") 
    f:seek("set", c)
    return s
  end
  return f
end

function file.Exists(n)
  local a,b,c,d = pcall(os.execute, "cd "..n.." >nul 2>&1")
  if(a and b and c == "exit" and d == 0) then return true end
  local s, f = pcall(io.open, n, "rb")
  if(s and f) then f:close(); return true; end
  return false
end

function file.IsDir(n)
  if(type(n) ~= "string") then return false end
  local s, r = pcall(os.execute, "cd /d "..n)
  if(not s) then r = false end
  if(not r) then r = false end
  return r
end

function file.Delete(n)
  local p = common.stringGetFilePath(n)
  local n = common.stringGetFileName(n)
  local a,b,c = os.execute("cd "..p.." && del /f "..n.." >nul 2>&1")
end

function file.Append(n, c)
  local F = file.Open(n, "ab")
  if(not F) then
    return logStatus("file.Append: Nofile: "..tostring(n))
  end
  F:seek("end")
  F:write(tostring(c))
  F:flush()
  F:close()
end

function file.CreateDir(path)
-- Normalize backslashes to forward slashes for consistent parsing
    local norm = path:gsub("[\\/]+", "/")
          norm = norm:gsub("%.%./", "")
          norm = norm:gsub("^[/]+" , "")
          norm = norm:gsub("[/]+$", "")
    
    local accumulated = ""
    
    -- Preserve leading slash for absolute paths
    if norm:sub(1, 1) == "/" then
        accumulated = "/"
    end
    
    for dir in norm:gmatch("[^/]+") do
        if accumulated == "" or accumulated == "/" then
            accumulated = accumulated .. dir
        else
            accumulated = accumulated .. "/" .. dir
        end
        
        -- Check if the directory already exists
        local mode = lfs.attributes(accumulated, "mode")
        if not mode then
            local ok, err = lfs.mkdir(accumulated)
            if not ok then
                return nil, err
            end
        elseif mode ~= "directory" then
            return nil, "Path exists and is not a directory: " .. accumulated
        end
    end
    
    return true
end

function file.Find(sName, sPath, sSort)
  local sSrt, sArg = tostring(sSort or ""), ""
  local sCol = (sSort and sSrt:sub(1,4) or nil)
  local sMod = (sSort and sSrt:sub(5,-1) or nil)
  if(sMod) then sMod = ((sMod == "desc") and "-" or "") end
  if(sCol == "date" or sCol == "name") then
    sArg = " /O:"..sMod..sCol:sub(1,1):upper()
  end; return common.fileFind(sName, sArg)
end

function file.Time(sF)
  return lfs.attributes(sF, "modification") or 0
end

function properties.Add(sN, tD)
  properties.__data[sN] = tD
  return tD
end

function net.Start(sK)
  if(__nermsg[sK]) then tableEmpty(__nermsg[sK])
  else __nermsg[sK] = {} end
  __nermsg.__now__key__ = sK
end

function net.Write(v)
  local k = __nermsg.__now__key__
  table.insert(__nermsg[k], v)
end

function net.Read()
  local k = __nermsg.__now__key__
  common.logTable(__nermsg, "NET")
  return table.remove(__nermsg[k])
end

function net.ReadEntity()
  return net.Read()
end

function net.Receive()
  return true
end

function sql.TableExists(anyTable) return true end
function sql.Query(sQ) return {} end
function sql.Begin() return nil end
function sql.Commit() return nil end

function game.SinglePlayer(vS)
  if(vS ~= nil) then game.__single = common.toBool(vS) end
  return game.__single
end

function game.GetWorld()
  if(game.__world) then return __world end
  game.__world = ents.Create("game_worldspawn")
  game.__world.IsValid = function(weld) return false end
  return game.__world
end

function constraint.Weld(e1, e2, b1, b2, frc, noc, bdel)
  local w = ents.Create("constraint_weld")
  w.E1, w.E2 = e1, e2
  w.B1, w.B2 = b1, b2
  w.F , w.N,  w.D = frc, noc, tobool(bdel)
  return w
end

function constraint.NoCollide(e1, e2, b1, b2)
  local n = ents.Create("constraint_nocollide")
  n.E1, n.E2 = e1, e2
  n.B1, n.B2 = b1, b2
  return n
end

function resource.AddSingleFile(...)
  common.logStatus("resource.AddSingleFile: {"..table.concat({...}, "|").."}")
end

function include(sP)
  require(common.stringStripExtension(common.stringGetFileName(sP)))
end

function ErrorNoHaltWithStack(sM)
  error(sM)
end

function concommand.Add(vI, vF)
  concommand.__data[vI] = vF
end

function hook.Add(vI, vF)
  hook.__data[vI] = vF
end

function RunString(sSrc, sID, bEr)
  local sID = sID or "RunString"
  local fR, sE = loadstring(sSrc, sID)
  if(not fR) then error(("[%s] %s"):format(sID, sE or "Compile error")) end
  local bS, sE = pcall(fR)
  if(not bS) then error(("[%s] %s"):format(sID, sE or "Syntax error")) end
  return true
end

--- INITIALIZATION ---

function FindMetaTable(cn)
  for iD = 1, #__metatb do
    local vD = __metatb[iD]
    if(vD and vD.__type == cn) then
      return vD
    end
  end; return nil
end

CreateConVar("gmod_language")

require("gmodlib/hook")
require("gmodlib/math")
require("gmodlib/type")
require("gmodlib/file")
require("gmodlib/table")
require("gmodlib/enums")
require("gmodlib/string")
require("gmodlib/surface")
require("gmodlib/math/ease")
require("gmodlib/color")
require("gmodlib/vector")
require("gmodlib/angle")
require("gmodlib/matrix")
require("gmodlib/entity")

local __typedt = {
  {"number"},
  {"string"},
  {"boolean", "bool"},
  {"function"},
  {"table"}
}

for k, v in pairs(__metatb) do
  table.insert(__typedt, {v.__type, v.__type:lower()})
end

for i = 1, #__typedt do
  local v = __typedt[i]
  local n =("is"..(v[2] or v[1])) 
  local f = function(x) return type(x) == v[1] end
  print("Define:", n)
  rawset(_G, n, f)
end

require("gmodlib/derma")
require("gmodlib/vgui")
require("gmodlib/constants")
require("gmodlib/duplicator")
require("gmodlib/concommand")


